import 'dart:io' as io;
import 'dart:convert';

import 'package:logger/logger.dart';

/// Custom filter used instead of the default Logger one.
///
/// A custom filter is needed to remove the dependency on the default filter
/// which uses assert and thus can't be used in production.
class CustomFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

/// Custom log output to write logs both to console and file.
///
/// A class handling the logging to both console and file outputs.
/// Both debug and verbose level messages are not logged to console
/// and are only written to files.
///
/// The file to which to append the messages is set by the [fileName] argument.
class CustomOutput extends LogOutput {
  io.File file;

  CustomOutput(String fileName) : file = io.File(fileName);

  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      if (event.level != Level.debug && event.level != Level.verbose) {
        var decoded = jsonDecode(line);
        io.stdout.writeln(
            '[${DateTime.fromMillisecondsSinceEpoch(decoded['time']).toLocal()}] ${decoded['level']}:\t${decoded['msg']}');
      }

      file.writeAsStringSync('$line\n', mode: io.FileMode.append);
    }
  }
}

class CustomPrinter extends LogPrinter {
  static final levelNames = {
    Level.verbose: 'Verbose',
    Level.debug: 'Debug',
    Level.info: 'Info',
    Level.warning: 'Warning',
    Level.error: 'Error',
    Level.wtf: 'WTF'
  };

  @override
  List<String> log(LogEvent event) {
    var output = {
      'level': levelNames[event.level],
      'time': DateTime.now().millisecondsSinceEpoch,
      'msg': event.message.toString()
    };

    return [jsonEncode(output)];
  }
}

Logger getLogger() {
  return Logger(
      printer: CustomPrinter(),
      output: CustomOutput('log.txt'),
      level: Level.debug,
      filter: CustomFilter());
}
