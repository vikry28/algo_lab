import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/array_item.dart';

Widget barWidget({
  required BuildContext context,
  required ArrayItem item,
  required double maxVal,
  bool small = false,
  bool highlight = false,
  Color? highlightColor,
  String label = '',
}) {
  final height =
      (item.value / (maxVal <= 0 ? 1 : maxVal)) * 140; // scale to view
  final width = small ? 20.w : 32.w;
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: height.h,
        decoration: BoxDecoration(
          color: highlight
              ? (highlightColor ?? Colors.cyan)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            if (highlight)
              BoxShadow(
                color: (highlightColor ?? Colors.cyan).withValues(alpha: 0.25),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
          ),
        ),
      ),
    ],
  );
}
