import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../home/presentation/widget/app_bar.dart';
import '../../../../core/utils/app_image.dart';
import '../provider/achievement_provider.dart';
import '../../domain/entities/badge_entity.dart';
import '../../domain/entities/achievement_entity.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

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
                    automaticallyImplyLeading: false,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: AppColors.transparent,
                    expandedHeight: 70.h,
                    flexibleSpace: GlassAppBar(
                      isDark: isDark,
                      autoBack: true,
                      title: AppLocalizations.of(
                        context,
                      ).translate('achievements_title'),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Consumer<AchievementProvider>(
                      builder: (context, achievementProvider, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),

                            /// Profile Header with XP and Ranking
                            Center(
                              child: _buildProfileHeader(
                                context: context,
                                isDark: isDark,
                                glass: glass,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                achievementProvider: achievementProvider,
                              ),
                            ),

                            SizedBox(height: 32.h),

                            /// Badge Collection Section
                            _buildSectionHeader(
                              context: context,
                              icon: '🏆',
                              titleKey: 'badge_collection',
                              badgeCount:
                                  achievementProvider.unlockedBadgesCount,
                              totalBadges: achievementProvider.badges.length,
                              textSecondary: textSecondary,
                            ),

                            SizedBox(height: 16.h),

                            /// Badge Grid (2x2)
                            _buildBadgeGrid(
                              context: context,
                              isDark: isDark,
                              glass: glass,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              badges: achievementProvider.badges,
                            ),

                            SizedBox(height: 32.h),

                            /// Latest Achievements Section
                            _buildSectionHeader(
                              context: context,
                              icon: '🎯',
                              titleKey: 'latest_achievements',
                              textSecondary: textSecondary,
                            ),

                            SizedBox(height: 16.h),

                            /// Achievement List
                            _buildAchievementList(
                              context: context,
                              isDark: isDark,
                              glass: glass,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              achievements:
                                  achievementProvider.latestAchievements,
                            ),

                            SizedBox(height: 100.h),
                          ],
                        );
                      },
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

  Widget _buildProfileHeader({
    required BuildContext context,
    required bool isDark,
    required GlassTheme glass,
    required Color textPrimary,
    required Color textSecondary,
    required AchievementProvider achievementProvider,
  }) {
    return Column(
      children: [
        /// Avatar with Level Badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Outer Glow
            Container(
              width: 125.w,
              height: 125.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 40,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
            // Border Ring with Dynamic Gradient based on level
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _getAvatarGradient(achievementProvider.userLevel),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(4.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.darkBackground[0] : Colors.white,
                ),
                padding: EdgeInsets.all(2.w),
                child: ClipOval(
                  child: AppImage(
                    src:
                        achievementProvider.profileProvider.profile?.photoURL ??
                        'https://i.pravatar.cc/400?img=12',
                    width: 110.w,
                    height: 110.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Level Badge
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFA500), Color(0xFFFF6B00)],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFFA500).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${AppLocalizations.of(context).translate('level')} ${achievementProvider.userLevel}',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),

        /// Total XP
        Text(
          '${_formatNumber(achievementProvider.learningProvider.totalXP)} XP',
          style: AppTypography.h1.copyWith(
            color: textPrimary,
            fontSize: 32.sp,
            fontWeight: FontWeight.w800,
          ),
        ),

        SizedBox(height: 8.h),

        /// Ranking
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                Colors.purple.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(
                  context,
                ).translate(achievementProvider.userRank),
                style: AppTypography.bodySmall.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                AppLocalizations.of(
                  context,
                ).translate(achievementProvider.globalRanking),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required BuildContext context,
    required String icon,
    required String titleKey,
    required Color textSecondary,
    int? badgeCount,
    int? totalBadges,
  }) {
    return Row(
      children: [
        Text(icon, style: TextStyle(fontSize: 16.sp)),
        SizedBox(width: 8.w),
        Text(
          AppLocalizations.of(context).translate(titleKey).toUpperCase(),
          style: AppTypography.bodySmall.copyWith(
            color: textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontSize: 11.sp,
          ),
        ),
        if (badgeCount != null && totalBadges != null) ...[
          Spacer(),
          Text(
            '$badgeCount / $totalBadges ${AppLocalizations.of(context).translate('unlocked')}',
            style: AppTypography.bodySmall.copyWith(
              color: textSecondary.withValues(alpha: 0.6),
              fontSize: 11.sp,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBadgeGrid({
    required BuildContext context,
    required bool isDark,
    required GlassTheme glass,
    required Color textPrimary,
    required Color textSecondary,
    required List<BadgeEntity> badges,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.0,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _buildBadgeCard(
          context: context,
          isDark: isDark,
          glass: glass,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          badge: badge,
        );
      },
    );
  }

  Widget _buildBadgeCard({
    required BuildContext context,
    required bool isDark,
    required GlassTheme glass,
    required Color textPrimary,
    required Color textSecondary,
    required BadgeEntity badge,
  }) {
    final isLocked = !badge.isUnlocked;

    return Container(
      decoration: BoxDecoration(
        color: isLocked ? glass.color.withValues(alpha: 0.3) : glass.color,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isLocked ? glass.border.withValues(alpha: 0.3) : glass.border,
          width: glass.borderWidth,
        ),
        boxShadow: isLocked
            ? []
            : [
                BoxShadow(
                  color: Color(badge.color).withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Badge Icon
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              gradient: isLocked
                  ? null
                  : LinearGradient(
                      colors: [
                        Color(badge.color).withValues(alpha: 0.2),
                        Color(badge.color).withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              color: isLocked ? textSecondary.withValues(alpha: 0.1) : null,
              shape: BoxShape.circle,
              border: Border.all(
                color: isLocked
                    ? textSecondary.withValues(alpha: 0.2)
                    : Color(badge.color).withValues(alpha: 0.3),
                width: 2.w,
              ),
            ),
            child: Center(
              child: Text(
                badge.icon,
                style: TextStyle(
                  fontSize: 28.sp,
                  color: isLocked ? textSecondary.withValues(alpha: 0.3) : null,
                ),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          /// Badge Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              AppLocalizations.of(context).translate(badge.titleKey),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleMedium.copyWith(
                color: isLocked
                    ? textSecondary.withValues(alpha: 0.4)
                    : textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          /// Badge Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              AppLocalizations.of(context).translate(badge.descriptionKey),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: isLocked
                    ? textSecondary.withValues(alpha: 0.3)
                    : textSecondary,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementList({
    required BuildContext context,
    required bool isDark,
    required GlassTheme glass,
    required Color textPrimary,
    required Color textSecondary,
    required List<AchievementEntity> achievements,
  }) {
    return Column(
      children: achievements.map((achievement) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildAchievementCard(
            context: context,
            isDark: isDark,
            glass: glass,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            achievement: achievement,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAchievementCard({
    required BuildContext context,
    required bool isDark,
    required GlassTheme glass,
    required Color textPrimary,
    required Color textSecondary,
    required AchievementEntity achievement,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: glass.border, width: glass.borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              /// Achievement Icon
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Color(achievement.color).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    achievement.icon,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              /// Achievement Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate(achievement.titleKey),
                      style: AppTypography.titleMedium.copyWith(
                        color: textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate(achievement.descriptionKey),
                      style: AppTypography.bodySmall.copyWith(
                        color: textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),

              /// XP Reward
              if (achievement.isCompleted)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '+${achievement.xpReward} XP',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                    ),
                  ),
                )
              else
                Text(
                  '${achievement.currentProgress}/${achievement.targetProgress}',
                  style: AppTypography.bodySmall.copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
            ],
          ),

          SizedBox(height: 12.h),

          /// Progress Bar
          Stack(
            children: [
              /// Background
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              /// Progress Fill
              FractionallySizedBox(
                widthFactor: achievement.progressPercentage,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(achievement.color),
                        Color(achievement.color).withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Color(achievement.color).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  LinearGradient _getAvatarGradient(int level) {
    if (level >= 20) {
      return const LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFFC026D3), Color(0xFFF43F5E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (level >= 15) {
      return const LinearGradient(
        colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (level >= 10) {
      return const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (level >= 5) {
      return const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}k';
    }
    return number.toString();
  }
}
