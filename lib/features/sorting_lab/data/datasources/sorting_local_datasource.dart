import 'dart:math';

class SortingLocalDatasource {
  /// Generate a random list of integers
  List<int> generateRandom({int length = 8, int max = 100}) {
    final rnd = Random();
    return List.generate(length, (_) => rnd.nextInt(max));
  }
}
