import 'dart:io';

import 'package:dartminator/constants.dart';
import 'package:faker/faker.dart';

class CLIOptions {
  String name = Faker().person.name();

  int port = 8080;

  int maxChildren = 2;
  int childSearchTimeout = 1;

  bool start = false;
}

/// Handles the startup CLI options.
///
/// [args] arguments coming from the command line.
///
/// Returns parsed CLIOptions to be used by the node.
///
/// Parses the CLI options into a more usable CLIOptions format.
/// Can exit the process in case the help flag is passed.
CLIOptions startupCLI(List<String> args) {
  var options = CLIOptions();

  if (args.contains('-h') || args.contains('--help')) {
    stdout.writeln('Dartminator CLI Arguments:\n');
    stdout.writeln('-h / --help\t\t\tPrint out this message\n');
    stdout.writeln('-s / --start\t\t\tStarts the computation.');
    stdout.writeln(
        '-i / --interactive\t\tStarts the node in the interactive mode.');
    stdout.writeln(
        '-n / --name [NAME]\t\tSets the name of the node. Should be unique inside the network');
    stdout.writeln(
        '-p / --port [PORT]\t\tSets the port over which the nodes are discovered');
    stdout.writeln(
        '-m / --max [MAX]\t\tSets the maximum number of children the node can have');
    stdout.writeln('-s / --start\t\t\tStarts the computation.');

    stdout.writeln('\nAdditional arguments:');
    stdout.writeln(
        '--grpc [PORT]\t\t\tSets the port over which the gRPC will run. (50051)');
    stdout.writeln(
        '--grpc-timeout [SECONDS]\tSets the timeout of a gRPC connection in seconds. (100)');
    stdout.writeln(
        '--search-length [SECONDS]\tSets the timeout of a child node search in seconds. (1)');
    stdout.writeln(
        '--heartbeat-timeout [SECONDS]\tSets the delay between heartbeats during a computation in seconds. (1)');
    exit(0);
  }

  if (args.contains('-n') || args.contains('--name')) {
    var index = args.indexOf('-n');

    if (index < 0) {
      index = args.indexOf('--name');
    }

    options.name = args[index + 1];
  }

  if (args.contains('-p') || args.contains('--port')) {
    var index = args.indexOf('-p');

    if (index < 0) {
      index = args.indexOf('--port');
    }

    options.port = int.parse(args[index + 1]);
  }

  if (args.contains('-m') || args.contains('--max')) {
    var index = args.indexOf('-m');

    if (index < 0) {
      index = args.indexOf('--max');
    }

    options.maxChildren = int.parse(args[index + 1]);
  }

  if (args.contains('-s') || args.contains('--start')) {
    options.start = true;
  }

  if (args.contains('--grpc')) {
    var index = args.indexOf('--grpc');
    grpcPort = int.parse(args[index + 1]);
  }

  if (args.contains('--grpc-timeout')) {
    var index = args.indexOf('--grpc-timeout');
    grpcCallTimeout = Duration(seconds: int.parse(args[index + 1]));
  }

  if (args.contains('--search-length')) {
    var index = args.indexOf('--search-length');
    childSearchTimeout = Duration(seconds: int.parse(args[index + 1]));
  }

  if (args.contains('--heartbeat-timeout')) {
    var index = args.indexOf('--heartbeat-timeout');
    heartbeatTimeout = Duration(seconds: int.parse(args[index + 1]));
  }

  return options;
}
