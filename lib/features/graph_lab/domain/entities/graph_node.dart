import 'package:flutter/material.dart';

enum NodeStatus { unvisited, visited, current, path }

enum NodeType { router, server, cloud, terminal, hub }

class GraphNode {
  final String id;
  final String label;
  final Offset position;
  final NodeStatus status;
  final double distance;
  final GraphNode? parent;
  final NodeType type;
  final bool isAlive; // New field for network status

  GraphNode({
    required this.id,
    required this.label,
    required this.position,
    this.status = NodeStatus.unvisited,
    this.distance = double.infinity,
    this.parent,
    this.type = NodeType.router,
    this.isAlive = true,
  });

  GraphNode copyWith({
    String? id,
    String? label,
    Offset? position,
    NodeStatus? status,
    double? distance,
    GraphNode? parent,
    NodeType? type,
    bool? isAlive,
  }) {
    return GraphNode(
      id: id ?? this.id,
      label: label ?? this.label,
      position: position ?? this.position,
      status: status ?? this.status,
      distance: distance ?? this.distance,
      parent: parent ?? this.parent,
      type: type ?? this.type,
      isAlive: isAlive ?? this.isAlive,
    );
  }
}

class GraphEdge {
  final String id;
  final String fromNodeId;
  final String toNodeId;
  final double weight;
  final bool isHighlighted;
  final bool isAlive; // New field for edge status
  final double trafficLoad; // New field for real traffic (0.0 to 1.0)

  GraphEdge({
    required this.id,
    required this.fromNodeId,
    required this.toNodeId,
    required this.weight,
    this.isHighlighted = false,
    this.isAlive = true,
    this.trafficLoad = 0.0,
  });

  GraphEdge copyWith({
    String? id,
    String? fromNodeId,
    String? toNodeId,
    double? weight,
    bool? isHighlighted,
    bool? isAlive,
    double? trafficLoad,
  }) {
    return GraphEdge(
      id: id ?? this.id,
      fromNodeId: fromNodeId ?? this.fromNodeId,
      toNodeId: toNodeId ?? this.toNodeId,
      weight: weight ?? this.weight,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      isAlive: isAlive ?? this.isAlive,
      trafficLoad: trafficLoad ?? this.trafficLoad,
    );
  }
}

class Packet {
  final Offset position;
  final Color color;
  final double opacity;

  Packet({
    required this.position,
    this.color = Colors.cyanAccent,
    this.opacity = 1.0,
  });
}
