import 'package:flutter/material.dart';
import '../../domain/entities/graph_node.dart';
import '../provider/graph_provider.dart';

class GraphPainter extends CustomPainter {
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final String? activeNodeId;
  final Offset? packetPosition;
  final bool isPacketVisible;
  final bool isDark;
  final List<BackgroundPacket> backgroundPackets;

  GraphPainter({
    required this.nodes,
    required this.edges,
    this.activeNodeId,
    this.packetPosition,
    this.isPacketVisible = false,
    required this.isDark,
    this.backgroundPackets = const [],
  });

  IconData _getModernNodeIcon(NodeType type) {
    switch (type) {
      case NodeType.server:
        return Icons.dns; // Modern server rack
      case NodeType.cloud:
        return Icons.cloud_circle; // Cloud with circle
      case NodeType.terminal:
        return Icons.devices; // Multiple devices
      case NodeType.hub:
        return Icons.hub; // Network hub
      case NodeType.router:
        return Icons.router; // Modern router icon
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Edges with modern gradient effects
    for (var edge in edges) {
      final fromNode = nodes.firstWhere((n) => n.id == edge.fromNodeId);
      final toNode = nodes.firstWhere((n) => n.id == edge.toNodeId);

      bool isBroken = !edge.isAlive || !fromNode.isAlive || !toNode.isAlive;

      Color edgeColor;
      if (isBroken) {
        edgeColor = Colors.redAccent.withValues(alpha: 0.3);
      } else if (edge.isHighlighted) {
        edgeColor = Colors.cyanAccent;
      } else {
        edgeColor = isDark
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.black.withValues(alpha: 0.1);
      }

      final paint = Paint()
        ..color = edgeColor
        ..strokeWidth = edge.isHighlighted ? 6.0 : 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (edge.isHighlighted && !isBroken) {
        // Multi-layer glow effect
        for (int i = 0; i < 3; i++) {
          final glowPaint = Paint()
            ..color = Colors.cyanAccent.withValues(alpha: 0.2 - (i * 0.05))
            ..strokeWidth = 12 + (i * 4)
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 + (i * 2));
          canvas.drawLine(fromNode.position, toNode.position, glowPaint);
        }
      }

      // Draw edge
      if (isBroken) {
        _drawDashedLine(canvas, fromNode.position, toNode.position, paint);
      } else {
        canvas.drawLine(fromNode.position, toNode.position, paint);

        // Enhanced traffic visualization with gradient
        if (edge.trafficLoad > 0.2 && !edge.isHighlighted) {
          final loadColor = edge.trafficLoad > 0.7
              ? Colors.orangeAccent
              : (edge.trafficLoad > 0.5
                    ? Colors.amberAccent
                    : Colors.greenAccent);

          final loadPaint = Paint()
            ..color = loadColor.withValues(alpha: edge.trafficLoad * 0.6)
            ..strokeWidth = 4.0
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
          canvas.drawLine(fromNode.position, toNode.position, loadPaint);
        }
      }

      // Modern directional arrow
      if (edge.isHighlighted && !isBroken) {
        _drawModernArrow(
          canvas,
          fromNode.position,
          toNode.position,
          Colors.cyanAccent,
        );
      }

      // Enhanced label with modern styling
      final midpoint = Offset(
        (fromNode.position.dx + toNode.position.dx) / 2,
        (fromNode.position.dy + toNode.position.dy) / 2,
      );

      final labelText = isBroken ? "✗ OFFLINE" : "${edge.weight.toInt()}ms";
      final labelColor = isBroken
          ? Colors.redAccent
          : (edge.isHighlighted
                ? Colors.cyanAccent
                : (isDark ? Colors.white70 : Colors.black87));

      final textPainter = TextPainter(
        text: TextSpan(
          text: labelText,
          style: TextStyle(
            color: labelColor,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelBg = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: midpoint,
          width: textPainter.width + 14,
          height: textPainter.height + 10,
        ),
        const Radius.circular(6),
      );

      // Modern glass effect
      canvas.drawRRect(
        labelBg,
        Paint()
          ..color = isDark
              ? Colors.black.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.95)
          ..style = PaintingStyle.fill,
      );

      canvas.drawRRect(
        labelBg,
        Paint()
          ..color = labelColor.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      textPainter.paint(
        canvas,
        midpoint - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // 2. Draw Background Traffic Packets
    for (var bgPacket in backgroundPackets) {
      // Outer glow
      canvas.drawCircle(
        bgPacket.position,
        8,
        Paint()
          ..color = bgPacket.color.withValues(alpha: 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      // Middle layer
      canvas.drawCircle(bgPacket.position, 4, Paint()..color = bgPacket.color);

      // Core
      canvas.drawCircle(
        bgPacket.position,
        2,
        Paint()..color = Colors.white.withValues(alpha: 0.9),
      );
    }

    // 3. Draw Main Packet (Dijkstra)
    if (isPacketVisible && packetPosition != null) {
      // Triple pulse effect
      for (int i = 0; i < 3; i++) {
        canvas.drawCircle(
          packetPosition!,
          14 + (i * 4),
          Paint()
            ..color = Colors.yellowAccent.withValues(alpha: 0.15 - (i * 0.03))
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 + (i * 2)),
        );
      }

      // Main glow
      canvas.drawCircle(
        packetPosition!,
        9,
        Paint()..color = Colors.yellowAccent.withValues(alpha: 0.9),
      );

      // Core
      canvas.drawCircle(packetPosition!, 5, Paint()..color = Colors.white);

      // Center dot
      canvas.drawCircle(
        packetPosition!,
        2.5,
        Paint()..color = Colors.cyanAccent,
      );
    }

    // 4. Draw Nodes with modern design
    for (var node in nodes) {
      final isActive = node.id == activeNodeId;

      Color nodeColor;
      IconData iconData = _getModernNodeIcon(node.type);

      if (!node.isAlive) {
        nodeColor = Colors.redAccent;
      } else {
        switch (node.status) {
          case NodeStatus.visited:
            nodeColor = Colors.blueAccent;
            break;
          case NodeStatus.current:
            nodeColor = Colors.orangeAccent;
            break;
          case NodeStatus.path:
            nodeColor = Colors.cyanAccent;
            break;
          default:
            nodeColor = isDark
                ? const Color(0xFF64748B)
                : const Color(0xFF94A3B8);
        }
      }

      // Multi-layer pulsing glow
      if (node.isAlive && (isActive || node.status == NodeStatus.path)) {
        for (int i = 0; i < 3; i++) {
          canvas.drawCircle(
            node.position,
            28 + (i * 6),
            Paint()
              ..color = nodeColor.withValues(alpha: 0.25 - (i * 0.06))
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12 + (i * 3)),
          );
        }
      }

      // Modern shadow
      canvas.drawCircle(
        node.position + const Offset(3, 3),
        25,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      // Node body with gradient effect
      canvas.drawCircle(
        node.position,
        25,
        Paint()
          ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFFAFAFA),
      );

      // Inner gradient
      canvas.drawCircle(
        node.position,
        23,
        Paint()..color = nodeColor.withValues(alpha: 0.15),
      );

      // Modern border with double ring
      final outerBorderPaint = Paint()
        ..color = nodeColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(node.position, 26, outerBorderPaint);

      final innerBorderPaint = Paint()
        ..color = nodeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = isActive ? 4.5 : 3.0;
      canvas.drawCircle(node.position, 25, innerBorderPaint);

      // Modern icon with shadow
      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(iconData.codePoint),
          style: TextStyle(
            fontSize: 24,
            fontFamily: iconData.fontFamily,
            package: iconData.fontPackage,
            color: node.isAlive
                ? nodeColor
                : Colors.redAccent.withValues(alpha: 0.6),
            shadows: [
              Shadow(
                color: nodeColor.withValues(alpha: 0.4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      iconPainter.paint(
        canvas,
        node.position - Offset(iconPainter.width / 2, iconPainter.height / 2),
      );

      // Modern label with glass effect
      final labelPainter = TextPainter(
        text: TextSpan(
          text: node.label.toUpperCase(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: isDark ? Colors.black : Colors.white,
                blurRadius: 5,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 2,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 130);

      final labelPos = node.position + const Offset(0, 35);
      final labelRect = Rect.fromCenter(
        center: labelPos,
        width: labelPainter.width + 14,
        height: labelPainter.height + 10,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(8)),
        Paint()
          ..color = (isDark ? Colors.black : Colors.white).withValues(
            alpha: 0.85,
          ),
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(8)),
        Paint()
          ..color = nodeColor.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      labelPainter.paint(
        canvas,
        labelPos - Offset(labelPainter.width / 2, labelPainter.height / 2),
      );

      // Modern distance tag
      if (node.isAlive && node.distance != double.infinity) {
        final distPainter = TextPainter(
          text: TextSpan(
            text: "${node.distance.toInt()}ms",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final tagRect = Rect.fromLTWH(
          node.position.dx + 18,
          node.position.dy - 30,
          distPainter.width + 12,
          18,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(tagRect, const Radius.circular(6)),
          Paint()..color = nodeColor,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(tagRect, const Radius.circular(6)),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );

        distPainter.paint(
          canvas,
          Offset(
            tagRect.center.dx - distPainter.width / 2,
            tagRect.center.dy - distPainter.height / 2,
          ),
        );
      } else if (!node.isAlive) {
        // Modern offline badge
        final offlineCenter = node.position + const Offset(18, -18);

        canvas.drawCircle(offlineCenter, 10, Paint()..color = Colors.red);

        canvas.drawCircle(
          offlineCenter,
          10,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );

        final xPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          offlineCenter + const Offset(-4, -4),
          offlineCenter + const Offset(4, 4),
          xPaint,
        );
        canvas.drawLine(
          offlineCenter + const Offset(4, -4),
          offlineCenter + const Offset(-4, 4),
          xPaint,
        );
      }
    }
  }

  void _drawModernArrow(Canvas canvas, Offset start, Offset end, Color color) {
    final direction = end - start;
    final length = direction.distance;
    final unitDirection = direction / length;

    final arrowPos = start + unitDirection * (length * 0.7);
    final perpendicular = Offset(-unitDirection.dy, unitDirection.dx);
    final arrowSize = 10.0;

    final arrowPath = Path()
      ..moveTo(arrowPos.dx, arrowPos.dy)
      ..lineTo(
        arrowPos.dx -
            unitDirection.dx * arrowSize +
            perpendicular.dx * arrowSize / 2,
        arrowPos.dy -
            unitDirection.dy * arrowSize +
            perpendicular.dy * arrowSize / 2,
      )
      ..lineTo(
        arrowPos.dx -
            unitDirection.dx * arrowSize -
            perpendicular.dx * arrowSize / 2,
        arrowPos.dy -
            unitDirection.dy * arrowSize -
            perpendicular.dy * arrowSize / 2,
      )
      ..close();

    // Arrow shadow
    canvas.drawPath(
      arrowPath.shift(const Offset(1, 1)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Arrow body
    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashWidth = 10.0;
    const double dashSpace = 6.0;
    double distance = (p2 - p1).distance;
    double dx = (p2.dx - p1.dx) / distance;
    double dy = (p2.dy - p1.dy) / distance;
    double x = p1.dx;
    double y = p1.dy;
    double currentDistance = 0;

    while (currentDistance < distance) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x + dx * dashWidth, y + dy * dashWidth),
        paint,
      );
      x += dx * (dashWidth + dashSpace);
      y += dy * (dashWidth + dashSpace);
      currentDistance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) => true;
}
