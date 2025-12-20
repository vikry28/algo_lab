import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class BubbleSortSectionWidgets {
  static Widget buildIntroSection(String introText, bool isDark) {
    return Text(
      introText,
      style: AppTypography.body.copyWith(
        color: isDark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight,
        fontSize: 14.sp,
        height: 1.6,
      ),
    );
  }

  static Widget buildHowItWorksSection(String howItWorks, bool isDark) {
    return Text(
      howItWorks,
      style: AppTypography.body.copyWith(
        color: isDark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight,
        fontSize: 13.sp,
        height: 1.5,
      ),
    );
  }

  static Widget buildComplexitySection(
    String timeBest,
    String timeAvg,
    String timeWorst,
    String space,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildComplexityItem(timeBest, isDark, Colors.green),
        SizedBox(height: 8.h),
        _buildComplexityItem(timeAvg, isDark, Colors.orange),
        SizedBox(height: 8.h),
        _buildComplexityItem(timeWorst, isDark, Colors.red),
        SizedBox(height: 8.h),
        _buildComplexityItem(space, isDark, Colors.blue),
      ],
    );
  }

  static Widget _buildComplexityItem(String text, bool isDark, Color color) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: AppTypography.body.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildAdvantagesSection(List<String> advantages, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: advantages
          .map(
            (adv) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                adv,
                style: AppTypography.body.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 13.sp,
                  height: 1.5,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  static Widget buildDisadvantagesSection(
    List<String> disadvantages,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: disadvantages
          .map(
            (dis) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                dis,
                style: AppTypography.body.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 13.sp,
                  height: 1.5,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  static Widget buildWhenToUseSection(List<String> whenToUse, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: whenToUse
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                item,
                style: AppTypography.body.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 13.sp,
                  height: 1.5,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  static Widget buildCaseStudyHeader(
    String title,
    String description,
    String data,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          description,
          style: AppTypography.body.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            fontSize: 13.sp,
            height: 1.5,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.blue.withValues(alpha: 0.1)
                : Colors.blue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
          ),
          child: Text(
            data,
            style: AppTypography.body.copyWith(
              color: Colors.blue,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
