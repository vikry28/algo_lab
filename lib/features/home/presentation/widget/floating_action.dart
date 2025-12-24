// Misal di file floating_action.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const FloatingActionIcon({
    super.key,
    required this.icon,
    this.color = Colors.white, // default putih
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Icon(icon, size: 20.w, color: color),
    );
  }
}
