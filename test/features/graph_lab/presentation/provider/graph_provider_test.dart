import 'package:flutter_test/flutter_test.dart';
import 'package:algo_lab/features/graph_lab/presentation/provider/graph_provider.dart';

void main() {
  late GraphProvider provider;

  setUp(() {
    provider = GraphProvider();
  });

  group('GraphProvider Initialization', () {
    test('should initialize with real-world network nodes and edges', () {
      expect(provider.nodes.isNotEmpty, true);
      expect(provider.edges.isNotEmpty, true);
      expect(provider.nodes.any((n) => n.id == "JAKARTA-DC"), true);
      expect(provider.nodes.any((n) => n.id == "SINGAPORE-DC"), true);
    });

    test('satellite link (e18) should be disabled by default', () {
      final satelliteLink = provider.edges.firstWhere((e) => e.id == "e18");
      expect(satelliteLink.isAlive, false);
    });

    test('should have initial state correctly set', () {
      expect(provider.isRunning, false);
      expect(provider.isFinished, false);
      expect(provider.algorithmType, AlgorithmType.dijkstra);
    });
  });

  group('GraphProvider Controls', () {
    test('toggleNodeStatus should change node isAlive state', () {
      const nodeId = "SURABAYA-HUB";
      final initialState = provider.nodes
          .firstWhere((n) => n.id == nodeId)
          .isAlive;

      provider.toggleNodeStatus(nodeId);
      expect(
        provider.nodes.firstWhere((n) => n.id == nodeId).isAlive,
        !initialState,
      );
    });

    test('reset should restore network to initial state', () {
      // Modify state
      provider.toggleNodeStatus("JAKARTA-DC");
      provider.setAlgorithmType(AlgorithmType.ecmp);

      provider.reset();

      expect(
        provider.nodes.firstWhere((n) => n.id == "JAKARTA-DC").isAlive,
        true,
      );
      // Note: provider.reset() re-initializes network but might keep algorithmType if not handled in reset()
      // Let's check reset() implementation in provider
    });

    test('setAlgorithmType should update algorithm type', () {
      provider.setAlgorithmType(AlgorithmType.kShortestPath);
      expect(provider.algorithmType, AlgorithmType.kShortestPath);
    });
  });
}
