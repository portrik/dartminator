import 'dart:convert' show utf8;
import 'dart:io' as io;
import 'dart:isolate';
import 'dart:async';

import 'package:grpc/grpc.dart';

import 'package:dartminator/generated/dartminator.pbgrpc.dart';
import 'package:dartminator/generated/dartminator.pb.dart';

import 'computation.dart';
import 'constants.dart';
import 'logger.dart';

class ChildHandlerData {
  final ReceivePort port;
  final io.InternetAddress child;
  final String argument;

  ChildHandlerData(this.port, this.child, this.argument);
}

class MainHandlerData {
  final ReceivePort port;
  final String argument;

  MainHandlerData(this.port, this.argument);
}

class DartminatorNode extends NodeServiceBase {
  // Type of the computation
  static Computation computation = TestComputation();

  // Logger
  var logger = getLogger();

  // Node specific settings
  String name;
  int discoveryPort;
  int maxChildren;

  // Internally handled variables
  final List<io.InternetAddress> _children = [];
  var _isComputing = false;

  DartminatorNode(this.name, this.discoveryPort, this.maxChildren) {
    logger.i('Created Node $name for the ${computation.name} computation.');
  }

  /// Initializes the node to be used on the network.
  ///
  /// Prepares the node to be used over the local network for computation.
  /// This means listening for incoming connections to a computation.
  Future<void> init() async {
    await listenForConnections();
  }

  /// Starts the computation on this node and redistributes arguments to child nodes.
  ///
  /// Stops listening for incoming computation connections and starts the computation.
  /// Returns when all of the possible results are computed.
  Future<String> start(String seed) async {
    logger.i('Starting the computation with seed $seed.');

    var completed = computation
        .finalizeResult(await compute(computation.getArguments(seed)));

    logger
        .i('All of the computations are completed. The result is: $completed.');

    return completed;
  }

  /// Computes all of the results on this node and potential child nodes.
  ///
  /// Computes the results through isolates handling local and child computations.
  /// The local computation uses [handleMainComputation].
  /// Any children found are assigned their arguments and their computation is handled
  /// through [handleChildComputation].
  Future<List<String>> compute(List<String> arguments) async {
    logger.i('Starting the computation with ${arguments.length} arguments.');
    _isComputing = true;

    var results = List<String>.generate(arguments.length, (_index) => '');

    // Stops when all of the results are computed
    while (results.where((element) => element.isNotEmpty).length <
        arguments.length) {
      var workers = <Future<String?>>[];

      var index = results.lastIndexWhere((element) => element.isEmpty);
      ReceivePort mainPort = ReceivePort();

      if (index > -1) {
        Map<String, dynamic> mainData = {};
        mainData['port'] = mainPort.sendPort;
        mainData['argument'] = arguments[index];

        workers.add(mainPort.listen((data) {
          results[index] = data ?? '';
          mainPort.close();
        }).asFuture<String?>());

        // Starts a new isolate for the current node computation
        await Isolate.spawn(handleMainComputation, mainData);
      }

      // If there is a space for children, new ones are added
      // Subtracting one since the main node takes one argument
      var childLimit =
          (results.where((element) => element.isEmpty).length - 1) < maxChildren
              ? (results.where((element) => element.isEmpty).length - 1)
              : maxChildren;

      if (_children.length < childLimit) {
        logger.i('Redistributing the computation to child nodes.');

        // Looks for children until the timeout is reached
        await findChildren(childLimit).timeout(
          childSearchTimeout,
          onTimeout: () {
            logger.d(
                'The child search has finished with ${_children.length} child nodes.');
          },
        );

        // Assigns arguments until all child nodes are working
        for (var i = 0; i < _children.length; ++i) {
          var port = ReceivePort();
          var index = results.lastIndexWhere((element) => element.isEmpty);

          if (index > -1) {
            Map<String, dynamic> data = {};
            var child = _children[i];
            data['port'] = port.sendPort;
            data['child'] = child;
            data['argument'] = arguments[index];

            workers.add(port.listen((data) {
              results[index] = data ?? '';

              logger.d(
                  'The computation of child $child has finished with $data.');

              _children.remove(child);
              port.close();
            }).asFuture<String?>());

            // Starts a new isolate to handle the child connection
            await Isolate.spawn(handleChildComputation, data);
          }
        }
      }

      await Future.wait(workers);
      logger.i(
          'Finished computation cycle. ${arguments.length - results.where((element) => element.isNotEmpty).length} chunks remaining.');
    }

    _isComputing = false;
    return results;
  }

  /// Tries to find a child nodes for the computation on the local network.
  ///
  /// Sends out a broadcast message over the local network looking for child nodes.
  /// If a node responds, it is added to [_children] and an acknowledgement is sent back.
  Future<void> findChildren(int limit) async {
    logger.d('Starting the search for children.');

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

            logger.d(
                'Child Search: Got response from $responderName at ${response.address}');

            // Prevents from connecting to self
            // To already connected node
            // Or reaching the connection limit
            if (responderName != name &&
                !_children.contains(response.address) &&
                _children.length < maxChildren) {
              logger.d(
                  'Adding $responderName at ${response.address} to children!');

              _children.add(response.address);

              // Closes the socket as it is not needed anymore.
              if (_children.length >= limit) {
                socket.close();
              }
            }
          }
        }
      } catch (err, stacktrace) {
        logger.e('Could not parse incoming message!\n$err\n$stacktrace');
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
  /// On acknowledgement, the listening for a connection is paused until the computation finishes.
  /// The listening is paused during computation and restarted after it finishes.
  Future<void> listenForConnections() async {
    var socket = await io.RawDatagramSocket.bind(
        io.InternetAddress.anyIPv4, discoveryPort);
    socket.readEventsEnabled = true;

    logger.i('Listening for potential computation on port $discoveryPort.');

    socket.listen((event) {
      try {
        if (event == io.RawSocketEvent.read) {
          var response = socket.receive();

          if (response != null) {
            logger.d(
                'Computation listening response: ${utf8.decode(response.data)}');

            var payload = utf8.decode(response.data).split('-')[1];

            if (payload.split('Name')[1] != name) {
              logger.d(
                  'Found a new potential computation from ${payload.split('Name')[1]} at ${response.address}.');

              socket.send('Dartminator-Name$name'.codeUnits, response.address,
                  response.port);
            }
          }
        }
      } catch (err, stacktrace) {
        logger.e(
            'Could not parse response during computation listening!\n$err\n$stacktrace');
      }
    });
  }

  /// Handles the gRPC communication with a child node.
  ///
  /// Creates a gRPC connection to the child and listens for the heartbeat.
  /// When the result is delivered, the channel is closed and the result is returned over the Isolate port.
  /// If the connection fails, mostly due to the connection timeout,
  /// the connection is closed and null is returned over the Isolate port.
  static Future handleChildComputation(Map<String, dynamic> data) async {
    var logger = getLogger();
    SendPort port = data['port'];

    try {
      logger.d('Started child handler for ${data['child']}.');

      // Creates the gRPC channel on the port 50051 with no credentials
      ClientChannel clientChannel = ClientChannel(data['child'],
          port: grpcPort,
          options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
              connectionTimeout: grpcCallTimeout));
      // Creates the Dartminator Node stub to use for communication
      NodeClient child = NodeClient(clientChannel,
          options: CallOptions(timeout: grpcCallTimeout));

      String? result;
      var responses =
          child.initiate(ComputationArgument(argument: data['argument']));

      // Listens to responses from the child node
      await for (var response in responses) {
        logger.d('Response from child ${data['child']}: $response');

        if (response.empty) {
          logger.w('The child ${data['child']} is already in a computation!');
          break;
        }

        if (response.result.done) {
          logger.d(
              'The child ${data['child']} has finished with ${response.result.result}.');

          result = response.result.result;
          break;
        }
      }

      await clientChannel.shutdown();
      port.send(result);
    } catch (err, stacktrace) {
      logger.e('The connection with a child has failed!\n$err\n$stacktrace');

      port.send(null);
    }
  }

  /// Handles the main computation.
  ///
  /// Computes the result and returns it over the Isolate port.
  /// In case of failure, null is returned over the Isolate port.
  static Future handleMainComputation(Map<String, dynamic> data) async {
    var logger = getLogger();
    SendPort port = data['port'];

    try {
      logger.d(
          'Starting main node computation from the argument ${data['argument']}.');

      var result = await DartminatorNode.computation.compute(data['argument']);

      logger.d('This node\'s computation has completed with the result $data.');

      port.send(result);
    } catch (err, stacktrace) {
      logger.e('The main computation has thrown an error!\n$err\n$stacktrace');

      port.send(null);
    }
  }

  @override
  Stream<ComputationHeartbeat> initiate(
      ServiceCall call, ComputationArgument request) async* {
    logger.d('Heartbeat request: $request');

    if (_isComputing) {
      logger.i(
          'Received a heartbeat request while in a computation. Returning empty response.');

      yield ComputationHeartbeat(empty: true);
    }

    logger.i('Starting the computation as a child.');
    String? result;

    compute(computation.getArguments(request.argument)).then((results) {
      result = computation.finalizeResult(results);
    });

    while (result == null) {
      logger.i(
          'Still computing. Returning an empty heartbeat and waiting for $calculationTimeout.');

      var response = await Future.delayed(calculationTimeout,
          () => ComputationHeartbeat(result: ComputationResult(done: false)));
      yield response;
    }

    logger.i('Finished computation. Returning heartbeat with the result.');
    logger.i('Listening to new computation connections.');
    yield ComputationHeartbeat(
        result: ComputationResult(done: true, result: result));
  }

  bool isComputing() => _isComputing;
}
