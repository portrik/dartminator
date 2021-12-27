import 'dart:math';

/// Computation defines the necessary attributes and methods for a distributed algorithm.
abstract class Computation {
  /// Name of the computation, mostly used for human-readable logging.
  String name;

  Computation(this.name);

  /// Generates a list of arguments from which the nodes can compute.
  List<String> getArguments(String seed);

  /// Computes the result from an argument.
  Future<String> compute(String argument);

  /// Completes the results together.
  Future<String> finalizeResult(List<String> results);
}

class TestComputation implements Computation {
  @override
  String name = 'Test';

  @override
  Future<String> compute(String argument) async {
    var rng = Random();

    await Future.delayed(Duration(seconds: rng.nextInt(5)));

    return 'FINISHED';
  }

  @override
  Future<String> finalizeResult(List<String> results) async {
    return 'FINISHED';
  }

  @override
  List<String> getArguments(String seed) {
    return List<String>.generate(
        seed == 'STARTER' ? 4 : 1, (_index) => 'COMPUTE');
  }
}
