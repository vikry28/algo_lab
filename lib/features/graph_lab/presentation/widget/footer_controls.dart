import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_localizations.dart';
import '../provider/graph_provider.dart';

class FooterControls extends StatelessWidget {
  final GraphProvider prov;

  const FooterControls({super.key, required this.prov});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ControlActionButton(
              label: prov.isRunning
                  ? t.translate('graph_status_running')
                  : t.translate('graph_btn_start'),
              icon: prov.isRunning
                  ? Icons.hourglass_top_rounded
                  : Icons.play_arrow_rounded,
              color: Colors.cyanAccent,
              onTap: prov.isRunning ? null : () => prov.runSimulation(),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: ControlActionButton(
              label: t.translate('graph_btn_reset'),
              icon: Icons.refresh_rounded,
              color: Colors.orangeAccent,
              onTap: () => prov.reset(),
            ),
          ),
        ],
      ),
    );
  }
}

class ControlActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ControlActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
