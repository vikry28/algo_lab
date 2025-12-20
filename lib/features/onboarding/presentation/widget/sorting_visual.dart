import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widget/stat_badge.dart';

class SortingVisualizer extends StatefulWidget {
  const SortingVisualizer({super.key});

  @override
  State<SortingVisualizer> createState() => _SortingVisualizerState();
}

class _SortingVisualizerState extends State<SortingVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground[0] : AppColors.transparent,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark),
          SizedBox(height: 24.h),
          Expanded(child: _buildBars()),
          SizedBox(height: 24.h),
          _buildFooterStats(isDark),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withValues(
              alpha: 0.05,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.auto_graph, color: AppColors.primary, size: 20.sp),
        ),
        SizedBox(width: 12.w),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sorting Visualizer",
              style: AppTypography.titleMedium.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Processing…",
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),

        const Spacer(),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkBackground[1]
                : Colors.blue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.10)
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Text(
            "O(n²)",
            style: AppTypography.bodySmall.copyWith(
              color: Colors.greenAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // BARS
  // ---------------------------------------------------------------------------

  Widget _buildBars() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final t = _controller.value;
        final base = [0.55, 0.82, 0.67, 0.9, 0.75, 0.65, 0.50];

        final gradients = [
          [AppColors.gradientBlueStart, AppColors.gradientPurpleEnd],
          [AppColors.chipTeal, AppColors.chipPurple],
          [AppColors.chipPurple, AppColors.chipBlue],
          [AppColors.gradientBlueStart, AppColors.chipTeal],
          [AppColors.skyBlue, AppColors.chipPurple],
          [AppColors.chipBlue, AppColors.chipPurple],
          [AppColors.chipTeal, AppColors.chipPurple],
        ];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(base.length, (i) {
            final scale = base[i] * (0.6 + 0.4 * t);
            final colors = gradients[i % gradients.length];

            return Container(
              width: 26.w,
              height: (scale * 160).clamp(40.0, 160.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.last.withValues(alpha: 0.22),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // FOOTER STATS
  // ---------------------------------------------------------------------------

  Widget _buildFooterStats(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: StatBadge(
            label: 'SWAPS',
            value: '142',
            dotColor: Colors.orangeAccent,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatBadge(
            label: 'COMPARISONS',
            value: '456',
            dotColor: Colors.lightBlueAccent,
          ),
        ),
      ],
    );
  }
}
