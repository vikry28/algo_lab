// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/utils/app_image.dart';
import '../../../home/presentation/widget/app_bar.dart';
import '../provider/profile_provider.dart';
import '../../../home/presentation/widget/modern_notification.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _bioController = TextEditingController(
    text: 'Algorithms enthusiast & Flutter Developer',
  );

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _nameController = TextEditingController(text: profile?.displayName ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDark;
    final glass = Theme.of(context).extension<GlassTheme>()!;

    return Scaffold(
      extendBodyBehindAppBar: true,
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
                    leadingWidth: 0,
                    automaticallyImplyLeading: false,
                    flexibleSpace: GlassAppBar(
                      isDark: isDark,
                      autoBack: true,
                      title: AppLocalizations.of(
                        context,
                      ).translate('profile_edit'),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Column(
                        children: [
                          SizedBox(height: 32.h),

                          /// Profile Picture Edit
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 120.w,
                                  height: 120.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 3.w,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Consumer<ProfileProvider>(
                                    builder: (context, provider, _) {
                                      final avatar =
                                          provider.profile?.photoURL ??
                                          'https://i.pravatar.cc/400?img=12';
                                      return ClipOval(
                                        child: AppImage(
                                          src: avatar,
                                          fit: BoxFit.cover,
                                          showPreview: true,
                                          canEdit: true,
                                          onImageEdited: (url) =>
                                              provider.updatePhotoURL(url),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF1E1E2E)
                                            : Colors.white,
                                        width: 2.w,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 40.h),

                          /// Form Fields
                          _buildGlassField(
                            label: 'Full Name',
                            controller: _nameController,
                            icon: Icons.person_outline_rounded,
                            isDark: isDark,
                          ),
                          SizedBox(height: 20.h),
                          _buildGlassField(
                            label: 'Email Address',
                            controller: _emailController,
                            icon: Icons.email_outlined,
                            isDark: isDark,
                          ),
                          SizedBox(height: 20.h),
                          _buildGlassField(
                            label: 'Bio',
                            controller: _bioController,
                            icon: Icons.info_outline_rounded,
                            isDark: isDark,
                            maxLines: 3,
                          ),

                          SizedBox(height: 40.h),

                          /// Save Button
                          Container(
                            width: double.infinity,
                            height: 56.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withValues(alpha: 0.8),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                final provider = context
                                    .read<ProfileProvider>();
                                await provider.updateDisplayName(
                                  _nameController.text,
                                );
                                if (mounted) {
                                  ModernNotification.show(
                                    context,
                                    message: 'Profile Updated Successfully!',
                                  );
                                  context.pop();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: Text(
                                'Save Changes',
                                style: AppTypography.titleMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 100.h),
                        ],
                      ),
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

  Widget _buildGlassField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isDark,
    int maxLines = 1,
  }) {
    final glass = Theme.of(context).extension<GlassTheme>()!;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: glass.color,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: glass.border, width: glass.borderWidth),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: AppTypography.body.copyWith(color: textPrimary),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary, size: 20.sp),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
