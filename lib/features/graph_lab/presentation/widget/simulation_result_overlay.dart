import 'package:flutter/material.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../home/presentation/widget/modern_confirm_dialog.dart';
import '../../domain/entities/graph_node.dart';
import '../provider/graph_provider.dart';

class SimulationResultOverlay extends StatelessWidget {
  final GraphProvider prov;

  const SimulationResultOverlay({super.key, required this.prov});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    // Get final node to calculate total distance
    final targetNode = prov.nodes.firstWhere((n) => n.id == prov.targetNodeId);
    final isReachable = targetNode.distance != double.infinity;

    if (!isReachable) {
      return ModernConfirmDialog(
        title: t.translate('lab_simulation_done'),
        message: t.translate('lab_graph_no_path'),
        icon: Icons.error_outline,
        confirmLabel: t.translate('common_reset'),
        closeOnConfirm: false,
        onConfirm: () => prov.reset(),
        cancelLabel: t.translate('common_cancel'),
        closeOnCancel: false,
      );
    }

    final totalLatency = targetNode.distance.toInt();

    // Build detailed path
    List<String> pathLabels = [];
    GraphNode? curr = targetNode;
    int hops = 0;

    // Trace back from target to start
    while (curr != null && curr.id != prov.startNodeId && hops < 20) {
      final label = curr.labelKey != null
          ? t.translate(curr.labelKey!)
          : curr.label;
      pathLabels.insert(0, label);
      hops++;
      if (curr.parent != null) {
        try {
          // Find the parent node instance in current provider state to keep tracing
          curr = prov.nodes.firstWhere((n) => n.id == curr!.parent!.id);
        } catch (_) {
          curr = null;
        }
      } else {
        curr = null;
      }
    }

    // Add start node
    try {
      final startNode = prov.nodes.firstWhere((n) => n.id == prov.startNodeId);
      final label = startNode.labelKey != null
          ? t.translate(startNode.labelKey!)
          : startNode.label;
      pathLabels.insert(0, label);
    } catch (_) {}

    // Analyze route
    bool hasBandung = pathLabels.any(
      (l) => l.toUpperCase().contains("BANDUNG"),
    );
    bool hasSurabaya = pathLabels.any(
      (l) => l.toUpperCase().contains("SURABAYA"),
    );

    String routeType;
    if (hasBandung) {
      routeType = t.translate('graph_result_path_optimal');
    } else if (hasSurabaya) {
      routeType = t.translate('graph_result_path_backup');
    } else {
      routeType = t.translate('graph_result_path_alternative');
    }

    String routeDetail = pathLabels.join(' → ');

    return ModernConfirmDialog(
      title: t.translate('graph_simulation_complete'),
      message:
          "${t.translate('graph_result_replication_success')}\n\n${t.translate('graph_result_latency_label', arguments: {'latency': totalLatency.toString()})}\n${t.translate('graph_result_path_label')} $routeType\n\n${t.translate('graph_result_detail_label')}\n$routeDetail",
      icon: Icons.check_circle_outline,
      confirmLabel: t.translate('common_ok'),
      closeOnConfirm: false,
      onConfirm: () => prov.reset(),
      cancelLabel: t.translate('common_cancel'),
      closeOnCancel: false,
    );
  }
}
