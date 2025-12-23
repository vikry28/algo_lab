import 'package:algo_lab/features/pathfinding/domain/entities/grid_node.dart';
import 'package:algo_lab/features/pathfinding/domain/usecases/astar_usecase.dart';
import 'package:algo_lab/features/pathfinding/presentation/provider/pathfinding_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pathfinding_provider_test.mocks.dart';

@GenerateMocks([AStarUseCase])
void main() {
  late PathfindingProvider provider;
  late MockAStarUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockAStarUseCase();
    // Default stub for findPath
    when(
      mockUseCase.findPath(
        grid: anyNamed('grid'),
        startNode: anyNamed('startNode'),
        endNode: anyNamed('endNode'),
        onStep: anyNamed('onStep'),
        delay: anyNamed('delay'),
        allowDiagonal: anyNamed('allowDiagonal'),
        heuristic: anyNamed('heuristic'),
      ),
    ).thenAnswer((_) async {});

    provider = PathfindingProvider(useCase: mockUseCase);
  });

  group('PathfindingProvider Tests', () {
    test('Initialization works', () {
      expect(provider.grid, isNotEmpty);
      expect(provider.startNode, isNotNull);
      expect(provider.endNode, isNotNull);
      expect(provider.isRunning, false);
    });

    test('Brush mode updates', () {
      provider.setBrushMode(BrushMode.erase);
      expect(provider.brushMode, BrushMode.erase);
    });

    test('Heuristic updates', () {
      provider.setHeuristic(HeuristicType.euclidean);
      expect(provider.heuristic, HeuristicType.euclidean);
    });

    test('startAStar calls useCase', () async {
      await provider.startAStar();

      expect(provider.isRunning, false); // Returns to false after await
      verify(
        mockUseCase.findPath(
          grid: anyNamed('grid'),
          startNode: anyNamed('startNode'),
          endNode: anyNamed('endNode'),
          onStep: anyNamed('onStep'),
          delay: anyNamed('delay'),
          allowDiagonal: anyNamed('allowDiagonal'),
          heuristic: anyNamed('heuristic'),
        ),
      ).called(1);
    });

    test('handleTap toggles walls', () {
      final node = provider.grid[0][0];
      // Ensure it's not start or end
      node.type = NodeType.empty;
      provider.startNode = provider.grid[1][1];
      provider.endNode = provider.grid[2][2];

      provider.setBrushMode(BrushMode.wall);
      provider.handleTap(0, 0);

      expect(provider.grid[0][0].type, NodeType.wall);
    });

    test('reset clears grid logic but keeps walls', () {
      provider.nodesVisited = 100;
      provider.totalPathCost = 50;

      provider.reset();

      expect(provider.nodesVisited, 0);
      expect(provider.totalPathCost, 0);
    });
  });
}
