import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  late final AnimationController _particleCtrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _scale = CurvedAnimation(parent: _mainCtrl, curve: Curves.elasticOut);
    _opacity = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    );

    _particles = List.generate(30, (index) => _ConfettiParticle());

    _mainCtrl.forward();
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    _glowCtrl.dispose();
    _particleCtrl.dispose();
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
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Confetti Particles
              AnimatedBuilder(
                animation: _particleCtrl,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ConfettiPainter(
                      particles: _particles,
                      progress: _particleCtrl.value,
                      color: badgeColor,
                    ),
                    size: Size(1.sw, 1.sh),
                  );
                },
              ),

              ScaleTransition(
                scale: _scale,
                child: FadeTransition(
                  opacity: _opacity,
                  child: Container(
                    width: 320.w,
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    decoration: BoxDecoration(
                      color: glass.color.withValues(alpha: isDark ? 0.8 : 0.9),
                      borderRadius: BorderRadius.circular(32.r),
                      border: Border.all(
                        color: badgeColor.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: badgeColor.withValues(alpha: 0.25),
                          blurRadius: 40,
                          spreadRadius: 5,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.r),
                      child: Stack(
                        children: [
                          // Decorative Background Shapes
                          Positioned(
                            top: -60,
                            right: -60,
                            child: _CircleGlow(color: badgeColor, size: 180),
                          ),
                          Positioned(
                            bottom: -40,
                            left: -40,
                            child: _CircleGlow(
                              color: badgeColor.withValues(alpha: 0.1),
                              size: 120,
                            ),
                          ),

                          // Main Content
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              24.w,
                              40.w,
                              24.w,
                              32.w,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildBadgeIcon(badgeColor),

                                SizedBox(height: 32.h),

                                // Header Text
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      badgeColor,
                                      badgeColor.withValues(alpha: 0.6),
                                    ],
                                  ).createShader(bounds),
                                  child: Text(
                                    l10n.translate('badge_unlocked_title'),
                                    style: AppTypography.labelSmall.copyWith(
                                      color: Colors.white,
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 12.h),

                                // Badge Title
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.h2.copyWith(
                                    fontSize: 26.sp,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),

                                SizedBox(height: 12.h),

                                // Badge Description
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: Text(
                                    desc,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.body.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                      fontSize: 14.sp,
                                      height: 1.5,
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(Color badgeColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing outer ring
        AnimatedBuilder(
          animation: _glowCtrl,
          builder: (context, child) {
            return Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: badgeColor.withValues(
                    alpha: 0.2 * (1 - _glowCtrl.value),
                  ),
                  width: 2 + (20 * _glowCtrl.value),
                ),
              ),
            );
          },
        ),

        // Rotating colorful glow
        RotationTransition(
          turns: _glowCtrl,
          child: Container(
            width: 130.w,
            height: 130.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  badgeColor.withValues(alpha: 0.0),
                  badgeColor.withValues(alpha: 0.6),
                  badgeColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),

        // Inner Badge Container
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                badgeColor.withValues(alpha: 0.3),
                badgeColor.withValues(alpha: 0.1),
              ],
            ),
            border: Border.all(
              color: badgeColor.withValues(alpha: 0.6),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: badgeColor.withValues(alpha: 0.4),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.badge.icon,
              style: TextStyle(
                fontSize: 52.sp,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(Color badgeColor) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [badgeColor, badgeColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => context.pop(),
          child: Center(
            child: Text(
              AppLocalizations.of(context).translate('collect_now'),
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
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
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}

class _ConfettiParticle {
  late double x;
  late double y;
  late double velocity;
  late double angle;
  late double size;
  late double rotation;
  late Color subColor;

  _ConfettiParticle() {
    _reset();
  }

  void _reset() {
    final rand = math.Random();
    x = 0; // Center X
    y = 0; // Center Y
    angle = rand.nextDouble() * 2 * math.pi;
    velocity = 5 + rand.nextDouble() * 10;
    size = 4 + rand.nextDouble() * 6;
    rotation = rand.nextDouble() * 2 * math.pi;
    // Vary color slightly
    subColor = Colors.white.withValues(alpha: 0.5 + rand.nextDouble() * 0.5);
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;
  final Color color;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final distance = p.velocity * progress * 40;
      final dx = center.dx + math.cos(p.angle) * distance;
      final dy = center.dy + math.sin(p.angle) * distance;

      // Add gravity effect
      final gravity = 200 * progress * progress;
      final finalY = dy + gravity;

      paint.color = progress > 0.8
          ? p.subColor.withValues(
              alpha: p.subColor.a * (1 - (progress - 0.8) / 0.2),
            )
          : p.subColor;

      canvas.save();
      canvas.translate(dx, finalY);
      canvas.rotate(p.rotation + progress * 5);

      // Draw small rectangles or circles
      if (p.size % 2 == 0) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
