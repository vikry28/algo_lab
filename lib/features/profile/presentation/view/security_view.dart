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
import '../widget/ios_switch.dart';
import '../provider/profile_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../home/presentation/widget/modern_confirm_dialog.dart';
import '../../../home/presentation/widget/modern_input_dialog.dart';
import '../../../home/presentation/widget/modern_notification.dart';

class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  // Logic removed into ProfileProvider

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDark;
    final glass = Theme.of(context).extension<GlassTheme>()!;

    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

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
                      ).translate('profile_security'),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Column(
                        children: [
                          SizedBox(height: 32.h),

                          /// Security Status Header
                          Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.withValues(alpha: 0.2),
                                  Colors.green.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.verified_user_rounded,
                                    color: Colors.green,
                                    size: 32.sp,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Your Account is Secure',
                                        style: AppTypography.h2.copyWith(
                                          color: textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Everything looks good with your security settings.',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 32.h),

                          _buildSectionLabel('Login & Recovery', textSecondary),
                          SizedBox(height: 12.h),

                          _buildGlassList([
                            _buildSecurityRow(
                              icon: Icons.vpn_key_outlined,
                              color: Colors.blue,
                              title: 'Change Password',
                              subtitle: 'Update your login credentials',
                              onTap: () => _showChangePasswordDialog(context),
                              isDark: isDark,
                            ),
                            _buildDivider(textSecondary),
                            _buildSecurityRow(
                              icon: Icons.devices_rounded,
                              color: Colors.purple,
                              title: 'Session Info',
                              subtitle: 'Current device identified',
                              onTap: () {
                                ModernNotification.show(
                                  context,
                                  message: 'Session secured on this device',
                                  type: ModernNotificationType.info,
                                );
                              },
                              isDark: isDark,
                            ),
                          ]),

                          SizedBox(height: 32.h),

                          _buildSectionLabel(
                            'Advanced Security',
                            textSecondary,
                          ),
                          SizedBox(height: 12.h),

                          Consumer<ProfileProvider>(
                            builder: (context, profileProvider, _) {
                              final profile = profileProvider.profile;
                              final twoFactorEnabled =
                                  profile?.twoFactorEnabled ?? false;
                              final biometricEnabled =
                                  profile?.biometricEnabled ?? true;

                              return _buildGlassList([
                                _buildSecurityRow(
                                  icon: Icons.app_registration_rounded,
                                  color: Colors.orange,
                                  title: 'Two-Factor Auth',
                                  subtitle: 'Requires email verification',
                                  isDark: isDark,
                                  trailing: ModernIOSSwitch(
                                    value: twoFactorEnabled,
                                    onChanged: (val) => _toggleSecurity(
                                      context,
                                      () =>
                                          profileProvider.updateTwoFactor(val),
                                    ),
                                  ),
                                  onTap: () => _toggleSecurity(
                                    context,
                                    () => profileProvider.updateTwoFactor(
                                      !twoFactorEnabled,
                                    ),
                                  ),
                                ),
                                _buildDivider(textSecondary),
                                _buildSecurityRow(
                                  icon: Icons.fingerprint_rounded,
                                  color: Colors.cyan,
                                  title: 'Biometric Login',
                                  subtitle: 'Face ID or Fingerprint',
                                  isDark: isDark,
                                  trailing: ModernIOSSwitch(
                                    value: biometricEnabled,
                                    onChanged: (val) => _toggleSecurity(
                                      context,
                                      () =>
                                          profileProvider.updateBiometric(val),
                                    ),
                                  ),
                                  onTap: () => _toggleSecurity(
                                    context,
                                    () => profileProvider.updateBiometric(
                                      !biometricEnabled,
                                    ),
                                  ),
                                ),
                              ]);
                            },
                          ),

                          SizedBox(height: 32.h),

                          _buildSectionLabel(
                            'Danger Zone',
                            Colors.redAccent.withValues(alpha: 0.8),
                          ),
                          SizedBox(height: 12.h),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(
                                color: Colors.redAccent.withValues(alpha: 0.2),
                                width: 1.w,
                              ),
                            ),
                            child: _buildSecurityRow(
                              icon: Icons.delete_forever_rounded,
                              color: Colors.redAccent,
                              title: 'Delete Account',
                              subtitle: 'Permanently remove all your data',
                              isDark: isDark,
                              onTap: () => _showDeleteAccountDialog(context),
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

  Widget _buildSectionLabel(String label, Color color) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildGlassList(List<Widget> children) {
    final glass = Theme.of(context).extension<GlassTheme>()!;
    return Container(
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: glass.border, width: glass.borderWidth),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSecurityRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isDark,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 22.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    color: textSecondary.withValues(alpha: 0.3),
                    size: 24.sp,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Divider(
      height: 1,
      thickness: 1,
      color: color.withValues(alpha: 0.05),
      indent: 68.w,
    );
  }

  Future<void> _toggleSecurity(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    final provider = context.read<ProfileProvider>();
    final authenticated = await provider.authenticateWithBiometrics();
    if (authenticated) {
      await action();
      if (context.mounted) {
        ModernNotification.show(context, message: 'Security setting updated');
      }
    } else if (context.mounted) {
      ModernNotification.show(
        context,
        message: 'Authentication failed',
        type: ModernNotificationType.error,
      );
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    final provider = context.read<ProfileProvider>();
    if (!provider.canChangePassword) {
      ModernNotification.show(
        context,
        message: 'Password change not available for this account type',
        type: ModernNotificationType.info,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ModernInputDialog(
        title: 'Change Password',
        message: 'Enter your new security password below',
        icon: Icons.lock_reset_rounded,
        iconColor: Colors.blueAccent,
        hintText: 'Minimum 6 characters',
        obscureText: true,
        confirmLabel: 'UPDATE',
        cancelLabel: 'CANCEL',
        onConfirm: (newPassword) async {
          if (newPassword.length < 6) {
            ModernNotification.show(
              context,
              message: 'Password too short',
              type: ModernNotificationType.error,
            );
            return;
          }
          try {
            await provider.changePassword(newPassword);
            if (context.mounted) {
              ModernNotification.show(
                context,
                message: 'Password updated successfully',
              );
            }
          } catch (e) {
            if (context.mounted) {
              ModernNotification.show(
                context,
                message: 'Error: $e',
                type: ModernNotificationType.error,
              );
            }
          }
        },
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ModernConfirmDialog(
        title: 'Delete Account?',
        message:
            'This action is PERMANENT. All your progress, XP, and badges will be lost forever.',
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.redAccent,
        confirmLabel: 'DELETE',
        cancelLabel: 'KEEP ACCOUNT',
        onConfirm: () async {
          final provider = context.read<ProfileProvider>();
          try {
            await provider.deleteAccount();
            if (context.mounted) {
              context.go('/onboard');
              ModernNotification.show(
                context,
                message: 'Account deleted permanently',
              );
            }
          } catch (e) {
            if (context.mounted) {
              ModernNotification.show(
                context,
                message: 'Failed to delete: $e',
                type: ModernNotificationType.error,
              );
            }
          }
        },
      ),
    );
  }
}
