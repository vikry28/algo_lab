import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/theme/theme_extension.dart';

class AchievementCard extends StatelessWidget {
  final Color textPrimary;
  final Color textSecondary;

  const AchievementCard({
    super.key,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassTheme>()!;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: glass.border, width: glass.borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => context.push('/achievements'),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.amber,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        ).translate('profile_achievements'),
                        style: AppTypography.titleMedium.copyWith(
                          color: textPrimary,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        AppLocalizations.of(
                          context,
                        ).translate('profile_achievements_subtitle'),
                        style: AppTypography.bodySmall.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: textSecondary.withValues(alpha: 0.3),
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
