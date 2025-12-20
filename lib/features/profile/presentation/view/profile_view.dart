import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../home/presentation/widget/app_bar.dart';
import '../../../home/data/models/language_model.dart';
import '../widget/profile_header.dart';
import '../widget/progress_section.dart';
import '../widget/achievement_card.dart';
import '../widget/settings_section.dart';
import '../widget/logout_section.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _notificationsEnabled = true;

  final List<LanguageOption> _languages = const [
    LanguageOption(code: 'en', label: 'English', flagEmoji: '🇺🇸'),
    LanguageOption(code: 'id', label: 'Indonesia', flagEmoji: '🇮🇩'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDark;
    final glass = Theme.of(context).extension<GlassTheme>()!;

    /// Text colors
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.transparent,
      body: Stack(
        children: [
          /// Background gradient
          AnimatedContainer(
            duration: AppConstants.animationMedium,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// Glass blur overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
            child: Container(color: glass.color.withValues(alpha: 0.03)),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 5.h),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  /// AppBar
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    backgroundColor: AppColors.transparent,
                    expandedHeight: 70.h,
                    flexibleSpace: GlassAppBar(
                      isDark: isDark,
                      title: AppLocalizations.of(
                        context,
                      ).translate('profile_title'),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        /// 1. Header (Avatar, Name, Level)
                        ProfileHeader(isDark: isDark, textPrimary: textPrimary),

                        SizedBox(height: 32.h),

                        /// 2. Progress Summary
                        ProgressSection(
                          isDark: isDark,
                          textSecondary: textSecondary,
                        ),

                        SizedBox(height: 16.h),

                        /// 3. Achievements
                        AchievementCard(
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),

                        SizedBox(height: 32.h),

                        /// 4. Account Settings
                        SettingsSection(
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          notificationsEnabled: _notificationsEnabled,
                          languages: _languages,
                          onNotificationsChanged: (val) {
                            setState(() => _notificationsEnabled = val);
                          },
                        ),

                        SizedBox(height: 24.h),

                        /// 5. Logout & Version
                        LogoutSection(textSecondary: textSecondary),

                        // Bottom Padding
                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
