import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widget/floating_action.dart';

class RocketCard extends StatefulWidget {
  const RocketCard({super.key});

  @override
  State<RocketCard> createState() => _RocketCardState();
}

class _RocketCardState extends State<RocketCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rocketAnimation;
  late final Animation<double> _floatingOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rocketAnimation = Tween<double>(begin: 0, end: -20.h).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _floatingOffset = Tween<double>(
      begin: 0,
      end: 6.h,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSmokeTrail() {
    return Positioned(
      bottom: 70.h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) {
          double scale = 0.5 + (_controller.value * 0.5);
          double opacity = 0.3 + (_controller.value * 0.2);
          return Transform.translate(
            offset: Offset(0, _rocketAnimation.value * -0.5),
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: 40.w * scale,
                height: 20.h * scale,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withValues(alpha: 0.8 * opacity),
                      Colors.yellow.withValues(alpha: 0.5 * opacity),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(children: [Expanded(child: Container())]),
              ),

              Transform.translate(
                offset: Offset(0, _rocketAnimation.value),
                child: Container(
                  width: 140.w,
                  height: 140.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.10)
                          : Colors.black.withValues(alpha: 0.10),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.rocket_launch_rounded,
                      size: 56.w,
                      color: AppColors.skyBlue,
                    ),
                  ),
                ),
              ),

              _buildSmokeTrail(),

              Positioned(
                right: 46.w,
                bottom: 90.h + _floatingOffset.value,
                child: FloatingActionIcon(
                  icon: Icons.code,
                  color: Colors.blueAccent,
                ),
              ),
              Positioned(
                left: 38.w,
                bottom: 110.h - _floatingOffset.value,
                child: FloatingActionIcon(
                  icon: Icons.emoji_events,
                  color: Colors.orangeAccent,
                ),
              ),
              Positioned(
                right: 28.w,
                bottom: 150.h + _floatingOffset.value / 2,
                child: FloatingActionIcon(
                  icon: Icons.auto_fix_high,
                  color: Colors.purpleAccent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
