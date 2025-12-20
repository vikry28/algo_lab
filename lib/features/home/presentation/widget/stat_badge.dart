import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;

  const StatBadge({
    super.key,
    required this.label,
    required this.value,
    this.dotColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot + Label
          Row(
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          // Value
          Text(
            value,
            style: AppTypography.h2.copyWith(
              color: AppColors.textPrimaryDark,
              fontSize: 17.sp,
            ),
          ),
        ],
      ),
    );
  }
}
