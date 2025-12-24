import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/utils/time_utils.dart';
import '../../../learning/presentation/provider/learning_provider.dart';

class LastLearnedCard extends StatefulWidget {
  final bool isDark;
  const LastLearnedCard({super.key, required this.isDark});

  @override
  State<LastLearnedCard> createState() => _LastLearnedCardState();
}

class _LastLearnedCardState extends State<LastLearnedCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Refresh every second to keep the "time ago" real-time and granular
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LearningProvider>(
      builder: (context, learningProvider, _) {
        final lastLearned = learningProvider.lastLearnedModule;

        // If no module has been learned yet, show premium placeholder
        if (lastLearned == null) {
          return _buildPlaceholder(context);
        }

        final Color moduleColor = lastLearned['color'] as Color;
        final IconData moduleIcon = lastLearned['icon'] as IconData;
        final double progress = lastLearned['progress'] as double;
        final String moduleId = lastLearned['id'] as String? ?? '';
        final String titleKey = lastLearned['titleKey'] as String;

        return GestureDetector(
          onTap: () {
            if (moduleId.isNotEmpty) {
              final title = AppLocalizations.of(context).translate(titleKey);
              context.push(
                '/learn/$moduleId?title=${Uri.encodeComponent(title)}',
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: widget.isDark
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    )
                  : Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 1,
                    ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.isDark
                    ? [
                        const Color(0xFF1E293B),
                        const Color(0xFF0F172A),
                        moduleColor.withValues(alpha: 0.2),
                      ]
                    : [
                        Colors.white,
                        Colors.white,
                        moduleColor.withValues(alpha: 0.15),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, color: moduleColor, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate('last_learned_title'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _getTimeAgo(lastLearned['timestamp'] as int, context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Container(
                      width: 46.w,
                      height: 46.w,
                      decoration: BoxDecoration(
                        color: moduleColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(moduleIcon, color: Colors.white),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate(titleKey),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: widget.isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            AppLocalizations.of(context).translate(
                              lastLearned['descriptionKey'] as String,
                            ),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: widget.isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6.h,
                              backgroundColor: Colors.grey.withValues(
                                alpha: 0.2,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                moduleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: moduleColor.withValues(alpha: 0.15),
                      ),
                      child: Icon(Icons.play_arrow_rounded, color: moduleColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isDark
              ? [
                  const Color(0xFF1E3A8A).withValues(alpha: 0.3),
                  const Color(0xFF7C3AED).withValues(alpha: 0.2),
                ]
              : [
                  const Color(0xFF60A5FA).withValues(alpha: 0.15),
                  const Color(0xFFA78BFA).withValues(alpha: 0.15),
                ],
        ),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  Colors.purple.withValues(alpha: 0.2),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.rocket_launch_rounded,
              size: 40.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            AppLocalizations.of(context).translate('no_learning_yet'),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: widget.isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context).translate('no_learning_subtitle'),
            style: TextStyle(
              fontSize: 13.sp,
              color: widget.isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            height: 44.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF06B6D4)],
              ),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14.r),
                onTap: () {
                  final title = AppLocalizations.of(
                    context,
                  ).translate('bubble_sort_title');
                  context.push(
                    '/learn/sort1?title=${Uri.encodeComponent(title)}',
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate('start_learning_now'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(int timestamp, BuildContext context) {
    final loc = AppLocalizations.of(context);
    return TimeUtils.timeAgo(
      timestamp,
      justNow: loc.translate('time_just_now'),
      secondsAgo: loc.translate('time_seconds_ago'),
      minsAgo: loc.translate('time_minutes_ago'),
      hoursAgo: loc.translate('time_hours_ago'),
      daysAgo: loc.translate('time_days_ago'),
    );
  }
}
