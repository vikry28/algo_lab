import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';

class CodeCard extends StatelessWidget {
  const CodeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDark;

    // BACKGROUND COLORS ========================================================
    final bgMain = isDark ? const Color(0xFF0A141D) : Colors.white;
    final bgEditor = isDark ? const Color(0xFF0D1A25) : const Color(0xFFEFF4FF);
    final bgConsole = isDark
        ? const Color(0xFF071019)
        : const Color(0xFFE9F0FC);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // =========================================================================
          // MAIN CODE CARD
          // =========================================================================
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: bgMain,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------------------------
                // CODE EDITOR HEADER (MacOS dots + filename)
                // ---------------------------------------------------------------------
                Row(
                  children: [
                    _editorDot(const Color(0xFFFF5F56)),
                    SizedBox(width: 6.w),
                    _editorDot(const Color(0xFFFFBD2E)),
                    SizedBox(width: 6.w),
                    _editorDot(const Color(0xFF27C93F)),
                    const Spacer(),
                    Text(
                      "main.dart",
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // ---------------------------------------------------------------------
                // CODE EDITOR BLOCK
                // ---------------------------------------------------------------------
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: bgEditor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    """
void main() {
  var list = [5, 2, 9, 1];
  list.sort();
  print('Sorted: \$list');
}""",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14.sp,
                      height: 1.38,
                      color: isDark
                          ? const Color(0xFFB6FFDA)
                          : const Color(0xFF00695C),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // ---------------------------------------------------------------------
                // OUTPUT CONSOLE
                // ---------------------------------------------------------------------
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: bgConsole,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    "> Sorted: [1, 2, 5, 9]",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13.sp,
                      height: 1.32,
                      color: isDark
                          ? const Color(0xFF84FF7E)
                          : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 18.h),

          // =========================================================================
          // BOTTOM MENU
          // =========================================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _bottomMenuItem(
                context: context,
                icon: Icons.code,
                label: AppLocalizations.of(
                  context,
                ).translate('interactive_code'),
                onTap: () {},
              ),
              SizedBox(width: 16.w),
              _bottomMenuItem(
                context: context,
                icon: Icons.book_outlined,
                label: AppLocalizations.of(context).translate('case_study'),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // DOT COMPONENT
  // ===========================================================================
  Widget _editorDot(Color color) {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  // ===========================================================================
  // BOTTOM MENU ITEM
  // ===========================================================================
  Widget _bottomMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.cardDark
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFF00695C), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              size: 20.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: AppTypography.body.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
