import 'dart:async';
import 'dart:math';
import '../entities/grid_node.dart';

enum HeuristicType { manhattan, euclidean, chebyshev }

class AStarUseCase {
  Future<void> findPath({
    required List<List<GridNode>> grid,
    required GridNode startNode,
    required GridNode endNode,
    required Function(List<GridNode> openSet, List<GridNode> closedSet) onStep,
    required Duration delay,
    bool allowDiagonal = false,
    HeuristicType heuristic = HeuristicType.manhattan,
  }) async {
    List<GridNode> openSet = [startNode];
    List<GridNode> closedSet = [];

    // Reset all nodes g and h before starting
    for (var row in grid) {
      for (var node in row) {
        node.g = double.infinity;
        node.h = 0;
        node.parent = null;
        if (node.type == NodeType.visited ||
            node.type == NodeType.searching ||
            node.type == NodeType.path) {
          node.type = node.weight > 1 ? NodeType.weight : NodeType.empty;
        }
      }
    }

    startNode.g = 0;
    startNode.h = _calculateHeuristic(startNode, endNode, heuristic);

    while (openSet.isNotEmpty) {
      // Find node with lowest f cost
      GridNode current = openSet.reduce((a, b) => a.f < b.f ? a : b);

      if (current == endNode) {
        return;
      }

      openSet.remove(current);
      closedSet.add(current);

      if (current != startNode && current != endNode) {
        current.type = NodeType.visited;
      }

      final neighbors = _getNeighbors(grid, current, allowDiagonal);
      for (var neighbor in neighbors) {
        if (neighbor.type == NodeType.wall || closedSet.contains(neighbor)) {
          continue;
        }

        // Distance calculation
        double distance = (neighbor.x != current.x && neighbor.y != current.y)
            ? 1.414 // Diagonal distance (sqrt 2)
            : 1.0; // Cardinal distance

        // Complex cost: distance * weight
        double tentativeG = current.g + (distance * neighbor.weight);

        if (tentativeG < neighbor.g) {
          neighbor.parent = current;
          neighbor.g = tentativeG;
          neighbor.h = _calculateHeuristic(neighbor, endNode, heuristic);

          if (!openSet.contains(neighbor)) {
            openSet.add(neighbor);
            if (neighbor != endNode) {
              neighbor.type = NodeType.searching;
            }
          }
        }
      }

      onStep(openSet, closedSet);
      if (delay.inMilliseconds > 0) {
        await Future.delayed(delay);
      }
    }
  }

  double _calculateHeuristic(
    GridNode node,
    GridNode endNode,
    HeuristicType type,
  ) {
    double dx = (node.x - endNode.x).abs().toDouble();
    double dy = (node.y - endNode.y).abs().toDouble();

    switch (type) {
      case HeuristicType.manhattan:
        return dx + dy;
      case HeuristicType.euclidean:
        return sqrt(dx * dx + dy * dy);
      case HeuristicType.chebyshev:
        return max(dx, dy);
    }
  }

  List<GridNode> _getNeighbors(
    List<List<GridNode>> grid,
    GridNode node,
    bool allowDiagonal,
  ) {
    List<GridNode> neighbors = [];

    final List<List<int>> directions = [
      [0, 1], [0, -1], [1, 0], [-1, 0], // Cardinal
    ];

    if (allowDiagonal) {
      directions.addAll([
        [1, 1], [1, -1], [-1, 1], [-1, -1], // Diagonal
      ]);
    }

    for (var dir in directions) {
      int newX = node.x + dir[0];
      int newY = node.y + dir[1];

      if (newX >= 0 &&
          newX < grid.length &&
          newY >= 0 &&
          newY < grid[0].length) {
        neighbors.add(grid[newX][newY]);
      }
    }

    return neighbors;
  }
}
