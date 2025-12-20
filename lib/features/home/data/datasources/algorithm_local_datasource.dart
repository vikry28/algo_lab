import '../models/algorithm_model.dart';

abstract class AlgorithmLocalDataSource {
  Future<List<AlgorithmModel>> getAlgorithms();
}

class AlgorithmLocalDataSourceImpl implements AlgorithmLocalDataSource {
  @override
  Future<List<AlgorithmModel>> getAlgorithms() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      AlgorithmModel(
        title: {'id': 'Bubble Sort', 'en': 'Bubble Sort'},
        description: {'id': 'Sorting sederhana', 'en': 'Simple sorting'},
        icon: "bubble",
        colorHex: "FF2196F3",
      ),
      AlgorithmModel(
        title: {'id': 'Selection Sort', 'en': 'Selection Sort'},
        description: {'id': 'Sorting seleksi', 'en': 'Selection sorting'},
        icon: "selection",
        colorHex: "FF4CAF50",
      ),
      AlgorithmModel(
        title: {'id': 'Insertion Sort', 'en': 'Insertion Sort'},
        description: {'id': 'Sorting sisipan', 'en': 'Insertion sorting'},
        icon: "insertion",
        colorHex: "FFFF9800",
      ),
      AlgorithmModel(
        title: {'id': 'Quick Sort', 'en': 'Quick Sort'},
        description: {'id': 'Sorting cepat', 'en': 'Quick sorting'},
        icon: "quick",
        colorHex: "FFF44336",
      ),
      AlgorithmModel(
        title: {'id': 'RSA', 'en': 'RSA'},
        description: {
          'id': 'Enkripsi kunci publik',
          'en': 'Public key encryption',
        },
        icon: "rsa",
        colorHex: "FF9C27B0",
      ),
      AlgorithmModel(
        title: {'id': 'A* Pathfinding', 'en': 'A* Pathfinding'},
        description: {'id': 'Pencarian rute', 'en': 'Route finding'},
        icon: "astar",
        colorHex: "FF607D8B",
      ),
    ];
  }
}
