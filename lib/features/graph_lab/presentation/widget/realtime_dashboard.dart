import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/theme/theme_extension.dart';
import '../provider/graph_provider.dart';

class RealtimeDashboard extends StatelessWidget {
  final GraphProvider prov;
  final GlassTheme glass;
  final bool isDark;

  const RealtimeDashboard({
    super.key,
    required this.prov,
    required this.glass,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    int activeNodes = prov.nodes.where((n) => n.isAlive).length;
    int totalNodes = prov.nodes.length;
    int activeEdges = prov.edges.where((e) => e.isAlive).length;
    int totalEdges = prov.edges.length;

    double avgTraffic =
        prov.edges
            .where((e) => e.isAlive)
            .map((e) => e.trafficLoad)
            .fold(0.0, (a, b) => a + b) /
        (prov.edges.where((e) => e.isAlive).isNotEmpty
            ? prov.edges.where((e) => e.isAlive).length
            : 1);

    int packetCount = prov.backgroundPackets.length;

    double nodeHealth = activeNodes / totalNodes;
    double linkHealth = activeEdges / totalEdges;
    double overallHealth = (nodeHealth + linkHealth) / 2;

    String healthStatus;
    Color healthColor;
    if (overallHealth >= 0.9) {
      healthStatus = t.translate('graph_health_excellent');
      healthColor = Colors.greenAccent;
    } else if (overallHealth >= 0.7) {
      healthStatus = t.translate('graph_health_good');
      healthColor = Colors.lightGreenAccent;
    } else if (overallHealth >= 0.5) {
      healthStatus = t.translate('graph_health_degraded');
      healthColor = Colors.orangeAccent;
    } else {
      healthStatus = t.translate('graph_health_critical');
      healthColor = Colors.redAccent;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: glass.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Ultra compact header
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: Colors.cyanAccent,
                size: 12.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                t.translate('graph_analytics_title').toUpperCase(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: Colors.cyanAccent.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              _liveIndicator(),
            ],
          ),
          SizedBox(height: 6.h),

          // Tighter Metrics Grid - 4 items in top row to save space?
          // No, keep 3 and 2 for readability, just make cards smaller.
          Row(
            children: [
              _statItem(
                t.translate('graph_label_nodes'),
                "$activeNodes/$totalNodes",
                Colors.blueAccent,
              ),
              SizedBox(width: 6.w),
              _statItem(
                t.translate('graph_label_links'),
                "$activeEdges/$totalEdges",
                Colors.purpleAccent,
              ),
              SizedBox(width: 6.w),
              _statItem(
                t.translate('graph_label_traffic'),
                "${(avgTraffic * 100).toInt()}%",
                avgTraffic > 0.7 ? Colors.orangeAccent : Colors.greenAccent,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              _statItem(
                t.translate('graph_label_packets'),
                "$packetCount",
                Colors.amberAccent,
              ),
              SizedBox(width: 6.w),
              Expanded(
                flex: 2,
                child: _healthItem(healthStatus, healthColor, overallHealth),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _liveIndicator() {
    return Row(
      children: [
        Container(
          width: 5.w,
          height: 5.w,
          decoration: const BoxDecoration(
            color: Colors.greenAccent,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "LIVE",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                color: color,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _healthItem(String status, Color color, double progress) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HEALTH",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 40.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.r),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 3.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
