// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../../onboarding/domain/usecases/reset_onboarding_usecase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/di/service_locator.dart';
import '../../../learning/presentation/provider/learning_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LogoutSection extends StatelessWidget {
  final Color textSecondary;

  const LogoutSection({super.key, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
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
                await sl<AuthService>().signOut();
                if (context.mounted) {
                  await sl<ResetOnboardingUseCase>().call();
                  await context.read<LearningProvider>().clearAllProgress();
                  context.go('/onboard');
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
          '${AppLocalizations.of(context).translate('profile_version')} 1.0.0 (Beta)',
          style: AppTypography.bodySmall.copyWith(
            color: textSecondary.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
