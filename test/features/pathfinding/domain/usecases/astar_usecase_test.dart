import 'package:flutter_test/flutter_test.dart';
import 'package:algo_lab/features/pathfinding/domain/usecases/astar_usecase.dart';
import 'package:algo_lab/features/pathfinding/domain/entities/grid_node.dart';

void main() {
  late AStarUseCase astar;

  setUp(() {
    astar = AStarUseCase();
  });

  group('AStarUseCase Tests', () {
    test('Should find a straight path on empty grid', () async {
      final grid = List.generate(
        5,
        (x) => List.generate(5, (y) => GridNode(x: x, y: y)),
      );
      final start = grid[0][0];
      final end = grid[4][4];

      await astar.findPath(
        grid: grid,
        startNode: start,
        endNode: end,
        onStep: (_, _) {},
        delay: Duration.zero,
      );

      expect(end.parent, isNotNull);

      // Calculate path length
      int length = 0;
      GridNode? current = end;
      while (current != null && current != start) {
        current = current.parent;
        length++;
      }
      expect(length, greaterThan(0));
    });

    test('Should respect walls and find alternative path', () async {
      final grid = List.generate(
        3,
        (x) => List.generate(3, (y) => GridNode(x: x, y: y)),
      );
      // [S] [W] [ ]
      // [ ] [W] [ ]
      // [ ] [ ] [E]

      final start = grid[0][0];
      final end = grid[2][2];
      grid[0][1].type = NodeType.wall;
      grid[1][1].type = NodeType.wall;

      await astar.findPath(
        grid: grid,
        startNode: start,
        endNode: end,
        onStep: (_, _) {},
        delay: Duration.zero,
      );

      expect(end.parent, isNotNull);
    });

    test('Should return if no path found', () async {
      final grid = List.generate(
        3,
        (x) => List.generate(3, (y) => GridNode(x: x, y: y)),
      );
      // Fully block the end node
      grid[2][1].type = NodeType.wall;
      grid[1][2].type = NodeType.wall;

      final start = grid[0][0];
      final end = grid[2][2];

      await astar.findPath(
        grid: grid,
        startNode: start,
        endNode: end,
        onStep: (_, _) {},
        delay: Duration.zero,
      );

      expect(end.parent, isNull);
    });
  });
}
