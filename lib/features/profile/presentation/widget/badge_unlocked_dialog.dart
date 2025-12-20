import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/entities/badge_entity.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/theme_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BadgeUnlockedDialog extends StatefulWidget {
  final BadgeEntity badge;
  const BadgeUnlockedDialog({super.key, required this.badge});

  @override
  State<BadgeUnlockedDialog> createState() => _BadgeUnlockedDialogState();
}

class _BadgeUnlockedDialogState extends State<BadgeUnlockedDialog>
    with TickerProviderStateMixin {
  late final AnimationController _mainCtrl;
  late final AnimationController _glowCtrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _scale = CurvedAnimation(parent: _mainCtrl, curve: Curves.elasticOut);
    _opacity = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    );

    _mainCtrl.forward();
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n.translate(widget.badge.titleKey);
    final desc = l10n.translate(widget.badge.descriptionKey);
    final glass = Theme.of(context).extension<GlassTheme>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = Color(widget.badge.color);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: ScaleTransition(
          scale: _scale,
          child: FadeTransition(
            opacity: _opacity,
            child: Container(
              width: 320.w,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: glass.color,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: badgeColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: badgeColor.withValues(alpha: 0.2),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: Stack(
                  children: [
                    // 1. Background Glow Particles (Simple circles)
                    Positioned(
                      top: -50,
                      right: -50,
                      child: _CircleGlow(color: badgeColor, size: 150),
                    ),

                    // 2. Main Content
                    Padding(
                      padding: EdgeInsets.all(30.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Badge Avatar with Rotating Highlight
                          _buildBadgeIcon(badgeColor),

                          SizedBox(height: 24.h),

                          // Congratulation Text
                          Text(
                            l10n.translate('badge_unlocked_title'),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          // Badge Title
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: AppTypography.h2.copyWith(
                              fontSize: 24.sp,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Badge Description
                          Text(
                            desc,
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 14.sp,
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // Action Button
                          _buildActionButton(badgeColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(Color badgeColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Rotating Glow
        RotationTransition(
          turns: _glowCtrl,
          child: RepaintBoundary(
            child: Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    badgeColor.withValues(alpha: 0.0),
                    badgeColor.withValues(alpha: 0.5),
                    badgeColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Main Badge Container
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: badgeColor.withValues(alpha: 0.1),
            border: Border.all(
              color: badgeColor.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: badgeColor.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(widget.badge.icon, style: TextStyle(fontSize: 48.sp)),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(Color badgeColor) {
    return Container(
      width: double.infinity,
      height: 54.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          colors: [badgeColor, badgeColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Text(
              AppLocalizations.of(context).translate('collect_now'),
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleGlow extends StatelessWidget {
  final Color color;
  final double size;
  const _CircleGlow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}
