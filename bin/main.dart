import 'package:grpc/grpc.dart';
import 'dart:math';

import 'package:dartminator/dartminator.dart';
import 'package:dartminator/computation.dart';
import 'package:dartminator/constants.dart';
import 'package:dartminator/logger.dart';
import 'package:dartminator/cli.dart';

class TestComputation implements Computation {
  @override
  String name = 'Test';

  @override
  Future<String> compute(String argument) async {
    var rng = Random();

    await Future.delayed(Duration(seconds: rng.nextInt(20)));

    return 'FINISHED';
  }

  @override
  String finalizeResult(List<String> results) {
    return 'FINISHED';
  }

  @override
  String getArgument(String source) {
    return 'START';
  }

  @override
  List<String> getChildArguments(String argument, int childCount) {
    return List<String>.generate(childCount, (index) => 'START');
  }
}

Future<void> main(List<String> args) async {
  var logger = getLogger();

  try {
    var options = startupCLI(args);

    final node = DartminatorNode(
        options.name, options.port, options.maxChildren, TestComputation());

    final server = Server([node], const <Interceptor>[],
        CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]));

    logger.i('Starting the node ${options.name}');

    await server.serve(port: grpcPort);
    await node.init();

    if (options.start) {
      await node.start('start');
    }
  } catch (err, stacktrace) {
    logger.e('The node has failed terribly!');
    logger.e(err);
    logger.e(stacktrace);
  }
}
