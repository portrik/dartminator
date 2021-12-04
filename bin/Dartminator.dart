import 'dart:io' as io;
import 'dart:convert' show utf8;

import 'package:grpc/src/server/call.dart';
import 'package:faker/faker.dart';
import 'package:grpc/grpc.dart';

import '../lib/src/generated/google/protobuf/empty.pb.dart';
import '../lib/src/generated/dartminator.pbgrpc.dart';
import '../lib/src/generated/dartminator.pb.dart';

import './Logger.dart';

class DartminatorNode extends NodeServiceBase {
  var logger = getLogger();

  String name = '';
  int discoveryPort = 8000;
  int maxChildren;

  NodeClient? root;

  List<NodeClient> children = [];
  var isComputing = false;

  DartminatorNode(this.name, this.discoveryPort, this.maxChildren) {
    logger.i('Initialized Node "$name"');
  }

  Future<Null> init() async {
    await findRoot().timeout(const Duration(seconds: 5), onTimeout: () {
      logger.i('Could not find root within the time limit. Ending the search.');
    });

    await listenForChildren();
  }

  @override
  Future<Empty> sendComputationEnd(
      ServiceCall call, Acknowledgement request) async {
    // TODO: Remove child from the list
    logger.i('Received computation end message.');
    logger.i(call);
    logger.i(request);

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

  /// Tries to find a root node in the local network.
  ///
  /// Sends out a broadcast message over the local network looking for a root node.
  /// If a node responds, it is added as [root] and an acknowledgement is sent back.
  /// Otherwise no root is set and [findRoot] is terminated by the higher level function
  /// as a result of a Future timeout.
  Future<Null> findRoot() async {
    logger.i('Starting the search for a root.');

    // Socket used to send and receive messages
    var socket = await io.RawDatagramSocket.bind(io.InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true;
    socket.readEventsEnabled = true;

    // A stream handling the communication with potential roots.
    // asFuture is used to synchronize the behavior with other async functions.
    var stream = socket.listen((event) {
      try {
        if (event == io.RawSocketEvent.read) {
          var response = socket.receive();

          if (response != null) {
            var responderName =
                utf8.decode(response.data).split('-')[1].split('Name')[0];

            logger.i(
                'Root Search: Got response from $responderName at ${response.address}');

            // The root is added only when a root does not already exist
            if (responderName != name && root == null) {
              logger.i('Adding $responderName as root.');

              // Creates the gRPC channel on the port 50051 with no credentials
              // And timeout of 30 seconds
              ClientChannel rootChannel = ClientChannel(response.address,
                  port: 50051,
                  options: const ChannelOptions(
                      credentials: ChannelCredentials.insecure()));
              // Creates the Dartminator Node stub to use for communication
              root = NodeClient(rootChannel,
                  options: CallOptions(timeout: const Duration(seconds: 30)));

              // Sends the acknowledgement back to the root
              socket.send('Dartminator-RootAdded'.codeUnits, response.address,
                  response.port);

              // Closes the socket as it is not needed anymore.
              socket.close();
            }
          }
        }
      } catch (err, stacktrace) {
        logger.e('Could not parse incoming message!');
        logger.e(err);
        logger.e(stacktrace);
      }
    }).asFuture();

    // Sends out the broadcast message with it's own name.
    socket.send('Dartminator-Name${name}'.codeUnits,
        io.InternetAddress("255.255.255.255"), this.discoveryPort);

    // Waits for the stream to finish.
    await stream;
  }

  /// Constantly listens for new potential children to add.
  ///
  /// Listens on the [discoveryPort] for new potential child nodes.
  /// If a new node is found, a response with the name of this node is sent back.
  /// On receiving the acknowledgement from the child, it is added to the list.
  /// New children will not be added or listened to, if the maximum limit is reached.
  Future<Null> listenForChildren() async {
    var socket = await io.RawDatagramSocket.bind(
        io.InternetAddress.anyIPv4, discoveryPort);
    socket.readEventsEnabled = true;

    logger.i('Listening for potential children on port $discoveryPort.');

    socket.listen((event) {
      try {
        if (event == io.RawSocketEvent.read && children.length < maxChildren) {
          var response = socket.receive();

          if (response != null) {
            var payload = utf8.decode(response.data).split('-')[1];

            if (payload == 'RootAdded') {
              logger.i('Added a new child at ${response.address}.');
              // Creates the gRPC channel on the port 50051 with no credentials
              // And timeout of 30 seconds
              ClientChannel childChannel = ClientChannel(response.address,
                  port: 50051,
                  options: ChannelOptions(
                      credentials: ChannelCredentials.insecure()));

              // Creates the Dartminator Node stub to use for communication
              children.add(NodeClient(childChannel,
                  options: CallOptions(timeout: const Duration(seconds: 30))));
            } else if (payload.split('Name') != name) {
              logger.i('Found a new potential child at ${response.address}.');
              socket.send('Dartminator-Name${name}'.codeUnits, response.address,
                  response.port);
            }
          }
        }
      } catch (err, stacktrace) {
        logger.e('Could not parse response during child listening!');
        logger.e(err);
        logger.e(stacktrace);
      }
    });
  }
}

Future<void> main(List<String> args) async {
  var logger = getLogger();
  var faker = Faker();

  final port = 8080;

  try {
    final node = DartminatorNode(faker.person.name(), port, 2);

    final server = Server([node], const <Interceptor>[],
        CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]));

    logger.i('Starting node on port $port (gRPC listening on 50051)');

    await server.serve(port: 50051);
    node.init();
  } catch (e, stacktrace) {
    logger.e('The node failed terribly!');
    logger.e(e);
    logger.e(stacktrace);
  }
}
