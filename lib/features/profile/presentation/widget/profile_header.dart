import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/utils/app_image.dart';
import '../provider/profile_provider.dart';

class ProfileHeader extends StatelessWidget {
  final bool isDark;
  final Color textPrimary;

  const ProfileHeader({
    super.key,
    required this.isDark,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.h),

        /// Avatar with Premium Glow
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
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 40,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
            // Border Ring
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 4.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, _) {
                  final avatar =
                      profileProvider.profile?.photoURL ??
                      'https://i.pravatar.cc/400?img=12';
                  return AppImage(
                    src: avatar,
                    width: 120.w,
                    height: 120.w,
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(60.w),
                    showPreview: true,
                  );
                },
              ),
            ),

            // Level Badge
            Positioned(
              right: 2.w,
              bottom: 2.h,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground[0] : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00D26A), Color(0xFF00E676)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D26A).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16.sp),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        /// Name
        Consumer<ProfileProvider>(
          builder: (context, profileProvider, _) {
            final name = profileProvider.profile?.displayName ?? 'User';
            return Text(
              name,
              style: AppTypography.h1.copyWith(
                color: textPrimary,
                fontSize: 24.sp,
              ),
            );
          },
        ),

        SizedBox(height: 8.h),

        /// Level pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: textPrimary.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bolt_rounded,
                color: const Color(0xFFFFD166),
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Consumer<ProfileProvider>(
                builder: (context, profileProvider, _) {
                  final profile = profileProvider.profile;
                  final level = profile?.level ?? 1;
                  final rank = profile?.rank ?? 'Novice';
                  return Text(
                    '${AppLocalizations.of(context).translate('profile_level')} $level - $rank',
                    style: AppTypography.labelSmall.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
