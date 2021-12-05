import 'dart:io';

import 'package:faker/faker.dart';

class CLIOptions {
  bool interactive = false;
  String name = Faker().person.name();
  int port = 8080;
  int maxChildren = 2;
}

CLIOptions handleCLI(List<String> args) {
  var options = CLIOptions();

  if (args.contains('-h') || args.contains('--help')) {
    stdout.writeln('Dartminator CLI Arguments:\n');
    stdout.writeln('-h / --help\t\tPrint out this message');
    stdout.writeln('-i / --interactive\tStart in the interactive mode');
    stdout.writeln(
        '-n / --name [NAME]\tSets the name of the node. Should be unique inside the network');
    stdout.writeln(
        '-p / --port [PORT]\tSets the port over which the nodes are discovered');
    stdout.writeln(
        '-m / --max [MAX]\tSets the maximum number of children the node can have');
    exit(0);
  }

  if (args.contains('-i') || args.contains('--interactive')) {
    options.interactive = true;
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

  return options;
}
