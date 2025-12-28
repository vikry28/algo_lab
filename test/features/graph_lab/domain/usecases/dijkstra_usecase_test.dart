import 'package:flutter_test/flutter_test.dart';
import 'package:algo_lab/features/graph_lab/domain/entities/graph_node.dart';
import 'package:algo_lab/features/graph_lab/domain/usecases/dijkstra_usecase.dart';

void main() {
  late DijkstraUseCase useCase;

  setUp(() {
    useCase = DijkstraUseCase();
  });

  group('DijkstraUseCase Tests', () {
    final nodes = [
      GraphNode(id: 'A', label: 'Node A', position: Offset.zero),
      GraphNode(id: 'B', label: 'Node B', position: Offset.zero),
      GraphNode(id: 'C', label: 'Node C', position: Offset.zero),
      GraphNode(id: 'D', label: 'Node D', position: Offset.zero),
    ];

    final edges = [
      GraphEdge(id: 'e1', fromNodeId: 'A', toNodeId: 'B', weight: 10),
      GraphEdge(id: 'e2', fromNodeId: 'B', toNodeId: 'C', weight: 20),
      GraphEdge(id: 'e3', fromNodeId: 'A', toNodeId: 'C', weight: 50),
      GraphEdge(id: 'e4', fromNodeId: 'C', toNodeId: 'D', weight: 10),
    ];

    test('should find the shortest path from A to C', () {
      final steps = useCase.execute(nodes, edges, 'A', 'C');

      expect(steps.isNotEmpty, true);
      final lastStep = steps.last;

      // Shortest path A -> B -> C (10 + 20 = 30) vs A -> C (50)
      final nodeC = lastStep.nodes.firstWhere((n) => n.id == 'C');
      expect(nodeC.distance, 30);
      expect(nodeC.status, NodeStatus.path);

      final highlightedEdges = lastStep.edges
          .where((e) => e.isHighlighted)
          .toList();
      expect(highlightedEdges.length, 2); // A-B and B-C
      expect(highlightedEdges.any((e) => e.id == 'e1'), true);
      expect(highlightedEdges.any((e) => e.id == 'e2'), true);
    });

    test('should handle dead links correctly', () {
      // Break the shortest path (e1: A-B)
      final brokenEdges = edges
          .map((e) => e.id == 'e1' ? e.copyWith(isAlive: false) : e)
          .toList();

      final steps = useCase.execute(nodes, brokenEdges, 'A', 'C');
      final lastStep = steps.last;

      // Should now take A -> C (50)
      final nodeC = lastStep.nodes.firstWhere((n) => n.id == 'C');
      expect(nodeC.distance, 50);

      final highlightedEdges = lastStep.edges
          .where((e) => e.isHighlighted)
          .toList();
      expect(highlightedEdges.length, 1);
      expect(highlightedEdges.any((e) => e.id == 'e3'), true);
    });

    test('should return no path found if target is unreachable', () {
      final isolatedNodes = [
        GraphNode(id: 'A', label: 'Node A', position: Offset.zero),
        GraphNode(id: 'X', label: 'Node X', position: Offset.zero),
      ];
      final noEdges = <GraphEdge>[];

      final steps = useCase.execute(isolatedNodes, noEdges, 'A', 'X');

      expect(steps.last.description, "Tidak ditemukan rute yang tersedia.");
      final nodeX = steps.last.nodes.firstWhere((n) => n.id == 'X');
      expect(nodeX.distance, double.infinity);
    });
  });
}
