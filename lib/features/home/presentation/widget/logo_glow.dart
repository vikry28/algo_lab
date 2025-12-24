import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_image.dart';
import '../../../../core/utils/image_paths.dart';

class LogoGlow extends StatelessWidget {
  final bool isDark;

  const LogoGlow({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.25),
                blurRadius: 60,
                spreadRadius: 20,
              ),
              BoxShadow(
                color: AppColors.chipPurple.withValues(
                  alpha: isDark ? 0.15 : 0.10,
                ),
                blurRadius: 90,
                spreadRadius: 40,
              ),
            ],
          ),
        ),

        // Logo Wrapper
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.2,
            ),
          ),
          child: Center(
            child: AppImage(src: ImagePaths.logo, width: 85, height: 85),
          ),
        ),
      ],
    );
  }
}
