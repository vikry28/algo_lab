import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class ModernConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool closeOnConfirm;
  final bool closeOnCancel;

  const ModernConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.iconColor = Colors.amberAccent,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    this.onCancel,
    this.closeOnConfirm = true,
    this.closeOnCancel = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth > 600 ? 340.w : 300.w,
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.95),
                    const Color(0xFF1E40AF).withValues(alpha: 0.98),
                  ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white24, width: 1.w),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 32.sp),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppTypography.h2.copyWith(
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w900,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.3,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              if (onCancel != null) {
                                onCancel!();
                              }
                              if (closeOnCancel) {
                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                            ),
                            child: Text(
                              cancelLabel,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              onConfirm();
                              if (closeOnConfirm) {
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                            ),
                            child: Text(
                              confirmLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
