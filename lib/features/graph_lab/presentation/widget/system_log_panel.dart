import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/theme/theme_extension.dart';
import '../provider/graph_provider.dart';

class SystemLogPanel extends StatelessWidget {
  final GraphProvider prov;
  final GlassTheme glass;

  const SystemLogPanel({super.key, required this.prov, required this.glass});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    String desc =
        prov.currentStepIndex >= 0 && prov.currentStepIndex < prov.steps.length
        ? prov.steps[prov.currentStepIndex].description
        : t.translate('graph_sys_msg_ready');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: glass.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.cyanAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, color: Colors.cyanAccent, size: 14),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    desc,
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const Icon(Icons.speed, color: Colors.grey, size: 12),
              Expanded(
                child: Slider(
                  value: prov.animationSpeed,
                  min: 0.5,
                  max: 4.0,
                  activeColor: Colors.cyanAccent,
                  onChanged: (v) => prov.setSpeed(v),
                ),
              ),
              Text(
                "${prov.animationSpeed.toStringAsFixed(1)}X",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
