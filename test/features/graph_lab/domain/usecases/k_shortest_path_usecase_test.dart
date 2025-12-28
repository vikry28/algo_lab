import 'package:flutter_test/flutter_test.dart';
import 'package:algo_lab/features/graph_lab/domain/entities/graph_node.dart';
import 'package:algo_lab/features/graph_lab/domain/usecases/k_shortest_path_usecase.dart';

void main() {
  late KShortestPathUseCase useCase;

  setUp(() {
    useCase = KShortestPathUseCase();
  });

  group('KShortestPathUseCase Tests', () {
    final nodes = [
      GraphNode(id: 'A', label: 'Node A', position: Offset.zero),
      GraphNode(id: 'B', label: 'Node B', position: Offset.zero),
      GraphNode(id: 'C', label: 'Node C', position: Offset.zero),
    ];

    final edges = [
      GraphEdge(id: 'e1', fromNodeId: 'A', toNodeId: 'B', weight: 10),
      GraphEdge(id: 'e2', fromNodeId: 'B', toNodeId: 'C', weight: 10),
      GraphEdge(id: 'e3', fromNodeId: 'A', toNodeId: 'C', weight: 50),
    ];

    test('should find 2 shortest paths from A to C', () {
      final steps = useCase.execute(nodes, edges, 'A', 'C', k: 2);

      // We expect steps:
      // 1. Initial analysis msg
      // 2. Path 1 visualization (A-B-C, cost 20)
      // 3. Path 2 visualization (A-C, cost 50)
      // 4. Analysis complete msg

      expect(steps.length, 4);
      expect(steps[1].description.contains('Path #1'), true);
      expect(steps[1].description.contains('20ms'), true);

      expect(steps[2].description.contains('Path #2'), true);
      expect(steps[2].description.contains('50ms'), true);
    });

    test('should handle k greater than available paths', () {
      final steps = useCase.execute(nodes, edges, 'A', 'C', k: 5);

      // Still only 2 paths exist
      expect(steps.length, 4);
    });

    test('should return "no paths" if target is disconnected', () {
      final lonelyNodes = [
        GraphNode(id: 'A', label: 'Node A', position: Offset.zero),
        GraphNode(id: 'Z', label: 'Node Z', position: Offset.zero),
      ];
      final steps = useCase.execute(lonelyNodes, [], 'A', 'Z');

      expect(steps.last.description, "Tidak ditemukan jalur valid.");
    });
  });
}
