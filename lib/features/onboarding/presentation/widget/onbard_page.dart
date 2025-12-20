import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widget/pulse_dot.dart';
import '../provider/onboarding_provider.dart';

class BubblePainter extends CustomPainter {
  final Color color;
  BubblePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    const radius = 8.0;

    // Draw Rounded Rect
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height - 4),
        const Radius.circular(radius),
      ),
    );

    // Draw Triangle / Tail
    path.moveTo(size.width * 0.7, size.height - 4);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width * 0.8, size.height - 4);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class OnboardPage extends StatefulWidget {
  final bool isActive;
  final int index;
  final String titleTop;
  final String title;
  final String? title2;
  final String body;
  final Widget child;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback? onSkip;
  final VoidCallback? onLogin;
  final VoidCallback? onQuickLogin;

  const OnboardPage({
    super.key,
    required this.isActive,
    required this.index,
    required this.titleTop,
    required this.title,
    this.title2,
    required this.body,
    required this.child,
    required this.onNext,
    required this.onBack,
    this.onSkip,
    this.onLogin,
    this.onQuickLogin,
  });

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _badgeController;

  @override
  void initState() {
    super.initState();
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _badgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access widget properties using widget.property
    final isActive = widget.isActive;
    final index = widget.index;
    final titleTop = widget.titleTop;
    final title = widget.title;
    final title2 = widget.title2;
    final body = widget.body;
    final child = widget.child;
    final onNext = widget.onNext;
    final onBack = widget.onBack;
    final onSkip = widget.onSkip;
    final onLogin = widget.onLogin;
    final onQuickLogin = widget.onQuickLogin;

    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDark;
    final glass = Theme.of(context).extension<GlassTheme>()!;

    final borderColor = isActive ? AppColors.primary : AppColors.transparent;
    final bgColors = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    Color dotColor;
    Color textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    switch (index) {
      case 0:
        dotColor = AppColors.gradientBlueStart;
        break;
      case 1:
        dotColor = AppColors.gradientPurpleEnd;
        break;
      case 2:
        dotColor = AppColors.primaryGreen;
        textColor = AppColors.primaryGreen;
        break;
      default:
        dotColor = AppColors.primary;
    }

    Widget buildProgressBar() {
      return Container(
        height: 8.h,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withAlpha((0.04 * 255).round())
              : Colors.black.withAlpha((0.06 * 255).round()),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: (index + 1) / 3,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.gradientBlueStart,
                  AppColors.gradientPurpleEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: bgColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: index == 0
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withAlpha((0.06 * 255).round())
                            : Colors.black.withAlpha((0.06 * 255).round()),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: borderColor, width: 1.3),
                      ),
                      child: Row(
                        children: [
                          PulseDot(color: dotColor, size: 8),
                          SizedBox(width: 8.w),
                          Text(
                            titleTop,
                            style: AppTypography.labelSmall.copyWith(
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 28.h),

                Text(
                  title,
                  style: AppTypography.h1.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),

                if (index > 0 && title2 != null) ...[
                  SizedBox(height: 10.h),
                  Text(
                    title2,
                    style: AppTypography.body.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],

                SizedBox(height: 30.h),

                SizedBox(
                  height: 0.40.sh,
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.85,
                      child: child,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    fontSize: 13.sp,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),

                const Spacer(),

                if (index < 2)
                  Row(
                    children: [
                      Expanded(child: buildProgressBar()),

                      SizedBox(width: 12.w),

                      GestureDetector(
                        onTap: onNext,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.gradientBlueStart,
                                AppColors.gradientPurpleEnd,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.play_circle_fill,
                                size: 18.w,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                AppLocalizations.of(
                                  context,
                                ).translate("common_next"),
                                style: AppTypography.body.copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Consumer<OnboardingProvider>(
                    builder: (context, provider, _) {
                      final bool isGoogleLoading = provider.isGoogleLoading;
                      final bool isQuickLoading = provider.isQuickLoading;
                      final bool anyLoading = provider.isLoggingIn;

                      return Column(
                        children: [
                          SizedBox(height: 14.h),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: anyLoading ? null : onLogin,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12.h,
                                    horizontal: 12.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen.withAlpha(
                                      anyLoading ? (0.5 * 255).round() : 255,
                                    ),
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isGoogleLoading)
                                        SizedBox(
                                          width: 18.w,
                                          height: 18.w,
                                          child:
                                              const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                        )
                                      else ...[
                                        CachedNetworkImage(
                                          imageUrl:
                                              "https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png",
                                          width: 18.w,
                                          height: 18.w,
                                          placeholder: (context, url) => SizedBox(
                                            width: 18.w,
                                            height: 18.w,
                                            child:
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                                AppIcons.google,
                                                color: Colors.white,
                                                size: 18.w,
                                              ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          ).translate("common_login_google"),
                                          style: AppTypography.body.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -16.h,
                                right: 28.w,
                                child: AnimatedBuilder(
                                  animation: _badgeController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                        0,
                                        -(_badgeController.value * 5.h),
                                      ),
                                      child: child,
                                    );
                                  },
                                  child: CustomPaint(
                                    painter: BubblePainter(
                                      color: AppColors.primaryGreen,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                        10.w,
                                        4.h,
                                        10.w,
                                        8.h,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).translate("common_recommended"),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap: anyLoading ? null : onQuickLogin,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 12.w,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withAlpha(
                                        anyLoading
                                            ? (0.02 * 255).round()
                                            : (0.05 * 255).round(),
                                      )
                                    : Colors.black.withAlpha(
                                        anyLoading
                                            ? (0.02 * 255).round()
                                            : (0.05 * 255).round(),
                                      ),
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withAlpha(
                                          (0.4 * 255).round(),
                                        )
                                      : Colors.black.withAlpha(
                                          (0.4 * 255).round(),
                                        ),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isQuickLoading) ...[
                                    SizedBox(
                                      width: 18.w,
                                      height: 18.w,
                                      child: CircularProgressIndicator(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                  ] else ...[
                                    Icon(
                                      AppIcons.profile,
                                      size: 18.w,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                    ),
                                    SizedBox(width: 8.w),
                                  ],
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate("common_login"),
                                    style: AppTypography.body.copyWith(
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          buildProgressBar(),
                          SizedBox(height: 26.h),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),

        if (index < 2 && onSkip != null)
          Positioned(
            right: 20.w,
            top: 40.h,
            child: GestureDetector(
              onTap: onSkip,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withAlpha((0.10 * 255).round())
                      : Colors.black.withAlpha((0.10 * 255).round()),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  AppLocalizations.of(context).translate("common_skip"),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ),
          ),

        if (index > 0)
          Positioned(
            left: 20.w,
            top: 40.h,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withAlpha((0.10 * 255).round())
                      : Colors.black.withAlpha((0.10 * 255).round()),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  size: 16.w,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
