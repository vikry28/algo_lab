import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widget/logo_glow.dart';
import '../provider/splash_provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _loadingController;
  late final AnimationController _exitController;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: 1.0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadingController.forward();
      context.read<SplashProvider>().initSplash();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _loadingController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  void _handleNavigation(SplashProvider provider) async {
    if (_isNavigating) return;

    if (provider.state == SplashState.home ||
        provider.state == SplashState.onboarding) {
      _isNavigating = true;

      if (_loadingController.isAnimating) {
        await _loadingController.forward().orCancel;
      }

      await Future.delayed(const Duration(milliseconds: 200));

      if (mounted) {
        await _exitController.reverse().orCancel;
      }

      if (mounted) {
        if (provider.state == SplashState.home) {
          context.go('/home');
        } else {
          context.go('/onboard');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, provider, child) {
        // Trigger navigation handler
        _handleNavigation(provider);

        final theme = context.watch<ThemeProvider>();
        final isDark = theme.isDark;
        final glass = Theme.of(context).extension<GlassTheme>()!;

        final textMain = isDark ? Colors.white : AppColors.textPrimaryLight;
        final textSecondary = (isDark ? Colors.white : Colors.black).withValues(
          alpha: isDark ? 0.6 : 0.45,
        );

        final loadingBg = (isDark ? Colors.white : Colors.black).withValues(
          alpha: 0.1,
        );

        return FadeTransition(
          opacity: _exitController,
          child: Scaffold(
            body: Stack(
              children: [
                // Gradient background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppColors.darkBackground[0],
                              AppColors.darkBackground[1],
                            ]
                          : [
                              AppColors.lightBackground[0],
                              AppColors.lightBackground[1],
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                // Light glass overlay
                Container(color: glass.color.withValues(alpha: 0.03)),

                // Logo + Title
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _pulseController,
                          curve: Curves.easeInOut,
                        ).drive(Tween(begin: 0.95, end: 1.05)),
                        child: LogoGlow(isDark: isDark),
                      ),
                      32.verticalSpace,
                      RichText(
                        text: TextSpan(
                          style: AppTypography.h1.copyWith(
                            fontSize: 28.sp,
                            color: textMain,
                          ),
                          children: [
                            const TextSpan(text: "Algo "),
                            WidgetSpan(
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [
                                        AppColors.gradientBlueStart,
                                        AppColors.gradientPurpleEnd,
                                      ],
                                    ).createShader(
                                      Rect.fromLTWH(
                                        0,
                                        0,
                                        bounds.width,
                                        bounds.height,
                                      ),
                                    ),
                                blendMode: BlendMode.srcIn,
                                child: Text(
                                  "Lab",
                                  style: AppTypography.h1.copyWith(
                                    fontSize: 28.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        "LEARN LOGIC",
                        style: AppTypography.bodySmall.copyWith(
                          color: textSecondary,
                          fontSize: 12.sp,
                          letterSpacing: 5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Loading bar
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50.h),
                    child: SizedBox(
                      width: 160.w,
                      height: 4.h,
                      child: AnimatedBuilder(
                        animation: _loadingController,
                        builder: (_, _) {
                          final progress = CurvedAnimation(
                            parent: _loadingController,
                            curve: Curves.easeOutCubic,
                          ).value;
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: loadingBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.gradientBlueStart,
                                        AppColors.gradientPurpleEnd,
                                        AppColors.gradientBlueStart,
                                      ],
                                      stops: [0.0, 0.5, 1.0],
                                      begin: Alignment(-1.0, 0),
                                      end: Alignment(1.0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
