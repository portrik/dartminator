import 'dart:io' as io;
import 'dart:convert' show utf8;

import 'package:grpc/src/server/call.dart';
import 'package:logger/logger.dart';
import 'package:grpc/grpc.dart';

import '../lib/src/generated/google/protobuf/empty.pb.dart';
import '../lib/src/generated/dartminator.pbgrpc.dart';
import '../lib/src/generated/dartminator.pb.dart';

Logger getLogger() {
  return Logger(
      printer: PrettyPrinter(
          colors: io.stdout.supportsAnsiEscapes,
          printTime: true,
          lineLength: io.stdout.terminalColumns,
          errorMethodCount: 8,
          methodCount: 2,
          printEmojis: io.stdout.supportsAnsiEscapes),
      output: ConsoleOutput(),
      level: Level.debug);
}

class DartminatorNode extends NodeServiceBase {
  var logger = getLogger();

  late ClientChannel channel;
  late NodeClient stub;

  String name = '';
  int discoveryPort = 8000;

  List<DartminatorNode> childNodes = [];
  var isComputing = false;

  DartminatorNode(String name, int discoveryPort) {
    this.name = name;
    this.discoveryPort = discoveryPort;

    channel = ClientChannel('localhost',
        port: 50051,
        options: ChannelOptions(credentials: ChannelCredentials.insecure()));
    stub = NodeClient(channel,
        options: CallOptions(timeout: Duration(seconds: 30)));
  }

  @override
  Future<Empty> sendComputationEnd(
      ServiceCall call, Acknowledgement request) async {
    // TODO: Remove child from the list
    logger.i('Received computation end message.');

    return new Empty();
  }

  @override
  Future<Acknowledgement> initiateComputation(
      ServiceCall call, ComputationalMessage request) async {
    this.logger.i('Received message of computation initiation.');

    var ack = Acknowledgement();

    // Already included in the computation
    // Returns acknowledgement
    if (isComputing) {
      ack.finished = ComputationFinished();
      ack.finished.done = false;

      this.logger.i('Already in a computation. Sending empty response.');

      return ack;
    }

    // TODO: Start the computation
    isComputing = true;

    this.logger.i('Started the computation.');

    // Nothing is returned as the computation is not finished yet
    // But gRPC requires to return something thus sending empty request
    ack.nothing = new Empty();
    return ack;
  }

  // Function advertising this node over the network on the selected port
  Future<Null> nodeAdvertising() async {
    var datagramSocket = await io.RawDatagramSocket.bind(
        io.InternetAddress.anyIPv4, discoveryPort);
    datagramSocket.readEventsEnabled = true;

    logger.i('Advertising on port $discoveryPort');

    datagramSocket.listen((event) {
      if (event == io.RawSocketEvent.read) {
        var dg = datagramSocket.receive();

        if (dg != null) {
          datagramSocket.send(dg.data, dg.address, dg.port);

          logger.i('${dg.address}:${dg.port} -- ${utf8.decode(dg.data)}');
        }
      }
    });
  }

  // Function looking for nodes over the local network via broadcast
  Future<Null> nodeDiscovery() async {
    var datagramSocket =
        await io.RawDatagramSocket.bind(io.InternetAddress.anyIPv4, 0);
    datagramSocket.broadcastEnabled = true;
    datagramSocket.readEventsEnabled = true;

    datagramSocket.listen((event) {
      if (event == io.RawSocketEvent.read) {
        var dg = datagramSocket.receive();

        if (dg != null) {
          logger.i('${dg.address}:${dg.port} -- ${utf8.decode(dg.data)}');
        }
      }
    });

    datagramSocket.send("DARTMINATOR DISCOVERY MESSAGE".codeUnits,
        io.InternetAddress("255.255.255.255"), this.discoveryPort);
  }
}

Future<void> main(List<String> args) async {
  var logger = getLogger();

  try {
    var name = args[0];
    var port = int.parse(args[1]);

    final node = DartminatorNode(name, port);

    final server = Server([node], const <Interceptor>[],
        CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]));

    logger.i('Starting node on port $port (gRPC listening on 50051)');

    await server.serve(port: 50051);

    if (args.length > 2) {
      node.nodeAdvertising();
    } else {
      node.nodeDiscovery();
    }
  } catch (e) {
    logger.e('Could not start Node!');
    logger.e(e);
  }
}
