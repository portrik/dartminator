import 'dart:math';

abstract class Computation {
  String name;

  Computation(this.name);

  List<String> getArguments(String seed);

  Future<String> compute(String argument);

  String finalizeResult(List<String> results);
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
  String finalizeResult(List<String> results) {
    return 'FINISHED';
  }

  @override
  List<String> getArguments(String seed) {
    return List<String>.generate(
        seed == 'STARTER' ? 2 : 1, (_index) => 'COMPUTE');
  }
}
