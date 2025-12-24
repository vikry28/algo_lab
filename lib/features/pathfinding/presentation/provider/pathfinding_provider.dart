import 'package:flutter/material.dart';
import '../../domain/entities/grid_node.dart';
import '../../domain/usecases/astar_usecase.dart';

enum BrushMode { start, end, wall, weight, erase }

class PathfindingProvider extends ChangeNotifier {
  final AStarUseCase astarUseCase;

  int rows = 20;
  int cols = 15;
  late List<List<GridNode>> grid;

  GridNode? startNode;
  GridNode? endNode;

  bool isRunning = false;
  Duration stepDelay = const Duration(milliseconds: 20);

  // Settings
  BrushMode brushMode = BrushMode.wall;
  bool allowDiagonal = false;
  HeuristicType heuristic = HeuristicType.manhattan;

  // Metrics
  int nodesVisited = 0;
  double totalPathCost = 0.0;
  Stopwatch stopwatch = Stopwatch();

  PathfindingProvider({AStarUseCase? useCase})
    : astarUseCase = useCase ?? AStarUseCase() {
    _initGrid();
  }

  void _initGrid() {
    grid = List.generate(
      rows,
      (x) => List.generate(cols, (y) => GridNode(x: x, y: y)),
    );

    // Default start and end
    startNode = grid[2][2]..type = NodeType.start;
    endNode = grid[rows - 3][cols - 3]..type = NodeType.end;
    notifyListeners();
  }

  void reset() {
    isRunning = false;
    nodesVisited = 0;
    totalPathCost = 0;
    stopwatch.reset();
    for (var row in grid) {
      for (var node in row) {
        node.reset();
      }
    }
    notifyListeners();
  }

  void clearObstacles() {
    for (var row in grid) {
      for (var node in row) {
        if (node.type == NodeType.wall || node.type == NodeType.weight) {
          node.type = NodeType.empty;
          node.weight = 1.0;
        }
      }
    }
    notifyListeners();
  }

  void setBrushMode(BrushMode mode) {
    brushMode = mode;
    notifyListeners();
  }

  void setHeuristic(HeuristicType h) {
    heuristic = h;
    notifyListeners();
  }

  void toggleDiagonal() {
    allowDiagonal = !allowDiagonal;
    notifyListeners();
  }

  void handleTap(int x, int y) {
    if (isRunning) return;
    final node = grid[x][y];

    switch (brushMode) {
      case BrushMode.start:
        if (node.type != NodeType.end) {
          startNode?.type = (startNode?.weight ?? 1.0) > 1.0
              ? NodeType.weight
              : NodeType.empty;
          startNode = node;
          node.type = NodeType.start;
        }
        break;
      case BrushMode.end:
        if (node.type != NodeType.start) {
          endNode?.type = (endNode?.weight ?? 1.0) > 1.0
              ? NodeType.weight
              : NodeType.empty;
          endNode = node;
          node.type = NodeType.end;
        }
        break;
      case BrushMode.wall:
        if (node.type != NodeType.start && node.type != NodeType.end) {
          node.type = NodeType.wall;
          node.weight = 1.0;
        }
        break;
      case BrushMode.weight:
        if (node.type != NodeType.start && node.type != NodeType.end) {
          node.type = NodeType.weight;
          node.weight = 5.0; // High cost
        }
        break;
      case BrushMode.erase:
        if (node.type != NodeType.start && node.type != NodeType.end) {
          node.type = NodeType.empty;
          node.weight = 1.0;
        }
        break;
    }
    notifyListeners();
  }

  Future<void> startAStar() async {
    if (isRunning || startNode == null || endNode == null) return;

    reset();
    isRunning = true;
    stopwatch.start();
    notifyListeners();

    await astarUseCase.findPath(
      grid: grid,
      startNode: startNode!,
      endNode: endNode!,
      allowDiagonal: allowDiagonal,
      heuristic: heuristic,
      onStep: (open, closed) {
        nodesVisited = closed.length;
        notifyListeners();
      },
      delay: stepDelay,
    );

    stopwatch.stop();

    // Draw path if found
    if (endNode?.parent != null) {
      totalPathCost = endNode!.g;
      GridNode? current = endNode?.parent;
      while (current != null && current != startNode) {
        current.type = NodeType.path;
        current = current.parent;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 15));
      }
    }

    isRunning = false;
    notifyListeners();
  }
}
