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
        titleKey: 'lab_bubble_title',
        descriptionKey: 'lab_bubble_desc_short',
        title: {'id': 'Bubble Sort', 'en': 'Bubble Sort'},
        description: {'id': 'Sorting sederhana', 'en': 'Simple sorting'},
        icon: "bubble",
        colorHex: "FF2196F3",
        category: "sorting",
      ),
      AlgorithmModel(
        titleKey: 'lab_selection_title',
        descriptionKey: 'lab_selection_desc_short',
        title: {'id': 'Selection Sort', 'en': 'Selection Sort'},
        description: {'id': 'Sorting seleksi', 'en': 'Selection sorting'},
        icon: "selection",
        colorHex: "FF4CAF50",
        category: "sorting",
      ),
      AlgorithmModel(
        titleKey: 'lab_insertion_title',
        descriptionKey: 'lab_insertion_desc_short',
        title: {'id': 'Insertion Sort', 'en': 'Insertion Sort'},
        description: {'id': 'Sorting sisipan', 'en': 'Insertion sorting'},
        icon: "insertion",
        colorHex: "FFFF9800",
        category: "sorting",
      ),
      AlgorithmModel(
        titleKey: 'lab_quick_title',
        descriptionKey: 'lab_quick_desc_short',
        title: {'id': 'Quick Sort', 'en': 'Quick Sort'},
        description: {'id': 'Sorting cepat', 'en': 'Quick sorting'},
        icon: "quick",
        colorHex: "FFF44336",
        category: "sorting",
      ),
      AlgorithmModel(
        titleKey: 'rsa_title_pro',
        descriptionKey: 'rsa_desc_pro_short',
        title: {'id': 'RSA', 'en': 'RSA'},
        description: {
          'id': 'Enkripsi kunci publik',
          'en': 'Public key encryption',
        },
        icon: "rsa",
        colorHex: "FF9C27B0",
        category: "cryptography",
      ),
      AlgorithmModel(
        titleKey: 'astar_title_pro',
        descriptionKey: 'astar_desc_pro_short',
        title: {'id': 'A* Pathfinding', 'en': 'A* Pathfinding'},
        description: {'id': 'Pencarian rute', 'en': 'Route finding'},
        icon: "astar",
        colorHex: "FF607D8B",
        category: "pathfinding",
      ),
      AlgorithmModel(
        titleKey: 'lab_graph_dijkstra_title',
        descriptionKey: 'lab_graph_dijkstra_desc',
        title: {'id': 'Dijkstra', 'en': 'Dijkstra'},
        description: {'id': 'Jaringan Kompleks', 'en': 'Complex Network'},
        icon: "graph",
        colorHex: "FF00BCD4",
        category: "graph",
      ),
    ];
  }
}
