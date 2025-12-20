import 'package:flutter/material.dart';

enum NodeType { empty, wall, start, end, path, visited, searching, weight }

class GridNode {
  final int x;
  final int y;
  NodeType type;

  // A* specific values
  double g = double.infinity; // Cost from start
  double h = 0; // Heuristic
  GridNode? parent;

  // Weight for the node (1.0 is default, higher is more 'difficult' terrain like traffic)
  double weight = 1.0;

  double get f => g + h; // Total cost

  GridNode({
    required this.x,
    required this.y,
    this.type = NodeType.empty,
    this.weight = 1.0,
  });

  void reset() {
    g = double.infinity;
    h = 0;
    parent = null;
    // Don't reset wall/weight/start/end types, only algorithm-produced types
    if (type == NodeType.path ||
        type == NodeType.visited ||
        type == NodeType.searching) {
      type = (weight > 1.0) ? NodeType.weight : NodeType.empty;
    }
  }

  Offset get position => Offset(x.toDouble(), y.toDouble());

  GridNode copyWith({int? x, int? y, NodeType? type, double? weight}) {
    return GridNode(
      x: x ?? this.x,
      y: y ?? this.y,
      type: type ?? this.type,
      weight: weight ?? this.weight,
    );
  }
}
