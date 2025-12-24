import 'package:algo_lab/core/constants/app_colors.dart';
import 'package:algo_lab/core/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LearningChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final Color? color;

  const LearningChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor =
        color ??
        (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: chipColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: chipColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: chipColor),
          ),
        ],
      ),
    );
  }
}
