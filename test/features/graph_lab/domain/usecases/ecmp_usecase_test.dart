import 'package:flutter_test/flutter_test.dart';
import 'package:algo_lab/features/graph_lab/domain/entities/graph_node.dart';
import 'package:algo_lab/features/graph_lab/domain/usecases/ecmp_usecase.dart';

void main() {
  late ECMPUseCase useCase;

  setUp(() {
    useCase = ECMPUseCase();
  });

  group('ECMPUseCase Tests', () {
    final nodes = [
      GraphNode(id: 'A', label: 'Node A', position: Offset.zero),
      GraphNode(id: 'B', label: 'Node B', position: Offset.zero),
      GraphNode(id: 'C', label: 'Node C', position: Offset.zero),
      GraphNode(id: 'D', label: 'Node D', position: Offset.zero),
    ];

    test('should identify equal cost paths', () {
      final edges = [
        GraphEdge(id: 'e1', fromNodeId: 'A', toNodeId: 'B', weight: 10),
        GraphEdge(id: 'e2', fromNodeId: 'B', toNodeId: 'D', weight: 10),
        GraphEdge(id: 'e3', fromNodeId: 'A', toNodeId: 'C', weight: 10),
        GraphEdge(id: 'e4', fromNodeId: 'C', toNodeId: 'D', weight: 10),
      ];
      // Path 1: A-B-D (20)
      // Path 2: A-C-D (20)

      final steps = useCase.execute(nodes, edges, 'A', 'D');

      expect(
        steps.any(
          (s) =>
              s.descKey == 'graph_sys_ecmp_found' &&
              s.description.contains('Found 2 paths'),
        ),
        true,
      );

      final lastStep = steps.last;
      final highlightedEdges = lastStep.edges
          .where((e) => e.isHighlighted)
          .toList();
      expect(highlightedEdges.length, 4); // All 4 edges should be highlighted
    });

    test('should include paths within 5% tolerance', () {
      final edges = [
        GraphEdge(id: 'e1', fromNodeId: 'A', toNodeId: 'B', weight: 100),
        GraphEdge(id: 'e2', fromNodeId: 'B', toNodeId: 'D', weight: 100),
        GraphEdge(id: 'e3', fromNodeId: 'A', toNodeId: 'C', weight: 102),
        GraphEdge(id: 'e4', fromNodeId: 'C', toNodeId: 'D', weight: 100),
      ];
      // Path 1: 200
      // Path 2: 202 (1% tolerance, within 5%)

      final steps = useCase.execute(nodes, edges, 'A', 'D');
      expect(
        steps.any(
          (s) =>
              s.descKey == 'graph_sys_ecmp_found' &&
              s.description.contains('Found 2 paths'),
        ),
        true,
      );
    });

    test('should NOT include paths outside 5% tolerance', () {
      final edges = [
        GraphEdge(id: 'e1', fromNodeId: 'A', toNodeId: 'B', weight: 100),
        GraphEdge(id: 'e2', fromNodeId: 'B', toNodeId: 'D', weight: 100),
        GraphEdge(id: 'e3', fromNodeId: 'A', toNodeId: 'C', weight: 115),
        GraphEdge(id: 'e4', fromNodeId: 'C', toNodeId: 'D', weight: 100),
      ];
      // Path 1: 200
      // Path 2: 215 (7.5% tolerance, outside 5%)

      final steps = useCase.execute(nodes, edges, 'A', 'D');
      expect(
        steps.any(
          (s) =>
              s.descKey == 'graph_sys_ecmp_found' &&
              s.description.contains('Found 1 paths'),
        ),
        true,
      );
    });
  });
}
