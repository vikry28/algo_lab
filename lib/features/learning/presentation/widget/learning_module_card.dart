import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/learning_entity.dart';

class LearningModuleCard extends StatelessWidget {
  final LearningEntity item;
  final double progress;
  final VoidCallback onTap;
  final Color iconColor;
  final IconData icon;
  final bool isLocked;

  const LearningModuleCard({
    super.key,
    required this.item,
    required this.progress,
    required this.onTap,
    required this.iconColor,
    required this.icon,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if complete
    final bool isComplete = progress >= 1.0;

    // Theme helpers
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(24),
        child: Opacity(
          opacity: isLocked ? 0.6 : 1.0,
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF15151D) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isLocked ? 0.05 : 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Container
                    _buildIconContainer(isLocked),
                    SizedBox(width: 16.w),
                    // Title & Desc
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  ).translate(item.title),
                                  style: AppTypography.titleMedium.copyWith(
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                              if (isLocked)
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: Icon(
                                    Icons.lock_rounded,
                                    color: isDark
                                        ? Colors.white24
                                        : Colors.black26,
                                    size: 20.sp,
                                  ),
                                )
                              else
                                Container(
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.05)
                                        : Colors.black.withValues(alpha: 0.05),
                                  ),
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black54,
                                    size: 20.sp,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            AppLocalizations.of(
                              context,
                            ).translate(item.description),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? Colors.white38 : Colors.black38,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Footer: Progress
                isComplete
                    ? _buildCompletedBadge(context)
                    : _buildProgressBar(context, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(bool isLocked) {
    // If locked, desaturate or darken color
    final color = isLocked ? Colors.grey : iconColor;

    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF1E1E28),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.2), Colors.transparent],
        ),
      ),
      child: Center(
        child: Icon(icon, color: color, size: 28.sp),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, bool isDark) {
    if (isLocked) {
      return Row(
        children: [
          Icon(
            Icons.lock_outline,
            size: 14.sp,
            color: isDark ? Colors.white24 : Colors.black26,
          ),
          SizedBox(width: 6.w),
          Text(
            AppLocalizations.of(context).translate('module_locked'),
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        // Progress Bar
        Expanded(
          child: Container(
            height: 6.h,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          "${(progress * 100).toInt()}%",
          style: AppTypography.labelSmall.copyWith(
            color: iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: const Color(0xFF10B981),
            size: 16.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            AppLocalizations.of(context).translate('module_completed'),
            style: AppTypography.labelSmall.copyWith(
              color: const Color(0xFF10B981),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
