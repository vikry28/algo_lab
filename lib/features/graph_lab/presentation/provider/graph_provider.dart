// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/graph_node.dart';
import '../../domain/usecases/dijkstra_usecase.dart';
import '../../domain/usecases/k_shortest_path_usecase.dart';
import '../../domain/usecases/ecmp_usecase.dart';

enum AlgorithmType { dijkstra, kShortestPath, ecmp }

class BackgroundPacket {
  Offset position;
  final String edgeId;
  double progress;
  final Color color;

  BackgroundPacket({
    required this.position,
    required this.edgeId,
    this.progress = 0.0,
    required this.color,
  });
}

class GraphProvider with ChangeNotifier {
  final DijkstraUseCase _dijkstraUseCase = DijkstraUseCase();
  final KShortestPathUseCase _kShortestPathUseCase = KShortestPathUseCase();
  final ECMPUseCase _ecmpUseCase = ECMPUseCase();

  AlgorithmType algorithmType = AlgorithmType.dijkstra;
  final Random _random = Random();

  List<GraphNode> nodes = [];
  List<GraphEdge> edges = [];
  List<DijkstraStep> steps = [];
  int currentStepIndex = -1;
  bool isRunning = false;
  bool isFinished = false;
  double animationSpeed = 1.0;

  String startNodeId = "JAKARTA-DC";
  String targetNodeId = "SINGAPORE-DC";

  Offset? packetPosition;
  bool isPacketVisible = false;

  List<BackgroundPacket> backgroundPackets = [];
  Timer? _realtimeTimer;
  Timer? _backgroundTrafficTimer;
  double _timeCounter = 0;

  final TransformationController transformationController =
      TransformationController();

  GraphProvider() {
    _initializeRealWorldNetwork();
    _startRealtimeTrafficSimulation();
    _startBackgroundTraffic();
  }

  void _initializeRealWorldNetwork() {
    // Optimized layout: Left to Right, well-spaced nodes
    // Canvas size: 1000x600 for better spacing

    nodes = [
      // === LAYER 1: SOURCE (Left) ===
      GraphNode(
        id: "JAKARTA-DC",
        label: "Jakarta DC",
        labelKey: "graph_node_jakarta",
        type: NodeType.server,
        position: const Offset(100, 300),
      ),

      // === LAYER 2: CORE ROUTERS ===
      GraphNode(
        id: "JKT-CORE-1",
        label: "Core Router 1",
        labelKey: "graph_node_core1",
        type: NodeType.router,
        position: const Offset(250, 200),
      ),
      GraphNode(
        id: "JKT-CORE-2",
        label: "Core Router 2",
        labelKey: "graph_node_core2",
        type: NodeType.router,
        position: const Offset(250, 400),
      ),

      // === LAYER 3: REGIONAL HUBS ===
      GraphNode(
        id: "SURABAYA-HUB",
        label: "Surabaya Hub",
        labelKey: "graph_node_surabaya",
        type: NodeType.hub,
        position: const Offset(400, 150),
      ),
      GraphNode(
        id: "BANDUNG-HUB",
        label: "Bandung Hub",
        labelKey: "graph_node_bandung",
        type: NodeType.hub,
        position: const Offset(400, 300),
      ),

      // === LAYER 4: INTERNATIONAL GATEWAY ===
      GraphNode(
        id: "BATAM-GATEWAY",
        label: "Batam Gateway",
        labelKey: "graph_node_batam",
        type: NodeType.router,
        position: const Offset(550, 250),
      ),

      // === LAYER 5: CABLE LANDING STATIONS ===
      GraphNode(
        id: "CABLE-LANDING-ID",
        label: "ID Cable Station",
        labelKey: "graph_node_id_cable",
        type: NodeType.hub,
        position: const Offset(700, 300),
      ),

      GraphNode(
        id: "CABLE-LANDING-SG",
        label: "SG Cable Station",
        labelKey: "graph_node_sg_cable",
        type: NodeType.hub,
        position: const Offset(850, 300),
      ),

      // === LAYER 6: SINGAPORE EDGE ===
      GraphNode(
        id: "SG-EDGE-1",
        label: "SG Edge 1",
        labelKey: "graph_node_sg_edge1",
        type: NodeType.router,
        position: const Offset(1000, 200),
      ),
      GraphNode(
        id: "SG-EDGE-2",
        label: "SG Edge 2",
        labelKey: "graph_node_sg_edge2",
        type: NodeType.router,
        position: const Offset(1000, 400),
      ),

      // === LAYER 7: DESTINATION (Right) ===
      GraphNode(
        id: "SINGAPORE-DC",
        label: "Singapore DC",
        labelKey: "graph_node_singapore",
        type: NodeType.server,
        position: const Offset(1150, 300),
      ),
    ];

    edges = [
      // Layer 1 → 2
      GraphEdge(
        id: "e1",
        fromNodeId: "JAKARTA-DC",
        toNodeId: "JKT-CORE-1",
        weight: 5,
      ),
      GraphEdge(
        id: "e2",
        fromNodeId: "JAKARTA-DC",
        toNodeId: "JKT-CORE-2",
        weight: 5,
      ),

      // Layer 2 internal
      GraphEdge(
        id: "e3",
        fromNodeId: "JKT-CORE-1",
        toNodeId: "JKT-CORE-2",
        weight: 3,
      ),

      // Layer 2 → 3
      GraphEdge(
        id: "e4",
        fromNodeId: "JKT-CORE-1",
        toNodeId: "SURABAYA-HUB",
        weight: 25,
      ),
      GraphEdge(
        id: "e5",
        fromNodeId: "JKT-CORE-2",
        toNodeId: "BANDUNG-HUB",
        weight: 15,
      ),
      // Missing Link for Optimal Path 1: Core 1 -> Bandung
      GraphEdge(
        id: "e19",
        fromNodeId: "JKT-CORE-1",
        toNodeId: "BANDUNG-HUB",
        weight: 15,
      ),

      // Layer 3 internal (redundancy)
      GraphEdge(
        id: "e6",
        fromNodeId: "SURABAYA-HUB",
        toNodeId: "BANDUNG-HUB",
        weight: 30,
      ),

      // Layer 3 → 4
      GraphEdge(
        id: "e7",
        fromNodeId: "SURABAYA-HUB",
        toNodeId: "BATAM-GATEWAY",
        weight: 35,
      ),
      GraphEdge(
        id: "e8",
        fromNodeId: "BANDUNG-HUB",
        toNodeId: "BATAM-GATEWAY",
        weight: 40,
      ),

      // Direct path (backup)
      GraphEdge(
        id: "e9",
        fromNodeId: "JKT-CORE-1",
        toNodeId: "BATAM-GATEWAY",
        weight: 45,
      ),

      // Layer 4 → 5
      GraphEdge(
        id: "e10",
        fromNodeId: "BATAM-GATEWAY",
        toNodeId: "CABLE-LANDING-ID",
        weight: 20,
      ),

      // Backup path
      GraphEdge(
        id: "e11",
        fromNodeId: "BANDUNG-HUB",
        toNodeId: "CABLE-LANDING-ID",
        weight: 55,
      ),

      // Layer 5 → 5 (Submarine Cable - Critical)
      GraphEdge(
        id: "e12",
        fromNodeId: "CABLE-LANDING-ID",
        toNodeId: "CABLE-LANDING-SG",
        weight: 30,
      ),

      // Layer 5 → 6
      GraphEdge(
        id: "e13",
        fromNodeId: "CABLE-LANDING-SG",
        toNodeId: "SG-EDGE-1",
        weight: 10,
      ),
      GraphEdge(
        id: "e14",
        fromNodeId: "CABLE-LANDING-SG",
        toNodeId: "SG-EDGE-2",
        weight: 10,
      ),

      // Layer 6 internal
      GraphEdge(
        id: "e15",
        fromNodeId: "SG-EDGE-1",
        toNodeId: "SG-EDGE-2",
        weight: 5,
      ),

      // Layer 6 → 7
      GraphEdge(
        id: "e16",
        fromNodeId: "SG-EDGE-1",
        toNodeId: "SINGAPORE-DC",
        weight: 8,
      ),
      GraphEdge(
        id: "e17",
        fromNodeId: "SG-EDGE-2",
        toNodeId: "SINGAPORE-DC",
        weight: 8,
      ),

      // Literal "Cable Direct" (Backup Private Cable)
      GraphEdge(
        id: "e20",
        fromNodeId: "BANDUNG-HUB",
        toNodeId: "CABLE-LANDING-SG",
        weight: 60,
      ),

      // Emergency satellite backup (disabled)
      GraphEdge(
        id: "e18",
        fromNodeId: "JAKARTA-DC",
        toNodeId: "SINGAPORE-DC",
        weight: 200,
        isAlive: false,
      ),
    ];

    notifyListeners();
  }

  void _startBackgroundTraffic() {
    _backgroundTrafficTimer?.cancel();
    _backgroundTrafficTimer = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) {
      if (isRunning) return;

      backgroundPackets = backgroundPackets.where((packet) {
        packet.progress += 0.02;

        if (packet.progress >= 1.0) {
          return false;
        }

        final edge = edges.firstWhere((e) => e.id == packet.edgeId);
        final fromNode = nodes.firstWhere((n) => n.id == edge.fromNodeId);
        final toNode = nodes.firstWhere((n) => n.id == edge.toNodeId);

        packet.position = Offset(
          fromNode.position.dx +
              (toNode.position.dx - fromNode.position.dx) * packet.progress,
          fromNode.position.dy +
              (toNode.position.dy - fromNode.position.dy) * packet.progress,
        );

        return true;
      }).toList();

      if (_random.nextDouble() > 0.7 && backgroundPackets.length < 15) {
        final activeEdges = edges
            .where((e) => e.isAlive && e.trafficLoad > 0.3)
            .toList();

        if (activeEdges.isNotEmpty) {
          final randomEdge = activeEdges[_random.nextInt(activeEdges.length)];
          final fromNode = nodes.firstWhere(
            (n) => n.id == randomEdge.fromNodeId,
          );

          Color packetColor;
          if (randomEdge.trafficLoad > 0.7) {
            packetColor = Colors.orangeAccent;
          } else if (randomEdge.trafficLoad > 0.5) {
            packetColor = Colors.yellowAccent;
          } else {
            packetColor = Colors.greenAccent;
          }

          backgroundPackets.add(
            BackgroundPacket(
              position: fromNode.position,
              edgeId: randomEdge.id,
              color: packetColor.withValues(alpha: 0.6),
            ),
          );
        }
      }

      notifyListeners();
    });
  }

  void _startRealtimeTrafficSimulation() {
    _realtimeTimer?.cancel();
    _realtimeTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (isRunning) return;

      _timeCounter += 0.08;

      edges = edges.map((e) {
        if (!e.isAlive) return e;

        bool isSubmarineCable = e.id == "e12";
        bool isCoreLink = e.id == "e1" || e.id == "e2" || e.id == "e3";

        double stability = isSubmarineCable ? 0.85 : (isCoreLink ? 0.75 : 0.6);
        double baseFrequency = e.weight / 60.0;
        double noise = _random.nextDouble() * (1 - stability) * 0.3;

        double wave1 =
            (sin(_timeCounter * baseFrequency + e.id.hashCode) + 1) / 2;
        double wave2 =
            (sin(_timeCounter * baseFrequency * 1.5 + e.id.hashCode * 2) + 1) /
            2;
        double combinedWave = (wave1 * 0.7 + wave2 * 0.3);

        double load = (combinedWave * stability) + noise;

        return e.copyWith(trafficLoad: load.clamp(0.0, 1.0));
      }).toList();

      if (_random.nextDouble() > 0.997) {
        int nodeIdx = _random.nextInt(nodes.length);
        if (nodes[nodeIdx].id != "JAKARTA-DC" &&
            nodes[nodeIdx].id != "SINGAPORE-DC" &&
            nodes[nodeIdx].id != "CABLE-LANDING-ID" &&
            nodes[nodeIdx].id != "CABLE-LANDING-SG") {
          nodes[nodeIdx] = nodes[nodeIdx].copyWith(
            isAlive: !nodes[nodeIdx].isAlive,
          );
        }
      }

      notifyListeners();
    });
  }

  void zoomIn() {
    final currentScale = transformationController.value.getMaxScaleOnAxis();
    if (currentScale < 3.0) {
      transformationController.value = transformationController.value.clone()
        // ignore: deprecated_member_use
        ..scale(1.2, 1.2);
      notifyListeners();
    }
  }

  void zoomOut() {
    final currentScale = transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 0.2) {
      transformationController.value = transformationController.value.clone()
        ..scale(0.8, 0.8);
      notifyListeners();
    }
  }

  void toggleNodeStatus(String id) {
    int idx = nodes.indexWhere((n) => n.id == id);
    if (idx != -1) {
      nodes[idx] = nodes[idx].copyWith(isAlive: !nodes[idx].isAlive);
      notifyListeners();
    }
  }

  void reset() {
    isRunning = false;
    isFinished = false;
    currentStepIndex = -1;
    packetPosition = null;
    isPacketVisible = false;
    backgroundPackets.clear();
    _initializeRealWorldNetwork();
    transformationController.value = Matrix4.identity();
    notifyListeners();
  }

  void setSpeed(double speed) {
    animationSpeed = speed;
    notifyListeners();
  }

  void setStartNode(String id) {
    if (id == targetNodeId) return;
    startNodeId = id;
    reset();
  }

  void setTargetNode(String id) {
    if (id == startNodeId) return;
    targetNodeId = id;
    reset();
  }

  void setAlgorithmType(AlgorithmType type) {
    algorithmType = type;
    notifyListeners();
  }

  Future<void> runSimulation() async {
    if (isRunning) return;

    // Ensure network is viable before starting
    // We allow the simulation to run on the current state of the network.
    // If nodes are down (manually or via chaos monkey), Dijkstra will find backup paths.
    // _ensureCriticalPathAlive();

    isRunning = true;
    isFinished = false;
    backgroundPackets.clear();

    switch (algorithmType) {
      case AlgorithmType.dijkstra:
        steps = _dijkstraUseCase.execute(
          nodes,
          edges,
          startNodeId,
          targetNodeId,
        );
        break;
      case AlgorithmType.kShortestPath:
        steps = _kShortestPathUseCase.execute(
          nodes,
          edges,
          startNodeId,
          targetNodeId,
        );
        break;
      case AlgorithmType.ecmp:
        steps = _ecmpUseCase.execute(nodes, edges, startNodeId, targetNodeId);
        break;
    }
    currentStepIndex = 0;

    while (currentStepIndex < steps.length && isRunning) {
      final currentStep = steps[currentStepIndex];
      packetPosition = null;
      isPacketVisible = false;

      nodes = currentStep.nodes;
      edges = currentStep.edges;

      if (currentStep.sourceNodeId != null &&
          currentStep.targetNodeId != null) {
        await _animatePacket(
          currentStep.sourceNodeId!,
          currentStep.targetNodeId!,
        );
      } else {
        notifyListeners();
        int delay = (1200 / animationSpeed).toInt();
        await Future.delayed(Duration(milliseconds: delay));
      }
      currentStepIndex++;
    }

    isRunning = false;
    isFinished = true; // Mark as finished
    notifyListeners();
  }

  Future<void> _animatePacket(String sourceId, String targetId) async {
    final startNode = nodes.firstWhere((n) => n.id == sourceId);
    final endNode = nodes.firstWhere((n) => n.id == targetId);

    isPacketVisible = true;
    int animSteps = 40;
    int totalDuration = (1000 / animationSpeed).toInt();
    int interval = totalDuration ~/ animSteps;

    for (int i = 0; i <= animSteps; i++) {
      if (!isRunning) break;
      double t = i / animSteps;

      double easedT = t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2;

      packetPosition = Offset(
        startNode.position.dx +
            (endNode.position.dx - startNode.position.dx) * easedT,
        startNode.position.dy +
            (endNode.position.dy - startNode.position.dy) * easedT,
      );
      notifyListeners();
      await Future.delayed(Duration(milliseconds: interval));
    }
    isPacketVisible = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _realtimeTimer?.cancel();
    _backgroundTrafficTimer?.cancel();
    transformationController.dispose();
    super.dispose();
  }
}
