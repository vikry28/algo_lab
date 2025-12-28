import '../entities/graph_node.dart';
import 'dijkstra_usecase.dart';

class ECMPUseCase {
  List<DijkstraStep> execute(
    List<GraphNode> initialNodes,
    List<GraphEdge> initialEdges,
    String startNodeId,
    String targetNodeId,
  ) {
    List<DijkstraStep> steps = [];

    // Reset state
    List<GraphNode> nodes = initialNodes
        .map(
          (n) => n.copyWith(
            distance: double.infinity,
            status: NodeStatus.unvisited,
            parent: null,
          ),
        )
        .toList();

    List<GraphEdge> edges = initialEdges
        .map((e) => e.copyWith(isHighlighted: false))
        .toList();

    steps.add(
      DijkstraStep(
        nodes: _cloneNodes(nodes),
        edges: _cloneEdges(edges),
        description: "Memulai analisis Equal-Cost Multi-Path (ECMP)...",
      ),
    );

    // 1. Find all paths
    List<List<String>> allPaths = [];
    _findAllPaths(
      startNodeId,
      targetNodeId,
      [startNodeId],
      nodes,
      edges,
      allPaths,
    );

    if (allPaths.isEmpty) {
      steps.add(
        DijkstraStep(
          nodes: nodes,
          edges: edges,
          description: "Tidak ada jalur tersedia.",
        ),
      );
      return steps;
    }

    // 2. Calculate costs
    List<Map<String, dynamic>> pathCosts = [];
    double minCost = double.infinity;

    for (var path in allPaths) {
      double cost = 0;
      bool valid = true;
      for (int i = 0; i < path.length - 1; i++) {
        try {
          final edge = edges.firstWhere(
            (e) =>
                e.isAlive &&
                ((e.fromNodeId == path[i] && e.toNodeId == path[i + 1]) ||
                    (e.fromNodeId == path[i + 1] && e.toNodeId == path[i])),
          );
          cost += edge.weight;
        } catch (_) {
          valid = false;
          break;
        }
      }
      if (valid) {
        pathCosts.add({'path': path, 'cost': cost});
        if (cost < minCost) minCost = cost;
      }
    }

    // 3. Filter paths within tolerance (simulation of ECMP)
    final validPaths = pathCosts.where((p) {
      double c = p['cost'];
      return c <= minCost * 1.05; // 5% tolerance
    }).toList();

    steps.add(
      DijkstraStep(
        nodes: _cloneNodes(nodes),
        edges: _cloneEdges(edges),
        description:
            "Ditemukan ${validPaths.length} jalur dengan cost seimbang (±5%).",
      ),
    );

    // Highlight all ECMP paths
    final currentNodes = _cloneNodes(nodes);
    final currentEdges = _cloneEdges(edges);

    for (var pData in validPaths) {
      final path = pData['path'] as List<String>;
      for (int j = 0; j < path.length - 1; j++) {
        for (int k = 0; k < currentEdges.length; k++) {
          final edge = currentEdges[k];
          if ((edge.fromNodeId == path[j] && edge.toNodeId == path[j + 1]) ||
              (edge.fromNodeId == path[j + 1] && edge.toNodeId == path[j])) {
            currentEdges[k] = edge.copyWith(isHighlighted: true);
          }
        }
      }
      for (var nodeId in path) {
        final idx = currentNodes.indexWhere((n) => n.id == nodeId);
        if (idx != -1) {
          currentNodes[idx] = currentNodes[idx].copyWith(
            status: NodeStatus.path,
          );
        }
      }
    }

    // Set distance on target
    final targetIdx = currentNodes.indexWhere((n) => n.id == targetNodeId);
    if (targetIdx != -1) {
      currentNodes[targetIdx] = currentNodes[targetIdx].copyWith(
        distance: minCost,
      );
    }

    steps.add(
      DijkstraStep(
        nodes: currentNodes,
        edges: currentEdges,
        description:
            "Load balancing traffic aktif di ${validPaths.length} jalur.",
        targetNodeId: targetNodeId,
      ),
    );

    return steps;
  }

  void _findAllPaths(
    String u,
    String d,
    List<String> visited,
    List<GraphNode> nodes,
    List<GraphEdge> edges,
    List<List<String>> allPaths,
  ) {
    if (u == d) {
      allPaths.add(List.from(visited));
      return;
    }

    for (var edge in edges) {
      if (!edge.isAlive) continue;
      String neighbor = "";
      if (edge.fromNodeId == u) {
        neighbor = edge.toNodeId;
      } else if (edge.toNodeId == u) {
        neighbor = edge.fromNodeId;
      } else {
        continue;
      }

      if (!visited.contains(neighbor)) {
        final nodeExists = nodes.any((n) => n.id == neighbor && n.isAlive);
        if (nodeExists) {
          visited.add(neighbor);
          _findAllPaths(neighbor, d, visited, nodes, edges, allPaths);
          visited.removeLast();
        }
      }
    }
  }

  List<GraphNode> _cloneNodes(List<GraphNode> nodes) {
    return nodes.map((n) => n.copyWith()).toList();
  }

  List<GraphEdge> _cloneEdges(List<GraphEdge> edges) {
    return edges.map((e) => e.copyWith()).toList();
  }
}
