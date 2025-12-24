import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:algo_lab/core/constants/app_typography.dart';
import 'package:algo_lab/core/constants/app_colors.dart';
import 'package:algo_lab/core/constants/app_icons.dart';
import 'package:algo_lab/core/constants/app_localizations.dart';
import 'package:algo_lab/core/theme/theme_extension.dart';

import '../../data/models/language_model.dart';
import 'language_switcher.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isDark;
  final VoidCallback? onToggle;
  final VoidCallback? onLanguageToggle;
  final List<Widget>? actions;
  final double height;
  final bool autoBack;

  const GlassAppBar({
    super.key,
    this.title,
    this.isDark = false,
    this.onToggle,
    this.onLanguageToggle,
    this.actions,
    this.height = 60,
    this.autoBack = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(height.h);

  @override
  Widget build(BuildContext context) {
    final glassTheme = Theme.of(context).extension<GlassTheme>();
    final glass =
        glassTheme ??
        GlassTheme(
          blur: 10,
          saturation: 1.0,
          color: Colors.black.withValues(alpha: 0.1),
          border: Colors.white.withValues(alpha: 0.1),
          borderWidth: 1.0,
        );
    final brightnessDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    final canPop = Navigator.of(context).canPop();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          height: height.h,
          decoration: BoxDecoration(
            color: glass.color.withAlpha((0.18 * 255).toInt()),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: glass.border.withAlpha((0.5 * 255).toInt()),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (autoBack && canPop)
                          Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: IconButton(
                              style: IconButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.all(8.w),
                              ),
                              icon: Icon(
                                AppIcons.back,
                                size: 22.sp,
                                color: brightnessDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                              onPressed: () => context.pop(),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            title ?? 'Algo Lab',
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.h2.copyWith(
                              color: brightnessDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onToggle != null)
                        GestureDetector(
                          onTap: onToggle,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 50.w,
                            height: 26.h,
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: brightnessDark
                                  ? AppColors.textPrimaryLight
                                  : AppColors.textPrimaryDark,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Align(
                              alignment: brightnessDark
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 20.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: brightnessDark
                                      ? AppColors.sunYellow
                                      : AppColors.skyBlue,
                                ),
                                child: Icon(
                                  brightnessDark
                                      ? AppIcons.darkMode
                                      : AppIcons.lightMode,
                                  size: 14.sp,
                                  color: AppColors.textPrimaryDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (onLanguageToggle != null)
                        AnimatedLanguageSwitcher3DModern(
                          languages: const [
                            LanguageOption(
                              code: "en",
                              label: "English",
                              flagEmoji: "🇺🇸",
                            ),
                            LanguageOption(
                              code: "id",
                              label: "Bahasa",
                              flagEmoji: "🇮🇩",
                            ),
                          ],
                          currentLanguage: LanguageOption(
                            code: localizations.locale.languageCode,
                            label: localizations.locale.languageCode == 'en'
                                ? "English"
                                : "Bahasa",
                            flagEmoji: localizations.locale.languageCode == 'en'
                                ? "🇺🇸"
                                : "🇮🇩",
                          ),
                          onChanged: (lang) => onLanguageToggle?.call(),
                        ),
                      if (actions != null) ...actions!,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
