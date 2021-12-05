import 'dart:async';
import 'dart:io' as io;
import 'dart:convert' show utf8;

import 'package:grpc/grpc.dart';

import 'package:dartminator/generated/google/protobuf/empty.pb.dart';
import 'package:dartminator/generated/dartminator.pbgrpc.dart';
import 'package:dartminator/generated/dartminator.pb.dart';

import 'constants.dart';
import 'logger.dart';

class DartminatorNode extends NodeServiceBase {
  var logger = getLogger();

  String name = '';
  int discoveryPort = 8000;
  int maxChildren;

  NodeClient? root;
  List<NodeClient> children = [];
  var isComputing = false;

  late StreamSubscription<io.RawSocketEvent> childrenStream;

  DartminatorNode(this.name, this.discoveryPort, this.maxChildren) {
    logger.i('Initialized Node "$name"');
  }

  Future<void> init() async {
    await findRoot().timeout(rootSearchTimeout, onTimeout: () {
      logger.i('Could not find root within the time limit. Ending the search.');
    });
    await listenForChildren();
  }

  /// Tries to find a root node in the local network.
  ///
  /// Sends out a broadcast message over the local network looking for a root node.
  /// If a node responds, it is added as [root] and an acknowledgement is sent back.
  /// Otherwise no root is set and [findRoot] is terminated by the higher level function
  /// as a result of a Future timeout.
  Future<void> findRoot() async {
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
                utf8.decode(response.data).split('-')[1].split('Name')[1];

            logger.i(
                'Root Search: Got response from $responderName at ${response.address}');

            // The root is added only when a root does not already exist
            if (responderName != name && root == null) {
              logger.i('Adding $responderName as root.');

              // Creates the gRPC channel on the port 50051 with no credentials
              // And timeout of 30 seconds
              ClientChannel rootChannel = ClientChannel(response.address,
                  port: grpcPort,
                  options: const ChannelOptions(
                      credentials: ChannelCredentials.insecure()));
              // Creates the Dartminator Node stub to use for communication
              root = NodeClient(rootChannel,
                  options: CallOptions(timeout: grpcCallTimeout));

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
    socket.send('Dartminator-Name$name'.codeUnits,
        io.InternetAddress("255.255.255.255"), discoveryPort);

    // Waits for the stream to finish.
    await stream;
  }

  /// Constantly listens for new potential children to add.
  ///
  /// Listens on the [discoveryPort] for new potential child nodes.
  /// If a new node is found, a response with the name of this node is sent back.
  /// On receiving the acknowledgement from the child, it is added to the list.
  /// New children will not be added or listened to, if the maximum limit is reached.
  Future<void> listenForChildren() async {
    var socket = await io.RawDatagramSocket.bind(
        io.InternetAddress.anyIPv4, discoveryPort);
    socket.readEventsEnabled = true;

    logger.i('Listening for potential children on port $discoveryPort.');

    childrenStream = socket.listen((event) {
      try {
        if (event == io.RawSocketEvent.read) {
          var response = socket.receive();

          if (response != null) {
            var payload = utf8.decode(response.data).split('-')[1];

            if (payload == 'RootAdded') {
              logger.i('Added a new child at ${response.address}.');
              // Creates the gRPC channel on the port 50051 with no credentials
              // And timeout of 30 seconds
              ClientChannel childChannel = ClientChannel(response.address,
                  port: grpcPort,
                  options: ChannelOptions(
                      credentials: ChannelCredentials.insecure()));

              // Creates the Dartminator Node stub to use for communication
              var child = NodeClient(childChannel,
                  options: CallOptions(timeout: grpcCallTimeout));
              children.add(child);

              // Stop accepting new children when the limit is reached
              if (children.length >= maxChildren) {
                childrenStream.pause();
              }
            } else if (payload.split('Name')[1] != name) {
              logger.i('Found a new potential child at ${response.address}.');
              socket.send('Dartminator-Name$name'.codeUnits, response.address,
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

  @override
  Stream<ComputationHeartbeat> initiate(ServiceCall call, ComputationArgument request) {
    // TODO: implement initiate
    throw UnimplementedError();
  }
}
