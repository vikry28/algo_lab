import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../learning/presentation/provider/learning_provider.dart';

class ProgressSection extends StatelessWidget {
  final bool isDark;
  final Color textSecondary;

  const ProgressSection({
    super.key,
    required this.isDark,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Ringkasan progress header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(
                  context,
                ).translate('profile_progress_summary'),
                style: AppTypography.bodySmall.copyWith(
                  color: textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  fontSize: 11.sp,
                ),
              ),
              Text(
                AppLocalizations.of(context).translate('profile_detail'),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        /// Progress cards WITH REAL DATA
        Consumer<LearningProvider>(
          builder: (context, learningProvider, _) {
            final streak = learningProvider.streak;
            final totalXP = learningProvider.totalXP;
            // final totalModules =
            //     learningProvider.completedCount; // Number of completed modules

            String formatXP(int xp) {
              if (xp >= 1000) {
                return '${(xp / 1000).toStringAsFixed(1)}k';
              }
              return xp.toString();
            }

            return Row(
              children: [
                Expanded(
                  child: _smallProgressBox(
                    context: context,
                    isDark: isDark,
                    iconBg: AppColors.primary.withValues(alpha: 0.15),
                    emoji: '📚',
                    value:
                        '${learningProvider.completedCount}/${learningProvider.totalModulesCount}',
                    label: AppLocalizations.of(
                      context,
                    ).translate('profile_algorithms'),
                    iconcolor: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _smallProgressBox(
                    context: context,
                    isDark: isDark,
                    iconBg: Colors.purple.withValues(alpha: 0.15),
                    emoji: '✨',
                    value: formatXP(totalXP),
                    label: AppLocalizations.of(
                      context,
                    ).translate('profile_total_xp'),
                    iconcolor: Colors.purpleAccent,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _smallProgressBox(
                    context: context,
                    isDark: isDark,
                    iconBg: Colors.orange.withValues(alpha: 0.15),
                    emoji: '🔥',
                    value: '$streak',
                    label: AppLocalizations.of(
                      context,
                    ).translate('profile_streak'),
                    iconcolor: Colors.orangeAccent,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _smallProgressBox({
    required BuildContext context,
    required bool isDark,
    required Color iconBg,
    required Color iconcolor,
    String? emoji,
    IconData? icon,
    required String value,
    required String label,
  }) {
    final glass = Theme.of(context).extension<GlassTheme>()!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: glass.border, width: glass.borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: emoji != null
                ? Text(emoji, style: TextStyle(fontSize: 18.sp))
                : Icon(icon, color: iconcolor, size: 20.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: AppTypography.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
