import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final bool isDark;
  final VoidCallback onTap;

  const HeaderSection({
    super.key,
    required this.isDark,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.h2.copyWith(
            fontSize: 18.sp,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),

        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Text(
            AppLocalizations.of(context).translate('view_all'),
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
