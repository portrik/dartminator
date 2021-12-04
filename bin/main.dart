import 'dart:io';

import 'package:faker/faker.dart';
import 'package:grpc/grpc.dart';

import './Dartminator.dart';
import './Logger.dart';

Future<void> main(List<String> args) async {
  var logger = getLogger();
  var faker = Faker();
  var name = faker.person.name();
  var port = 8080;
  var maxChildren = 2;

  try {
    stdout.write('Welcome to Dartminator.');

    stdout.write('Select the name of the node. It should be unique: ($name)');
    var newName = stdin.readLineSync();
    if (newName != null && newName.isNotEmpty) {
      name = newName;
    }

    stdout.write('Select the discovery port of the node: ($port)');
    var newPort = stdin.readLineSync();
    if (newPort != null && newPort.isNotEmpty && !int.parse(newPort).isNaN) {
      port = int.parse(newPort);
    }

    stdout.write('Select the limit of children for the node: ($maxChildren)');
    var newMax = stdin.readLineSync();
    if (newMax != null && newMax.isNotEmpty && !int.parse(newMax).isNaN) {
      maxChildren = int.parse(newMax);
    }

    final node = DartminatorNode(name, port, maxChildren);

    final server = Server([node], const <Interceptor>[],
        CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]));

    logger.i('Starting the node $name on port $port (gRPC listening on 50051)');

    await server.serve(port: 50051);
    node.init();
  } catch (err, stacktrace) {
    logger.e('The node has failed terribly!');
    logger.e(err);
    logger.e(stacktrace);
  }
}
