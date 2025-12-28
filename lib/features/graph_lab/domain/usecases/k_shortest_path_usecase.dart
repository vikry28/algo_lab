import '../entities/graph_node.dart';
import 'dijkstra_usecase.dart';

class KShortestPathUseCase {
  List<DijkstraStep> execute(
    List<GraphNode> initialNodes,
    List<GraphEdge> initialEdges,
    String startNodeId,
    String targetNodeId, {
    int k = 3,
  }) {
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
        description: "Menganalisis top $k jalur rute alternatif...",
      ),
    );

    // Find all simple paths
    List<List<String>> allPaths = [];
    _findAllPaths(
      startNodeId,
      targetNodeId,
      [startNodeId],
      nodes,
      edges,
      allPaths,
    );

    // Calculate costs
    List<Map<String, dynamic>> pathCosts = [];
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
      }
    }

    // Sort by cost
    pathCosts.sort((a, b) => (a['cost'] as double).compareTo(b['cost']));

    // Take Top K
    int count = pathCosts.length < k ? pathCosts.length : k;

    if (count == 0) {
      steps.add(
        DijkstraStep(
          nodes: _cloneNodes(nodes),
          edges: _cloneEdges(edges),
          description: "Tidak ditemukan jalur valid.",
        ),
      );
      return steps;
    }

    for (int i = 0; i < count; i++) {
      final pathData = pathCosts[i];
      final path = pathData['path'] as List<String>;
      final cost = pathData['cost'];

      // Visualization for this path
      final currentNodes = _cloneNodes(nodes);
      final currentEdges = _cloneEdges(edges);

      // Highlight edges
      for (int j = 0; j < path.length - 1; j++) {
        for (int eIdx = 0; eIdx < currentEdges.length; eIdx++) {
          final edge = currentEdges[eIdx];
          if ((edge.fromNodeId == path[j] && edge.toNodeId == path[j + 1]) ||
              (edge.fromNodeId == path[j + 1] && edge.toNodeId == path[j])) {
            currentEdges[eIdx] = edge.copyWith(isHighlighted: true);
          }
        }
      }

      // Highlight nodes
      for (var nodeId in path) {
        final idx = currentNodes.indexWhere((n) => n.id == nodeId);
        if (idx != -1) {
          currentNodes[idx] = currentNodes[idx].copyWith(
            status: NodeStatus.path,
          );
        }
      }

      steps.add(
        DijkstraStep(
          nodes: currentNodes,
          edges: currentEdges,
          description:
              "Path #${i + 1}: ${cost.toInt()}ms latency via ${path.length} hops.",
          activeNodeId: targetNodeId,
        ),
      );
    }

    // Select the best one for final state to ensure connectivity display
    final bestPathData = pathCosts[0];
    final finalNodes = _cloneNodes(nodes);
    final finalEdges = _cloneEdges(edges);

    // Set distance for target node so the result dialog shows correct latency
    final targetIdx = finalNodes.indexWhere((n) => n.id == targetNodeId);
    if (targetIdx != -1) {
      finalNodes[targetIdx] = finalNodes[targetIdx].copyWith(
        distance: bestPathData['cost'],
      );
    }

    steps.add(
      DijkstraStep(
        nodes: finalNodes,
        edges: finalEdges,
        description: "Analisis K-Path selesai. Jalur terbaik dipilih.",
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

    // Find neighbors
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
        // Simple check if node is alive
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
