import '../../domain/entities/algorithm_content_entity.dart';

/// Konten pembelajaran untuk algoritma graf (Graph Algorithms)
class GraphAlgorithmsContent {
  // BFS (Breadth-First Search)
  static AlgorithmContentEntity getBFS(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'bfs_summary',

      understandingText: 'bfs_understanding',

      algorithmSteps: [
        'bfs_step_1',
        'bfs_step_2',
        'bfs_step_3',
        'bfs_step_4',
        'bfs_step_5',
        'bfs_step_6',
      ],

      codeExample: isId
          ? '''import 'dart:collection';

class Graph {
  Map<int, List<int>> adjList = {};
  
  void addEdge(int u, int v) {
    adjList.putIfAbsent(u, () => []);
    adjList.putIfAbsent(v, () => []);
    adjList[u]!.add(v);
    adjList[v]!.add(u); // Undirected graph
  }
  
  void bfs(int start) {
    Set<int> visited = {};
    Queue<int> queue = Queue();
    
    queue.add(start);
    visited.add(start);
    
    print('BFS Traversal dari node \$start:');
    
    while (queue.isNotEmpty) {
      int node = queue.removeFirst();
      print('Kunjungi: \$node');
      
      // Kunjungi semua tetangga
      for (int neighbor in adjList[node] ?? []) {
        if (!visited.contains(neighbor)) {
          visited.add(neighbor);
          queue.add(neighbor);
          print('  → Enqueue: \$neighbor');
        }
      }
    }
  }
}

void main() {
  Graph g = Graph();
  g.addEdge(0, 1);
  g.addEdge(0, 2);
  g.addEdge(1, 3);
  g.addEdge(1, 4);
  g.addEdge(2, 4);
  
  g.bfs(0);
}'''
          : '''import 'dart:collection';

class Graph {
  Map<int, List<int>> adjList = {};
  
  void addEdge(int u, int v) {
    adjList.putIfAbsent(u, () => []);
    adjList.putIfAbsent(v, () => []);
    adjList[u]!.add(v);
    adjList[v]!.add(u); // Undirected graph
  }
  
  void bfs(int start) {
    Set<int> visited = {};
    Queue<int> queue = Queue();
    
    queue.add(start);
    visited.add(start);
    
    print('BFS Traversal from node \$start:');
    
    while (queue.isNotEmpty) {
      int node = queue.removeFirst();
      print('Visit: \$node');
      
      // Visit all neighbors
      for (int neighbor in adjList[node] ?? []) {
        if (!visited.contains(neighbor)) {
          visited.add(neighbor);
          queue.add(neighbor);
          print('  → Enqueue: \$neighbor');
        }
      }
    }
  }
}

void main() {
  Graph g = Graph();
  g.addEdge(0, 1);
  g.addEdge(0, 2);
  g.addEdge(1, 3);
  g.addEdge(1, 4);
  g.addEdge(2, 4);
  
  g.bfs(0);
}''',

      output: isId
          ? '''BFS Traversal dari node 0:
Kunjungi: 0
  → Enqueue: 1
  → Enqueue: 2
Kunjungi: 1
  → Enqueue: 3
  → Enqueue: 4
Kunjungi: 2
Kunjungi: 3
Kunjungi: 4'''
          : '''BFS Traversal from node 0:
Visit: 0
  → Enqueue: 1
  → Enqueue: 2
Visit: 1
  → Enqueue: 3
  → Enqueue: 4
Visit: 2
Visit: 3
Visit: 4''',

      timeComplexity: 'bfs_time_complexity',
      spaceComplexity: 'bfs_space_complexity',

      advantages: [
        'bfs_advantage_1',
        'bfs_advantage_2',
        'bfs_advantage_3',
        'bfs_advantage_4',
      ],

      disadvantages: [
        'bfs_disadvantage_1',
        'bfs_disadvantage_2',
        'bfs_disadvantage_3',
      ],

      visualSteps: [
        'bfs_visual_step_1',
        'bfs_visual_step_2',
        'bfs_visual_step_3',
        'bfs_visual_step_4',
        'bfs_visual_step_5',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'bfs_quiz_1_question',
          correctAnswer: '''void bfs(Map<int, List<int>> graph, int start) {
  Set<int> visited = {};
  Queue<int> queue = Queue();
  
  queue.add(start);
  visited.add(start);
  
  while (queue.isNotEmpty) {
    int node = queue.removeFirst();
    print(node);
    
    for (int neighbor in graph[node] ?? []) {
      if (!visited.contains(neighbor)) {
        visited.add(neighbor);
        queue.add(neighbor);
      }
    }
  }
}''',
          codeTemplate: isId
              ? '''void bfs(Map<int, List<int>> graph, int start) {
  // Implementasikan BFS
  
}'''
              : '''void bfs(Map<int, List<int>> graph, int start) {
  // Implement BFS
  
}''',
          hint: 'bfs_quiz_1_hint',
        ),
      ],

      useCases: 'bfs_use_cases',
      realWorldExample: 'bfs_real_world',
    );
  }

  // DFS (Depth-First Search)
  static AlgorithmContentEntity getDFS(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'dfs_summary',
      understandingText: 'dfs_understanding',

      algorithmSteps: [
        'dfs_step_1',
        'dfs_step_2',
        'dfs_step_3',
        'dfs_step_4',
        'dfs_step_5',
        'dfs_step_6',
      ],

      codeExample: isId
          ? '''class Graph {
  Map<int, List<int>> adjList = {};
  
  void addEdge(int u, int v) {
    adjList.putIfAbsent(u, () => []);
    adjList.putIfAbsent(v, () => []);
    adjList[u]!.add(v);
    adjList[v]!.add(u);
  }
  
  void dfs(int start) {
    Set<int> visited = {};
    print('DFS Traversal dari node \$start:');
    _dfsRecursive(start, visited);
  }
  
  void _dfsRecursive(int node, Set<int> visited) {
    visited.add(node);
    print('Kunjungi: \$node');
    
    for (int neighbor in adjList[node] ?? []) {
      if (!visited.contains(neighbor)) {
        print('  → Rekursif ke: \$neighbor');
        _dfsRecursive(neighbor, visited);
        print('  ← Backtrack dari: \$neighbor');
      }
    }
  }
}

void main() {
  Graph g = Graph();
  g.addEdge(0, 1);
  g.addEdge(0, 2);
  g.addEdge(1, 3);
  g.addEdge(1, 4);
  g.addEdge(2, 4);
  
  g.dfs(0);
}'''
          : '''class Graph {
  Map<int, List<int>> adjList = {};
  
  void addEdge(int u, int v) {
    adjList.putIfAbsent(u, () => []);
    adjList.putIfAbsent(v, () => []);
    adjList[u]!.add(v);
    adjList[v]!.add(u);
  }
  
  void dfs(int start) {
    Set<int> visited = {};
    print('DFS Traversal from node \$start:');
    _dfsRecursive(start, visited);
  }
  
  void _dfsRecursive(int node, Set<int> visited) {
    visited.add(node);
    print('Visit: \$node');
    
    for (int neighbor in adjList[node] ?? []) {
      if (!visited.contains(neighbor)) {
        print('  → Recurse to: \$neighbor');
        _dfsRecursive(neighbor, visited);
        print('  ← Backtrack from: \$neighbor');
      }
    }
  }
}

void main() {
  Graph g = Graph();
  g.addEdge(0, 1);
  g.addEdge(0, 2);
  g.addEdge(1, 3);
  g.addEdge(1, 4);
  g.addEdge(2, 4);
  
  g.dfs(0);
}''',

      output: isId
          ? '''DFS Traversal dari node 0:
Kunjungi: 0
  → Rekursif ke: 1
Kunjungi: 1
  → Rekursif ke: 3
Kunjungi: 3
  ← Backtrack dari: 3
  → Rekursif ke: 4
Kunjungi: 4
  ← Backtrack dari: 4
  ← Backtrack dari: 1
  → Rekursif ke: 2
Kunjungi: 2
  ← Backtrack dari: 2'''
          : '''DFS Traversal from node 0:
Visit: 0
  → Recurse to: 1
Visit: 1
  → Recurse to: 3
Visit: 3
  ← Backtrack from: 3
  → Recurse to: 4
Visit: 4
  ← Backtrack from: 4
  ← Backtrack from: 1
  → Recurse to: 2
Visit: 2
  ← Backtrack from: 2''',

      timeComplexity: 'dfs_time_complexity',
      spaceComplexity: 'dfs_space_complexity',

      advantages: [
        'dfs_advantage_1',
        'dfs_advantage_2',
        'dfs_advantage_3',
        'dfs_advantage_4',
      ],

      disadvantages: [
        'dfs_disadvantage_1',
        'dfs_disadvantage_2',
        'dfs_disadvantage_3',
      ],

      visualSteps: [
        'dfs_visual_step_1',
        'dfs_visual_step_2',
        'dfs_visual_step_3',
        'dfs_visual_step_4',
        'dfs_visual_step_5',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'dfs_quiz_1_question',
          correctAnswer:
              '''void dfs(Map<int, List<int>> graph, int node, Set<int> visited) {
  visited.add(node);
  print(node);
  
  for (int neighbor in graph[node] ?? []) {
    if (!visited.contains(neighbor)) {
      dfs(graph, neighbor, visited);
    }
  }
}''',
          codeTemplate: isId
              ? '''void dfs(Map<int, List<int>> graph, int node, Set<int> visited) {
  // Implementasikan DFS rekursif
  
}'''
              : '''void dfs(Map<int, List<int>> graph, int node, Set<int> visited) {
  // Implement recursive DFS
  
}''',
          hint: 'dfs_quiz_1_hint',
        ),
      ],

      useCases: 'dfs_use_cases',
      realWorldExample: 'dfs_real_world',
    );
  }

  // Dijkstra's Algorithm
  static AlgorithmContentEntity getDijkstra(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'dijkstra_summary',
      understandingText: 'dijkstra_understanding',

      algorithmSteps: [
        'dijkstra_step_1',
        'dijkstra_step_2',
        'dijkstra_step_3',
        'dijkstra_step_4',
        'dijkstra_step_5',
      ],

      codeExample: isId
          ? '''import 'dart:collection';

class Edge {
  int to;
  int weight;
  Edge(this.to, this.weight);
}

class Graph {
  Map<int, List<Edge>> adjList = {};
  
  void addEdge(int from, int to, int weight) {
    adjList.putIfAbsent(from, () => []);
    adjList[from]!.add(Edge(to, weight));
  }
  
  Map<int, int> dijkstra(int start) {
    Map<int, int> distances = {};
    PriorityQueue<MapEntry<int, int>> pq = 
      PriorityQueue((a, b) => a.value.compareTo(b.value));
    
    // Inisialisasi jarak
    for (int node in adjList.keys) {
      distances[node] = node == start ? 0 : 999999;
    }
    
    pq.add(MapEntry(start, 0));
    
    while (pq.isNotEmpty) {
      var current = pq.removeFirst();
      int node = current.key;
      int dist = current.value;
      
      if (dist > distances[node]!) continue;
      
      print('Proses node \$node (jarak: \$dist)');
      
      for (Edge edge in adjList[node] ?? []) {
        int newDist = dist + edge.weight;
        
        if (newDist < distances[edge.to]!) {
          distances[edge.to] = newDist;
          pq.add(MapEntry(edge.to, newDist));
          print('  Update jarak ke \${edge.to}: \$newDist');
        }
      }
    }
    
    return distances;
  }
}'''
          : '''import 'dart:collection';

class Edge {
  int to;
  int weight;
  Edge(this.to, this.weight);
}

class Graph {
  Map<int, List<Edge>> adjList = {};
  
  void addEdge(int from, int to, int weight) {
    adjList.putIfAbsent(from, () => []);
    adjList[from]!.add(Edge(to, weight));
  }
  
  Map<int, int> dijkstra(int start) {
    Map<int, int> distances = {};
    PriorityQueue<MapEntry<int, int>> pq = 
      PriorityQueue((a, b) => a.value.compareTo(b.value));
    
    // Initialize distances
    for (int node in adjList.keys) {
      distances[node] = node == start ? 0 : 999999;
    }
    
    pq.add(MapEntry(start, 0));
    
    while (pq.isNotEmpty) {
      var current = pq.removeFirst();
      int node = current.key;
      int dist = current.value;
      
      if (dist > distances[node]!) continue;
      
      print('Process node \$node (distance: \$dist)');
      
      for (Edge edge in adjList[node] ?? []) {
        int newDist = dist + edge.weight;
        
        if (newDist < distances[edge.to]!) {
          distances[edge.to] = newDist;
          pq.add(MapEntry(edge.to, newDist));
          print('  Update distance to \${edge.to}: \$newDist');
        }
      }
    }
    
    return distances;
  }
}''',

      output: isId
          ? '''Proses node 0 (jarak: 0)
  Update jarak ke 1: 4
  Update jarak ke 2: 1
Proses node 2 (jarak: 1)
  Update jarak ke 3: 3
Proses node 1 (jarak: 4)
Proses node 3 (jarak: 3)

Shortest distances dari 0:
0 → 0: 0
0 → 1: 4
0 → 2: 1
0 → 3: 3'''
          : '''Process node 0 (distance: 0)
  Update distance to 1: 4
  Update distance to 2: 1
Process node 2 (distance: 1)
  Update distance to 3: 3
Process node 1 (distance: 4)
Process node 3 (distance: 3)

Shortest distances from 0:
0 → 0: 0
0 → 1: 4
0 → 2: 1
0 → 3: 3''',

      timeComplexity: 'dijkstra_time_complexity',
      spaceComplexity: 'dijkstra_space_complexity',

      advantages: [
        'dijkstra_advantage_1',
        'dijkstra_advantage_2',
        'dijkstra_advantage_3',
        'dijkstra_advantage_4',
      ],

      disadvantages: [
        'dijkstra_disadvantage_1',
        'dijkstra_disadvantage_2',
        'dijkstra_disadvantage_3',
      ],

      visualSteps: [
        'dijkstra_visual_step_1',
        'dijkstra_visual_step_2',
        'dijkstra_visual_step_3',
        'dijkstra_visual_step_4',
        'dijkstra_visual_step_5',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'dijkstra_quiz_1_question',
          correctAnswer:
              '''Map<int, int> dijkstra(Map<int, List<Edge>> graph, int start) {
  Map<int, int> distances = {};
  Set<int> visited = {};
  
  for (int node in graph.keys) {
    distances[node] = node == start ? 0 : 999999;
  }
  
  for (int i = 0; i < graph.length; i++) {
    int minNode = -1;
    int minDist = 999999;
    
    for (int node in graph.keys) {
      if (!visited.contains(node) && distances[node]! < minDist) {
        minNode = node;
        minDist = distances[node]!;
      }
    }
    
    if (minNode == -1) break;
    visited.add(minNode);
    
    for (Edge edge in graph[minNode] ?? []) {
      int newDist = distances[minNode]! + edge.weight;
      if (newDist < distances[edge.to]!) {
        distances[edge.to] = newDist;
      }
    }
  }
  
  return distances;
}''',
          codeTemplate: isId
              ? '''Map<int, int> dijkstra(Map<int, List<Edge>> graph, int start) {
  // Implementasikan Dijkstra
  
}'''
              : '''Map<int, int> dijkstra(Map<int, List<Edge>> graph, int start) {
  // Implement Dijkstra
  
}''',
          hint: 'dijkstra_quiz_1_hint',
        ),
      ],

      useCases: 'dijkstra_use_cases',
      realWorldExample: 'dijkstra_real_world',
    );
  }

  // Bellman-Ford Algorithm
  static AlgorithmContentEntity getBellmanFord(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'bellman_summary',
      understandingText: 'bellman_understanding',

      algorithmSteps: [
        'bellman_step_1',
        'bellman_step_2',
        'bellman_step_3',
        'bellman_step_4',
      ],

      codeExample: isId
          ? '''class Edge {
  int from, to, weight;
  Edge(this.from, this.to, this.weight);
}

Map<int, int> bellmanFord(List<Edge> edges, int V, int start) {
  Map<int, int> dist = {};
  
  // Inisialisasi
  for (int i = 0; i < V; i++) {
    dist[i] = i == start ? 0 : 999999;
  }
  
  // Relax edges V-1 kali
  for (int i = 0; i < V - 1; i++) {
    for (Edge edge in edges) {
      if (dist[edge.from]! + edge.weight < dist[edge.to]!) {
        dist[edge.to] = dist[edge.from]! + edge.weight;
        print('Update dist[\${edge.to}] = \${dist[edge.to]}');
      }
    }
  }
  
  // Cek negative cycle
  for (Edge edge in edges) {
    if (dist[edge.from]! + edge.weight < dist[edge.to]!) {
      print('Negative cycle detected!');
      return {};
    }
  }
  
  return dist;
}

void main() {
  List<Edge> edges = [
    Edge(0, 1, 4),
    Edge(0, 2, 5),
    Edge(1, 2, -3),
    Edge(2, 3, 2),
  ];
  
  var result = bellmanFord(edges, 4, 0);
  print('Shortest distances: \$result');
}'''
          : '''class Edge {
  int from, to, weight;
  Edge(this.from, this.to, this.weight);
}

Map<int, int> bellmanFord(List<Edge> edges, int V, int start) {
  Map<int, int> dist = {};
  
  // Initialize
  for (int i = 0; i < V; i++) {
    dist[i] = i == start ? 0 : 999999;
  }
  
  // Relax edges V-1 times
  for (int i = 0; i < V - 1; i++) {
    for (Edge edge in edges) {
      if (dist[edge.from]! + edge.weight < dist[edge.to]!) {
        dist[edge.to] = dist[edge.from]! + edge.weight;
        print('Update dist[\${edge.to}] = \${dist[edge.to]}');
      }
    }
  }
  
  // Check negative cycle
  for (Edge edge in edges) {
    if (dist[edge.from]! + edge.weight < dist[edge.to]!) {
      print('Negative cycle detected!');
      return {};
    }
  }
  
  return dist;
}

void main() {
  List<Edge> edges = [
    Edge(0, 1, 4),
    Edge(0, 2, 5),
    Edge(1, 2, -3),
    Edge(2, 3, 2),
  ];
  
  var result = bellmanFord(edges, 4, 0);
  print('Shortest distances: \$result');
}''',

      output: isId
          ? '''Update dist[1] = 4
Update dist[2] = 5
Update dist[2] = 1
Update dist[3] = 3
Shortest distances: {0: 0, 1: 4, 2: 1, 3: 3}'''
          : '''Update dist[1] = 4
Update dist[2] = 5
Update dist[2] = 1
Update dist[3] = 3
Shortest distances: {0: 0, 1: 4, 2: 1, 3: 3}''',

      timeComplexity: 'bellman_time_complexity',
      spaceComplexity: 'bellman_space_complexity',

      advantages: [
        'bellman_advantage_1',
        'bellman_advantage_2',
        'bellman_advantage_3',
        'bellman_advantage_4',
      ],

      disadvantages: [
        'bellman_disadvantage_1',
        'bellman_disadvantage_2',
        'bellman_disadvantage_3',
      ],

      visualSteps: [
        'bellman_visual_step_1',
        'bellman_visual_step_2',
        'bellman_visual_step_3',
        'bellman_visual_step_4',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'bellman_quiz_1_question',
          correctAnswer:
              '''Map<int, int> bellmanFord(List<Edge> edges, int V, int start) {
  Map<int, int> dist = {};
  
  for (int i = 0; i < V; i++) {
    dist[i] = i == start ? 0 : 999999;
  }
  
  for (int i = 0; i < V - 1; i++) {
    for (Edge edge in edges) {
      if (dist[edge.from]! + edge.weight < dist[edge.to]!) {
        dist[edge.to] = dist[edge.from]! + edge.weight;
      }
    }
  }
  
  return dist;
}''',
          codeTemplate: isId
              ? '''Map<int, int> bellmanFord(List<Edge> edges, int V, int start) {
  // Implementasikan Bellman-Ford
  
}'''
              : '''Map<int, int> bellmanFord(List<Edge> edges, int V, int start) {
  // Implement Bellman-Ford
  
}''',
          hint: 'bellman_quiz_1_hint',
        ),
      ],

      useCases: 'bellman_use_cases',
      realWorldExample: 'bellman_real_world',
    );
  }

  // Floyd-Warshall Algorithm
  static AlgorithmContentEntity getFloydWarshall(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'floyd_summary',
      understandingText: 'floyd_understanding',

      algorithmSteps: [
        'floyd_step_1',
        'floyd_step_2',
        'floyd_step_3',
        'floyd_step_4',
      ],

      codeExample: isId
          ? '''List<List<int>> floydWarshall(List<List<int>> graph) {
  int V = graph.length;
  List<List<int>> dist = List.generate(
    V, (i) => List.from(graph[i])
  );
  
  // Floyd-Warshall algorithm
  for (int k = 0; k < V; k++) {
    print('\\nIntermediate node: \$k');
    for (int i = 0; i < V; i++) {
      for (int j = 0; j < V; j++) {
        if (dist[i][k] + dist[k][j] < dist[i][j]) {
          dist[i][j] = dist[i][k] + dist[k][j];
          print('  Update dist[\$i][\$j] = \${dist[i][j]}');
        }
      }
    }
  }
  
  return dist;
}

void main() {
  const INF = 999999;
  List<List<int>> graph = [
    [0, 5, INF, 10],
    [INF, 0, 3, INF],
    [INF, INF, 0, 1],
    [INF, INF, INF, 0],
  ];
  
  var result = floydWarshall(graph);
  print('\\nAll-pairs shortest paths:');
  for (int i = 0; i < result.length; i++) {
    print('From \$i: \${result[i]}');
  }
}'''
          : '''List<List<int>> floydWarshall(List<List<int>> graph) {
  int V = graph.length;
  List<List<int>> dist = List.generate(
    V, (i) => List.from(graph[i])
  );
  
  // Floyd-Warshall algorithm
  for (int k = 0; k < V; k++) {
    print('\\nIntermediate node: \$k');
    for (int i = 0; i < V; i++) {
      for (int j = 0; j < V; j++) {
        if (dist[i][k] + dist[k][j] < dist[i][j]) {
          dist[i][j] = dist[i][k] + dist[k][j];
          print('  Update dist[\$i][\$j] = \${dist[i][j]}');
        }
      }
    }
  }
  
  return dist;
}

void main() {
  const INF = 999999;
  List<List<int>> graph = [
    [0, 5, INF, 10],
    [INF, 0, 3, INF],
    [INF, INF, 0, 1],
    [INF, INF, INF, 0],
  ];
  
  var result = floydWarshall(graph);
  print('\\nAll-pairs shortest paths:');
  for (int i = 0; i < result.length; i++) {
    print('From \$i: \${result[i]}');
  }
}''',

      output: isId
          ? '''Intermediate node: 0
  Update dist[1][3] = 8

Intermediate node: 1
  Update dist[0][2] = 8
  Update dist[0][3] = 9

Intermediate node: 2
  Update dist[0][3] = 9
  Update dist[1][3] = 4

Intermediate node: 3

All-pairs shortest paths:
From 0: [0, 5, 8, 9]
From 1: [999999, 0, 3, 4]
From 2: [999999, 999999, 0, 1]
From 3: [999999, 999999, 999999, 0]'''
          : '''Intermediate node: 0
  Update dist[1][3] = 8

Intermediate node: 1
  Update dist[0][2] = 8
  Update dist[0][3] = 9

Intermediate node: 2
  Update dist[0][3] = 9
  Update dist[1][3] = 4

Intermediate node: 3

All-pairs shortest paths:
From 0: [0, 5, 8, 9]
From 1: [999999, 0, 3, 4]
From 2: [999999, 999999, 0, 1]
From 3: [999999, 999999, 999999, 0]''',

      timeComplexity: 'floyd_time_complexity',
      spaceComplexity: 'floyd_space_complexity',

      advantages: [
        'floyd_advantage_1',
        'floyd_advantage_2',
        'floyd_advantage_3',
        'floyd_advantage_4',
      ],

      disadvantages: [
        'floyd_disadvantage_1',
        'floyd_disadvantage_2',
        'floyd_disadvantage_3',
        'floyd_disadvantage_4',
      ],

      visualSteps: [
        'floyd_visual_step_1',
        'floyd_visual_step_2',
        'floyd_visual_step_3',
        'floyd_visual_step_4',
        'floyd_visual_step_5',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'floyd_quiz_1_question',
          correctAnswer:
              '''List<List<int>> floydWarshall(List<List<int>> graph) {
  int V = graph.length;
  List<List<int>> dist = List.generate(V, (i) => List.from(graph[i]));
  
  for (int k = 0; k < V; k++) {
    for (int i = 0; i < V; i++) {
      for (int j = 0; j < V; j++) {
        if (dist[i][k] + dist[k][j] < dist[i][j]) {
          dist[i][j] = dist[i][k] + dist[k][j];
        }
      }
    }
  }
  
  return dist;
}''',
          codeTemplate: isId
              ? '''List<List<int>> floydWarshall(List<List<int>> graph) {
  // Implementasikan Floyd-Warshall
  
}'''
              : '''List<List<int>> floydWarshall(List<List<int>> graph) {
  // Implement Floyd-Warshall
  
}''',
          hint: 'floyd_quiz_1_hint',
        ),
      ],

      useCases: 'floyd_use_cases',
      realWorldExample: 'floyd_real_world',
    );
  }

  // Kruskal's MST Algorithm
  static AlgorithmContentEntity getKruskal(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'kruskal_summary',
      understandingText: 'kruskal_understanding',

      algorithmSteps: [
        'kruskal_step_1',
        'kruskal_step_2',
        'kruskal_step_3',
        'kruskal_step_4',
      ],

      codeExample: isId
          ? '''class Edge implements Comparable<Edge> {
  int from, to, weight;
  Edge(this.from, this.to, this.weight);
  
  @override
  int compareTo(Edge other) => weight.compareTo(other.weight);
}

class UnionFind {
  List<int> parent, rank;
  
  UnionFind(int n) : parent = List.generate(n, (i) => i), rank = List.filled(n, 0);
  
  int find(int x) {
    if (parent[x] != x) parent[x] = find(parent[x]);
    return parent[x];
  }
  
  bool union(int x, int y) {
    int px = find(x), py = find(y);
    if (px == py) return false;
    
    if (rank[px] < rank[py]) {
      parent[px] = py;
    } else if (rank[px] > rank[py]) {
      parent[py] = px;
    } else {
      parent[py] = px;
      rank[px]++;
    }
    return true;
  }
}

List<Edge> kruskal(List<Edge> edges, int V) {
  edges.sort();
  UnionFind uf = UnionFind(V);
  List<Edge> mst = [];
  
  for (Edge edge in edges) {
    if (uf.union(edge.from, edge.to)) {
      mst.add(edge);
      print('Add edge: \${edge.from}-\${edge.to} (weight: \${edge.weight})');
      
      if (mst.length == V - 1) break;
    }
  }
  
  return mst;
}

void main() {
  List<Edge> edges = [
    Edge(0, 1, 4),
    Edge(0, 2, 3),
    Edge(1, 2, 1),
    Edge(1, 3, 2),
    Edge(2, 3, 4),
  ];
  
  var mst = kruskal(edges, 4);
  int totalWeight = mst.fold(0, (sum, e) => sum + e.weight);
  print('\\nTotal MST weight: \$totalWeight');
}'''
          : '''class Edge implements Comparable<Edge> {
  int from, to, weight;
  Edge(this.from, this.to, this.weight);
  
  @override
  int compareTo(Edge other) => weight.compareTo(other.weight);
}

class UnionFind {
  List<int> parent, rank;
  
  UnionFind(int n) : parent = List.generate(n, (i) => i), rank = List.filled(n, 0);
  
  int find(int x) {
    if (parent[x] != x) parent[x] = find(parent[x]);
    return parent[x];
  }
  
  bool union(int x, int y) {
    int px = find(x), py = find(y);
    if (px == py) return false;
    
    if (rank[px] < rank[py]) {
      parent[px] = py;
    } else if (rank[px] > rank[py]) {
      parent[py] = px;
    } else {
      parent[py] = px;
      rank[px]++;
    }
    return true;
  }
}

List<Edge> kruskal(List<Edge> edges, int V) {
  edges.sort();
  UnionFind uf = UnionFind(V);
  List<Edge> mst = [];
  
  for (Edge edge in edges) {
    if (uf.union(edge.from, edge.to)) {
      mst.add(edge);
      print('Add edge: \${edge.from}-\${edge.to} (weight: \${edge.weight})');
      
      if (mst.length == V - 1) break;
    }
  }
  
  return mst;
}

void main() {
  List<Edge> edges = [
    Edge(0, 1, 4),
    Edge(0, 2, 3),
    Edge(1, 2, 1),
    Edge(1, 3, 2),
    Edge(2, 3, 4),
  ];
  
  var mst = kruskal(edges, 4);
  int totalWeight = mst.fold(0, (sum, e) => sum + e.weight);
  print('\\nTotal MST weight: \$totalWeight');
}''',

      output: '''Add edge: 1-2 (weight: 1)
Add edge: 1-3 (weight: 2)
Add edge: 0-2 (weight: 3)

Total MST weight: 6''',

      timeComplexity: 'kruskal_time_complexity',
      spaceComplexity: 'kruskal_space_complexity',

      advantages: [
        'kruskal_advantage_1',
        'kruskal_advantage_2',
        'kruskal_advantage_3',
        'kruskal_advantage_4',
      ],

      disadvantages: [
        'kruskal_disadvantage_1',
        'kruskal_disadvantage_2',
        'kruskal_disadvantage_3',
      ],

      visualSteps: [
        'kruskal_visual_step_1',
        'kruskal_visual_step_2',
        'kruskal_visual_step_3',
        'kruskal_visual_step_4',
        'kruskal_visual_step_5',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'kruskal_quiz_1_question',
          correctAnswer: '''List<Edge> kruskal(List<Edge> edges, int V) {
  edges.sort();
  UnionFind uf = UnionFind(V);
  List<Edge> mst = [];
  
  for (Edge edge in edges) {
    if (uf.union(edge.from, edge.to)) {
      mst.add(edge);
      if (mst.length == V - 1) break;
    }
  }
  
  return mst;
}''',
          codeTemplate: isId
              ? '''List<Edge> kruskal(List<Edge> edges, int V) {
  // Implementasikan Kruskal
  
}'''
              : '''List<Edge> kruskal(List<Edge> edges, int V) {
  // Implement Kruskal
  
}''',
          hint: 'kruskal_quiz_1_hint',
        ),
      ],

      useCases: 'kruskal_use_cases',
      realWorldExample: 'kruskal_real_world',
    );
  }

  // Prim's MST Algorithm
  static AlgorithmContentEntity getPrim(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'prim_summary',
      understandingText: 'prim_understanding',

      algorithmSteps: [
        'prim_step_1',
        'prim_step_2',
        'prim_step_3',
        'prim_step_4',
        'prim_step_5',
        'prim_step_6',
      ],

      codeExample: isId
          ? '''import 'dart:collection';

class Edge {
  int to, weight;
  Edge(this.to, this.weight);
}

class PQEdge implements Comparable<PQEdge> {
  int from, to, weight;
  PQEdge(this.from, this.to, this.weight);
  
  @override
  int compareTo(PQEdge other) => weight.compareTo(other.weight);
}

List<PQEdge> prim(Map<int, List<Edge>> graph, int start) {
  Set<int> visited = {};
  List<PQEdge> mst = [];
  PriorityQueue<PQEdge> pq = PriorityQueue();
  
  void addEdges(int node) {
    visited.add(node);
    for (Edge edge in graph[node] ?? []) {
      if (!visited.contains(edge.to)) {
        pq.add(PQEdge(node, edge.to, edge.weight));
      }
    }
  }
  
  addEdges(start);
  
  while (pq.isNotEmpty && visited.length < graph.length) {
    PQEdge edge = pq.removeFirst();
    
    if (visited.contains(edge.to)) continue;
    
    mst.add(edge);
    print('Add edge: \${edge.from}-\${edge.to} (weight: \${edge.weight})');
    
    addEdges(edge.to);
  }
  
  return mst;
}

void main() {
  Map<int, List<Edge>> graph = {
    0: [Edge(1, 4), Edge(2, 3)],
    1: [Edge(0, 4), Edge(2, 1), Edge(3, 2)],
    2: [Edge(0, 3), Edge(1, 1), Edge(3, 4)],
    3: [Edge(1, 2), Edge(2, 4)],
  };
  
  var mst = prim(graph, 0);
  int totalWeight = mst.fold(0, (sum, e) => sum + e.weight);
  print('\\nTotal MST weight: \$totalWeight');
}'''
          : '''import 'dart:collection';

class Edge {
  int to, weight;
  Edge(this.to, this.weight);
}

class PQEdge implements Comparable<PQEdge> {
  int from, to, weight;
  PQEdge(this.from, this.to, this.weight);
  
  @override
  int compareTo(PQEdge other) => weight.compareTo(other.weight);
}

List<PQEdge> prim(Map<int, List<Edge>> graph, int start) {
  Set<int> visited = {};
  List<PQEdge> mst = [];
  PriorityQueue<PQEdge> pq = PriorityQueue();
  
  void addEdges(int node) {
    visited.add(node);
    for (Edge edge in graph[node] ?? []) {
      if (!visited.contains(edge.to)) {
        pq.add(PQEdge(node, edge.to, edge.weight));
      }
    }
  }
  
  addEdges(start);
  
  while (pq.isNotEmpty && visited.length < graph.length) {
    PQEdge edge = pq.removeFirst();
    
    if (visited.contains(edge.to)) continue;
    
    mst.add(edge);
    print('Add edge: \${edge.from}-\${edge.to} (weight: \${edge.weight})');
    
    addEdges(edge.to);
  }
  
  return mst;
}

void main() {
  Map<int, List<Edge>> graph = {
    0: [Edge(1, 4), Edge(2, 3)],
    1: [Edge(0, 4), Edge(2, 1), Edge(3, 2)],
    2: [Edge(0, 3), Edge(1, 1), Edge(3, 4)],
    3: [Edge(1, 2), Edge(2, 4)],
  };
  
  var mst = prim(graph, 0);
  int totalWeight = mst.fold(0, (sum, e) => sum + e.weight);
  print('\\nTotal MST weight: \$totalWeight');
}''',

      output: '''Add edge: 0-2 (weight: 3)
Add edge: 2-1 (weight: 1)
Add edge: 1-3 (weight: 2)

Total MST weight: 6''',

      timeComplexity: 'prim_time_complexity',
      spaceComplexity: 'prim_space_complexity',

      advantages: [
        'prim_advantage_1',
        'prim_advantage_2',
        'prim_advantage_3',
        'prim_advantage_4',
      ],

      disadvantages: [
        'prim_disadvantage_1',
        'prim_disadvantage_2',
        'prim_disadvantage_3',
      ],

      visualSteps: [
        'prim_visual_step_1',
        'prim_visual_step_2',
        'prim_visual_step_3',
        'prim_visual_step_4',
        'prim_visual_step_5',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'prim_quiz_1_question',
          correctAnswer:
              '''List<PQEdge> prim(Map<int, List<Edge>> graph, int start) {
  Set<int> visited = {};
  List<PQEdge> mst = [];
  PriorityQueue<PQEdge> pq = PriorityQueue();
  
  void addEdges(int node) {
    visited.add(node);
    for (Edge edge in graph[node] ?? []) {
      if (!visited.contains(edge.to)) {
        pq.add(PQEdge(node, edge.to, edge.weight));
      }
    }
  }
  
  addEdges(start);
  
  while (pq.isNotEmpty && visited.length < graph.length) {
    PQEdge edge = pq.removeFirst();
    if (visited.contains(edge.to)) continue;
    mst.add(edge);
    addEdges(edge.to);
  }
  
  return mst;
}''',
          codeTemplate: isId
              ? '''List<PQEdge> prim(Map<int, List<Edge>> graph, int start) {
  // Implementasikan Prim
  
}'''
              : '''List<PQEdge> prim(Map<int, List<Edge>> graph, int start) {
  // Implement Prim
  
}''',
          hint: 'prim_quiz_1_hint',
        ),
      ],

      useCases: 'prim_use_cases',
      realWorldExample: 'prim_real_world',
    );
  }
}
