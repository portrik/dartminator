import 'dart:io' as io;

import 'package:logger/logger.dart';

// TODO: Remove the dependency on asserts
// TODO: Log to files
Logger getLogger() {
  return Logger(
      printer: PrettyPrinter(
          colors: io.stdout.supportsAnsiEscapes,
          printTime: true,
          lineLength: 120,
          errorMethodCount: 8,
          methodCount: 2,
          printEmojis: io.stdout.supportsAnsiEscapes),
      output: ConsoleOutput(),
      level: Level.debug);
}
