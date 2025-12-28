import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_extension.dart';

class ZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final GlassTheme glass;

  const ZoomControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.glass,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _zoomButton(icon: Icons.add_rounded, onTap: onZoomIn, glass: glass),
        SizedBox(height: 8.h),
        _zoomButton(icon: Icons.remove_rounded, onTap: onZoomOut, glass: glass),
      ],
    );
  }

  Widget _zoomButton({
    required IconData icon,
    required VoidCallback onTap,
    required GlassTheme glass,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: glass.color,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: glass.border),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Icon(icon, color: Colors.cyanAccent),
      ),
    );
  }
}
