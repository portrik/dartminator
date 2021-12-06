import 'dart:convert' show utf8;
import 'dart:io' as io;
import 'dart:isolate';
import 'dart:async';

import 'package:grpc/grpc.dart';

import 'package:dartminator/generated/google/protobuf/empty.pb.dart';
import 'package:dartminator/generated/dartminator.pbgrpc.dart';
import 'package:dartminator/generated/dartminator.pb.dart';

import 'computation.dart';
import 'constants.dart';
import 'logger.dart';

class DartminatorNode extends NodeServiceBase {
  var logger = getLogger();

  String name;
  Computation computation;
  int discoveryPort;
  int maxChildren;

  // TODO: Change to tuple so the connection can be closed on computation end
  NodeClient? root;
  List<NodeClient> children = [];
  var isComputing = false;

  // TODO: Prevent from connecting to self or a child - may be connected to Isolates
  late StreamSubscription<io.RawSocketEvent> listeningStream;

  DartminatorNode(
      this.name, this.discoveryPort, this.maxChildren, this.computation) {
    logger.i('Created Node $name for the ${computation.name} computation.');
  }

  Future<void> init() async {
    logger.i('Initializing $name.');
    await listenForConnections();
  }

  Future<String> start(String argument) async {
    logger.i('Starting the computation.');

    await findChildren().timeout(
      childSearchTimeout,
      onTimeout: () {
        logger.i(
            'The child search reached its time limit and has been terminated.');
      },
    );

    if (!listeningStream.isPaused) {
      listeningStream.pause();
    }

    logger.i(
        'Starting the computation on this node with ${children.length} children.');
    // TODO: Finalize Isolate spawning
    var computations = <Future<Isolate>>[];

    isComputing = true;

    var arguments = computation.getChildArguments(argument, children.length);
    for (var i = 0; i < children.length; ++i) {
      var argMap = {};
      argMap['child'] = children[i];
      argMap['argument'] = arguments[i];

      computations.add(Isolate.spawn(handleChildComputation, argMap));
    }

    var results = await Future.wait(computations);
    isComputing = false;

    var computationResult =
        computation.finalizeResult(results.whereType<String>().toList());

    logger
        .i('The computation has finished with the result $computationResult.');

    logger.i('Listening to computation requests.');
    listeningStream.resume();

    return computationResult;
  }

  /// Tries to find a child nodes for the computation on the local network.
  ///
  /// Sends out a broadcast message over the local network looking for child nodes.
  /// If a node responds, it is added to [children] and an acknowledgement is sent back.
  Future<void> findChildren() async {
    logger.i('Starting the search for children.');

    // Socket used to send and receive messages
    var socket = await io.RawDatagramSocket.bind(io.InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true;
    socket.readEventsEnabled = true;

    // A stream handling the communication with potential children.
    // asFuture is used to synchronize the behavior with other async functions.
    var stream = socket.listen((event) {
      try {
        if (event == io.RawSocketEvent.read) {
          var response = socket.receive();

          if (response != null) {
            var responderName =
                utf8.decode(response.data).split('-')[1].split('Name')[1];

            logger.i(
                'Child Search: Got response from $responderName at ${response.address}');

            // The root is added only when a root does not already exist
            if (responderName != name && children.length < maxChildren) {
              logger.i('Adding $responderName as a child.');

              // Creates the gRPC channel on the port 50051 with no credentials
              ClientChannel rootChannel = ClientChannel(response.address,
                  port: grpcPort,
                  options: ChannelOptions(
                      credentials: ChannelCredentials.insecure(),
                      connectionTimeout: grpcCallTimeout));

              // Creates the Dartminator Node stub to use for communication
              children.add(NodeClient(rootChannel,
                  options: CallOptions(timeout: grpcCallTimeout)));

              // Sends the acknowledgement back to the root
              socket.send('Dartminator-ChildAdded'.codeUnits, response.address,
                  response.port);

              // Closes the socket as it is not needed anymore.
              if (children.length >= maxChildren) {
                socket.close();
              }
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

  /// Starts the socket to listen for potential computation connections.
  ///
  /// Listens on the [discoveryPort] for new potential connections.
  /// If a connection request appears, a response with the name of this node is sent back.
  /// On receiving the acknowledgement from the initiator, it is added as [root].
  /// The listening is paused during computation and restarted after it finishes.
  Future<void> listenForConnections() async {
    var socket = await io.RawDatagramSocket.bind(
        io.InternetAddress.anyIPv4, discoveryPort);
    socket.readEventsEnabled = true;

    logger.i('Listening for potential computation on port $discoveryPort.');

    listeningStream = socket.listen((event) {
      try {
        if (event == io.RawSocketEvent.read) {
          var response = socket.receive();

          if (response != null) {
            var payload = utf8.decode(response.data).split('-')[1];

            if (payload == 'ChildAdded') {
              logger.i('Added the root at ${response.address}.');
              // Creates the gRPC channel on the port 50051 with no credentials
              ClientChannel rootChannel = ClientChannel(response.address,
                  port: grpcPort,
                  options: ChannelOptions(
                      credentials: ChannelCredentials.insecure(),
                      connectionTimeout: grpcCallTimeout));

              // Creates the Dartminator Node stub to use for communication
              root = NodeClient(rootChannel,
                  options: CallOptions(timeout: grpcCallTimeout));

              listeningStream.pause();
            } else if (payload.split('Name')[1] != name) {
              logger.i(
                  'Found a new potential computation from ${payload.split('Name')[1]} at ${response.address}.');

              socket.send('Dartminator-Name$name'.codeUnits, response.address,
                  response.port);
            }
          }
        }
      } catch (err, stacktrace) {
        logger.e('Could not parse response during computation listening!');
        logger.e(err);
        logger.e(stacktrace);
      }
    });
  }

  Future<String?> handleChildComputation(Map<dynamic, dynamic> args) async {
    try {
      NodeClient child = args['child'];
      String argument = args['argument'];

      var stream = child.initiate(ComputationArgument(argument: argument));

      await for (var response in stream) {
        logger.i(response.toString());
        if (response.result.done) {
          return response.result.result;
        }
      }
    } catch (err, stacktrace) {
      logger.e('The connection with a child has failed.');
      logger.e(err);
      logger.e(stacktrace);
    }
  }

  @override
  Stream<ComputationHeartbeat> initiate(
      ServiceCall call, ComputationArgument request) async* {
    if (isComputing) {
      yield ComputationHeartbeat(empty: Empty());
    }

    isComputing = true;
    String? result;
    start(request.argument).then((value) {
      result = value;
    });

    if (result == null) {
      yield ComputationHeartbeat(result: ComputationResult(done: false));
    } else {
      yield ComputationHeartbeat(
          result: ComputationResult(done: true, result: result));
    }
  }
}
