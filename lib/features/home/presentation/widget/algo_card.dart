import 'package:algo_lab/core/constants/app_colors.dart';
import 'package:algo_lab/core/constants/app_constants.dart';
import 'package:algo_lab/core/constants/app_typography.dart';
import 'package:algo_lab/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TiltAlgoCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDark;
  final int index;

  const TiltAlgoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.index,
  });

  @override
  State<TiltAlgoCard> createState() => _TiltAlgoCardState();
}

class _TiltAlgoCardState extends State<TiltAlgoCard> {
  double tiltX = 0;
  double tiltY = 0;

  void resetTilt() {
    setState(() {
      tiltX = 0;
      tiltY = 0;
    });
  }

  void onTap() {
    // Navigate ke halaman detail sesuai index
    GoRouter.of(context).push('/algorithm/${widget.index}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Listener(
        onPointerMove: (event) {
          final size = context.size!;
          final dx = (event.localPosition.dx - size.width / 2) / size.width;
          final dy = (event.localPosition.dy - size.height / 2) / size.height;

          setState(() {
            tiltX = dy * 0.35;
            tiltY = -dx * 0.35;
          });
        },
        onPointerUp: (_) => resetTilt(),
        onPointerCancel: (_) => resetTilt(),
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(tiltX)
            ..rotateY(tiltY),
          child: GlassAlgoCard(
            title: widget.title,
            subtitle: widget.subtitle,
            icon: widget.icon,
            color: widget.color,
            isDark: widget.isDark,
          ),
        ),
      ),
    );
  }
}

class GlassAlgoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDark;

  const GlassAlgoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassTheme>()!;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: glass.color,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: glass.border),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 25.r,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, size: 24.sp, color: color),
            ),
            SizedBox(height: 14.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.h2.copyWith(
                color: isDarkTheme
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body.copyWith(
                  color: isDarkTheme
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 11.sp,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
