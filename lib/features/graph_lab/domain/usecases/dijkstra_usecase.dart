import '../entities/graph_node.dart';

class DijkstraStep {
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final String description;
  final String? descKey;
  final Map<String, String>? descArgs;
  final String? activeNodeId;
  final String? sourceNodeId;
  final String? targetNodeId;

  DijkstraStep({
    required this.nodes,
    required this.edges,
    required this.description,
    this.descKey,
    this.descArgs,
    this.activeNodeId,
    this.sourceNodeId,
    this.targetNodeId,
  });
}

class DijkstraUseCase {
  List<DijkstraStep> execute(
    List<GraphNode> initialNodes,
    List<GraphEdge> initialEdges,
    String startNodeId,
    String targetNodeId,
  ) {
    List<DijkstraStep> steps = [];

    // Reset state and initialize distances
    List<GraphNode> nodes = initialNodes
        .map(
          (n) => n.copyWith(
            distance: n.id == startNodeId ? 0 : double.infinity,
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
        description: "Network initialized.",
        descKey: 'graph_sys_ready',
      ),
    );

    Set<String> visited = {};
    // Track unvisited by ID to avoid stale objects
    List<String> unvisitedIds = nodes
        .where((n) => n.isAlive)
        .map((n) => n.id)
        .toList();

    while (unvisitedIds.isNotEmpty) {
      // Sort IDs based on their current distance in the nodes list
      unvisitedIds.sort((a, b) {
        double distA = nodes.firstWhere((n) => n.id == a).distance;
        double distB = nodes.firstWhere((n) => n.id == b).distance;
        return distA.compareTo(distB);
      });

      String currentId = unvisitedIds.removeAt(0);
      int currentIndex = nodes.indexWhere((n) => n.id == currentId);
      GraphNode current = nodes[currentIndex];

      if (current.distance == double.infinity) break;

      nodes[currentIndex] = current.copyWith(status: NodeStatus.current);

      steps.add(
        DijkstraStep(
          nodes: _cloneNodes(nodes),
          edges: _cloneEdges(edges),
          description: "Checking node: ${current.label}",
          descKey: 'graph_sys_checking',
          descArgs: {'label': current.label},
          activeNodeId: current.id,
        ),
      );

      if (current.id == targetNodeId) {
        nodes[currentIndex] = nodes[currentIndex].copyWith(
          status: NodeStatus.visited,
        );
        _highlightPath(nodes, edges, targetNodeId, steps);
        return steps;
      }

      for (int i = 0; i < edges.length; i++) {
        var edge = edges[i];
        if (!edge.isAlive) continue;

        if (edge.fromNodeId == current.id || edge.toNodeId == current.id) {
          String neighborId = edge.fromNodeId == current.id
              ? edge.toNodeId
              : edge.fromNodeId;

          if (visited.contains(neighborId)) continue;

          int neighborIndex = nodes.indexWhere((n) => n.id == neighborId);
          if (neighborIndex == -1) continue;

          GraphNode neighbor = nodes[neighborIndex];
          if (!neighbor.isAlive) continue;

          double newDist = current.distance + edge.weight;

          if (newDist < neighbor.distance) {
            nodes[neighborIndex] = neighbor.copyWith(
              distance: newDist,
              parent: current,
            );

            steps.add(
              DijkstraStep(
                nodes: _cloneNodes(nodes),
                edges: _cloneEdges(edges),
                description: "Found faster route to ${neighbor.label}.",
                descKey: 'graph_sys_faster',
                descArgs: {'label': neighbor.label},
                activeNodeId: neighbor.id,
                sourceNodeId: current.id,
                targetNodeId: neighbor.id,
              ),
            );
          }
        }
      }

      nodes[currentIndex] = nodes[currentIndex].copyWith(
        status: NodeStatus.visited,
      );
      visited.add(current.id);

      steps.add(
        DijkstraStep(
          nodes: _cloneNodes(nodes),
          edges: _cloneEdges(edges),
          description: "Node ${current.label} setup complete.",
          descKey: 'graph_sys_configured',
          descArgs: {'label': current.label},
          activeNodeId: current.id,
        ),
      );
    }

    steps.add(
      DijkstraStep(
        nodes: _cloneNodes(nodes),
        edges: _cloneEdges(edges),
        description: "No available route found.",
        descKey: 'graph_sys_no_path',
      ),
    );

    return steps;
  }

  void _highlightPath(
    List<GraphNode> nodes,
    List<GraphEdge> edges,
    String targetId,
    List<DijkstraStep> steps,
  ) {
    String? currentId = targetId;
    while (currentId != null) {
      int idx = nodes.indexWhere((n) => n.id == currentId);
      GraphNode node = nodes[idx];
      nodes[idx] = node.copyWith(status: NodeStatus.path);

      if (node.parent == null) break;

      String parentId = node.parent!.id;
      for (int i = 0; i < edges.length; i++) {
        if ((edges[i].fromNodeId == currentId &&
                edges[i].toNodeId == parentId) ||
            (edges[i].fromNodeId == parentId &&
                edges[i].toNodeId == currentId)) {
          edges[i] = edges[i].copyWith(isHighlighted: true);
        }
      }
      currentId = parentId;
    }

    steps.add(
      DijkstraStep(
        nodes: _cloneNodes(nodes),
        edges: _cloneEdges(edges),
        description: "Optimal route found!",
        descKey: 'graph_sys_optimal',
      ),
    );
  }

  List<GraphNode> _cloneNodes(List<GraphNode> nodes) {
    return nodes.map((n) => n.copyWith()).toList();
  }

  List<GraphEdge> _cloneEdges(List<GraphEdge> edges) {
    return edges.map((e) => e.copyWith()).toList();
  }
}
