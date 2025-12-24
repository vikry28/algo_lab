import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../learning/presentation/provider/learning_provider.dart';

class SummarySection extends StatelessWidget {
  final bool isDark;
  const SummarySection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// TITLE HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).translate('summary_title'),
              style: AppTypography.h2.copyWith(
                fontSize: 18.sp,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Text(
                AppLocalizations.of(context).translate('summary_this_week'),
                style: AppTypography.body.copyWith(
                  fontSize: 12.sp,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        /// GRID CARD RESPONSIF WITH REAL DATA
        Consumer<LearningProvider>(
          builder: (context, learningProvider, _) {
            final streak = learningProvider.streak;
            final todayXP = learningProvider.todayXP;
            // final completedCount = learningProvider.completedCount;
            // final progressPercentage =
            //     learningProvider.overallProgressPercentage;

            return Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    context: context,
                    title: AppLocalizations.of(
                      context,
                    ).translate('summary_completed'),
                    value:
                        "${learningProvider.completedCount}/${learningProvider.totalModulesCount}",
                    subtitle:
                        "${(learningProvider.overallProgressPercentage * 100).toStringAsFixed(0)}% ${AppLocalizations.of(context).translate('summary_total_progress')}",
                    emoji: "📚",
                    iconColor: Colors.blueAccent,
                    isDark: isDark,
                    progress: learningProvider.overallProgressPercentage,
                    gradientColor: Colors.blueAccent,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _summaryCard(
                    context: context,
                    title: AppLocalizations.of(
                      context,
                    ).translate('summary_streak'),
                    value: "$streak",
                    subtitle:
                        "$todayXP ${AppLocalizations.of(context).translate('summary_xp_today')}",
                    emoji: "🔥",
                    iconColor: Colors.orange,
                    isDark: isDark,
                    showGrowthIcon: true,
                    gradientColor: Colors.orange,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _summaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required String emoji,
    required Color iconColor,
    required bool isDark,
    required Color gradientColor,
    double? progress,
    bool showGrowthIcon = false,
  }) {
    final textSecondary = (isDark ? Colors.white : Colors.black).withValues(
      alpha: isDark ? 0.6 : 0.45,
    );

    return Container(
      height: 160.h,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: isDark
            ? Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1)
            : Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Color(0xFF1E293B), gradientColor.withValues(alpha: 0.15)]
              : [Colors.white, gradientColor.withValues(alpha: 0.15)],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE + EMOJI POJOK KANAN
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(emoji, style: TextStyle(fontSize: 18.sp)),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// VALUE
          Text(
            value,
            style: TextStyle(
              fontSize: 26.sp,
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// PROGRESS BAR JIKA ADA
          if (progress != null) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6.h,
                backgroundColor: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.10),
                valueColor: AlwaysStoppedAnimation(iconColor),
              ),
            ),
          ],

          SizedBox(height: 8.h),

          /// SUBTITLE (ADA ICON TAMBAHAN UNTUK XP)
          showGrowthIcon
              ? Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: Colors.green,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.sp, color: textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }
}
