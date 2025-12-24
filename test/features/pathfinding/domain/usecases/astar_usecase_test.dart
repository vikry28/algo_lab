import 'package:algo_lab/features/pathfinding/domain/entities/grid_node.dart';
import 'package:algo_lab/features/pathfinding/domain/usecases/astar_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AStarUseCase useCase;

  setUp(() {
    useCase = AStarUseCase();
  });

  List<List<GridNode>> createGrid(int rows, int cols) {
    return List.generate(
      rows,
      (x) => List.generate(cols, (y) => GridNode(x: x, y: y)),
    );
  }

  group('AStarUseCase Tests', () {
    test('findPath finds simple path', () async {
      final grid = createGrid(5, 5);
      final start = grid[0][0];
      final end = grid[0][4];

      start.type = NodeType.start;
      end.type = NodeType.end;

      await useCase.findPath(
        grid: grid,
        startNode: start,
        endNode: end,
        onStep: (open, closed) {},
        delay: Duration.zero,
      );

      // Verify path exists by backtracking from end
      expect(end.parent, isNotNull);

      // Check sequence for straight line
      GridNode? current = end.parent;
      while (current != null && current != start) {
        expect(current.x, 0); // Should stay on first row
        current = current.parent;
      }
      expect(current, start);
    });

    test('findPath avoids walls', () async {
      final grid = createGrid(3, 3);
      final start = grid[0][0];
      final end = grid[0][2];

      // Wall blocking direct path
      grid[0][1].type = NodeType.wall;

      start.type = NodeType.start;
      end.type = NodeType.end;

      await useCase.findPath(
        grid: grid,
        startNode: start,
        endNode: end,
        onStep: (open, closed) {},
        delay: Duration.zero,
        allowDiagonal: false,
      );

      expect(end.parent, isNotNull);
      // Path must go around [0][1]
      // Likely path: (0,0) -> (1,0) -> (1,1) -> (1,2) -> (0,2)
      // or similar, but definitely not (0,1)

      bool hitWall = false;
      GridNode? current = end;
      while (current != null) {
        if (current.x == 0 && current.y == 1) hitWall = true;
        current = current.parent;
      }
      expect(hitWall, false);
    });
  });
}
