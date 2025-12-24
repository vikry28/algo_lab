// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../../onboarding/domain/usecases/reset_onboarding_usecase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/di/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../home/presentation/widget/modern_notification.dart';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LogoutSection extends StatefulWidget {
  final Color textSecondary;

  const LogoutSection({super.key, required this.textSecondary});

  @override
  State<LogoutSection> createState() => _LogoutSectionState();
}

class _LogoutSectionState extends State<LogoutSection> {
  String _version = '1.0.0';
  String _buildNumber = '1';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = info.version;
        _buildNumber = info.buildNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the build tag (Beta or Release)
    const String buildTag = kReleaseMode ? 'Release' : 'Beta';

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 54.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
            color: Colors.red.withValues(alpha: 0.05),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18.r),
              onTap: () async {
                try {
                  await sl<AuthService>().signOut();
                  if (context.mounted) {
                    final localizations = AppLocalizations.of(context);
                    ModernNotification.show(
                      context,
                      message: localizations.translate(
                        'notification_logout_success',
                      ),
                      type: ModernNotificationType.success,
                    );
                    await sl<ResetOnboardingUseCase>().call();
                    context.go('/onboard');
                  }
                } catch (e) {
                  if (context.mounted) {
                    final localizations = AppLocalizations.of(context);
                    ModernNotification.show(
                      context,
                      message: localizations
                          .translate('notification_logout_failed')
                          .replaceAll('{error}', e.toString()),
                      type: ModernNotificationType.error,
                    );
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    AppLocalizations.of(context).translate('profile_logout'),
                    style: AppTypography.titleMedium.copyWith(
                      color: Colors.redAccent,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 20.h),

        /// Version
        Text(
          '${AppLocalizations.of(context).translate('profile_version')} $_version ($_buildNumber) $buildTag',
          style: AppTypography.bodySmall.copyWith(
            color: widget.textSecondary.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
