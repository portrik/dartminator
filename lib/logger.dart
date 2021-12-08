import 'dart:io' as io;

import 'package:logger/logger.dart';

// Custom filter is used to disable the default one using assert
class CustomFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

// Writer used to store logs into a file
class FileWriter {
  io.File file;

  FileWriter(String name) : file = io.File(name);

  void writeLine(String line) {
    file.writeAsStringSync('$line\n', mode: io.FileMode.append);
  }
}

// Custom log output to write logs both to console and file
class CustomOutput extends LogOutput {
  FileWriter fileWriter;

  CustomOutput(String fileName) : fileWriter = FileWriter(fileName);

  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      if (event.level != Level.debug && event.level != Level.verbose) {
        io.stdout.writeln(line);
      }

      fileWriter.writeLine(line);
    }
  }
}

Logger getLogger() {
  return Logger(
      printer: PrettyPrinter(
          colors: false,
          printTime: true,
          lineLength: 120,
          errorMethodCount: 8,
          methodCount: 2,
          printEmojis: false),
      output: CustomOutput('log.txt'),
      level: Level.debug,
      filter: CustomFilter());
}
