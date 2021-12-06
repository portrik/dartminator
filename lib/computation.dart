abstract class Computation {
  String name;

  Computation(this.name);

  String getArgument(String source);

  List<String> getChildArguments(String argument, int childCount);

  Future<String> compute(String argument);

  String finalizeResult(List<String> results);
}
