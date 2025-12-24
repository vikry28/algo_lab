import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../home/data/models/language_model.dart';
import '../../../home/presentation/widget/language_switcher.dart';
import '../provider/profile_provider.dart';
import 'ios_switch.dart';

class SettingsSection extends StatelessWidget {
  final Color textPrimary;
  final Color textSecondary;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final List<LanguageOption> languages;

  const SettingsSection({
    super.key,
    required this.textPrimary,
    required this.textSecondary,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassTheme>()!;

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  AppLocalizations.of(
                    context,
                  ).translate('profile_account_settings'),
                  style: AppTypography.bodySmall.copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            Container(
              decoration: BoxDecoration(
                color: glass.color,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: glass.border,
                  width: glass.borderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _settingRow(
                    context: context,
                    icon: Icons.edit_outlined,
                    color: Colors.blue,
                    title: AppLocalizations.of(
                      context,
                    ).translate('profile_edit'),
                    subtitle: AppLocalizations.of(
                      context,
                    ).translate('profile_edit_subtitle'),
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    isFirst: true,
                    onTap: () => context.push('/profile/edit'),
                  ),
                  _divider(textSecondary),
                  _settingRow(
                    context: context,
                    icon: Icons.lock_outline_rounded,
                    color: Colors.green,
                    title: AppLocalizations.of(
                      context,
                    ).translate('profile_security'),
                    subtitle: AppLocalizations.of(
                      context,
                    ).translate('profile_security_subtitle'),
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onTap: () => context.push('/profile/security'),
                  ),
                  _divider(textSecondary),
                  _settingRow(
                    context: context,
                    icon: Icons.notifications_none_rounded,
                    color: Colors.orange,
                    title: AppLocalizations.of(
                      context,
                    ).translate('profile_notifications'),
                    subtitle: AppLocalizations.of(
                      context,
                    ).translate('profile_notifications_subtitle'),
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onTap: () => profileProvider.toggleNotifications(
                      !profileProvider.notificationsEnabled,
                    ),
                    trailing: ModernIOSSwitch(
                      value: profileProvider.notificationsEnabled,
                      onChanged: (val) =>
                          profileProvider.toggleNotifications(val),
                    ),
                  ),
                  _divider(textSecondary),
                  _settingRow(
                    context: context,
                    icon: Icons.language_rounded,
                    color: Colors.purple,
                    title: AppLocalizations.of(
                      context,
                    ).translate('profile_language'),
                    subtitle:
                        Localizations.localeOf(context).languageCode == 'id'
                        ? 'Indonesia (ID)'
                        : 'English (EN)',
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    isLast: true,
                    trailing: AnimatedLanguageSwitcher3DModern(
                      languages: languages,
                      currentLanguage: languages.firstWhere(
                        (l) =>
                            l.code ==
                            Localizations.localeOf(context).languageCode,
                        orElse: () => languages[0],
                      ),
                      onChanged: (lang) {
                        context.read<ThemeProvider>().setLocale(
                          Locale(lang.code),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _divider(Color color) {
    return Divider(
      height: 1,
      thickness: 1,
      color: color.withValues(alpha: 0.05),
      indent: 60.w,
    );
  }

  Widget _settingRow({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required Color textPrimary,
    required Color textSecondary,
    bool isFirst = false,
    bool isLast = false,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(24.r) : Radius.zero,
          bottom: isLast ? Radius.circular(24.r) : Radius.zero,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
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
                        fontSize: 15.sp,
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
                    size: 20.sp,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
