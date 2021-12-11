import 'dart:io';

import 'package:dartminator/computation.dart';
import 'package:grpc/grpc.dart';

import 'package:dartminator/dartminator.dart';
import 'package:dartminator/constants.dart';
import 'package:dartminator/logger.dart';
import 'package:dartminator/cli.dart';

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
      await node.start('STARTER');
      exit(0);
    }
  } catch (err, stacktrace) {
    logger.e('The node has failed terribly!');
    logger.e(err);
    logger.e(stacktrace);
  }
}
