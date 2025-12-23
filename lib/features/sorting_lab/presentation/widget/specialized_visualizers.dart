import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/array_item.dart';
import '../../data/models/enum.dart';
import '../../domain/usecases/bubble_sort_usecase.dart';

class SpecializedVisualizer extends StatelessWidget {
  final SortingAlgorithm algorithm;
  final List<ArrayItem> items;
  final double maxVal;
  final int? highlightA;
  final int? highlightB;
  final StepType? highlightType;
  final Color compareColor;
  final Color swapColor;
  final bool isDark;

  const SpecializedVisualizer({
    super.key,
    required this.algorithm,
    required this.items,
    required this.maxVal,
    this.highlightA,
    this.highlightB,
    this.highlightType,
    required this.compareColor,
    required this.swapColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        switch (algorithm) {
          case SortingAlgorithm.bubble:
            return _buildBubbleVisualizer(context, constraints);
          case SortingAlgorithm.selection:
            return _buildSelectionVisualizer(context, constraints);
          case SortingAlgorithm.insertion:
            return _buildInsertionVisualizer(context, constraints);
          case SortingAlgorithm.quick:
            return _buildQuickVisualizer(context, constraints);
        }
      },
    );
  }

  Widget _buildBubbleVisualizer(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12.w,
        runSpacing: 16.h,
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isHighlight = (highlightA == i || highlightB == i);
          final isSwap = isHighlight && highlightType == StepType.swap;

          final size = 42.w + (item.value / maxVal) * 35.w;

          return AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: isSwap
                ? 1.15
                : (isHighlight ? 1.05 : 1.0), // Slight scale on highlight
            curve: Curves.easeOutBack,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: size,
              height: size,
              transform: Matrix4.translationValues(
                0,
                isHighlight ? -8.0 : 0,
                0,
              ), // Jump effect
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.3),
                  colors: isHighlight
                      ? [
                          (isSwap ? swapColor : compareColor).withValues(
                            alpha: 0.9,
                          ),
                          (isSwap ? swapColor : compareColor),
                        ]
                      : [
                          (isDark ? Colors.blueAccent : AppColors.primary)
                              .withValues(alpha: 0.5), // Richer color
                          (isDark ? Colors.blueAccent : AppColors.primary)
                              .withValues(alpha: 0.2),
                        ],
                  stops: const [0.3, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isHighlight
                                ? (isSwap ? swapColor : compareColor)
                                : (isDark
                                      ? Colors.blueAccent
                                      : AppColors.primary))
                            .withValues(alpha: isHighlight ? 0.5 : 0.3),
                    blurRadius: isHighlight ? 25 : 15,
                    spreadRadius: isHighlight ? 2 : 0,
                    offset: isHighlight
                        ? const Offset(0, 10)
                        : const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glass Reflection
                  Positioned(
                    top: size * 0.15,
                    left: size * 0.15,
                    child: Container(
                      width: size * 0.35,
                      height: size * 0.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.5),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    item.value.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: (14 + (item.value / maxVal) * 4)
                          .sp, // Slightly larger text
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black45,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSelectionVisualizer(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final t = AppLocalizations.of(context);
    final itemWidth =
        (constraints.maxWidth - (items.length * 8.w)) / items.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(items.length, (i) {
            final item = items[i];
            final isHighlight = (highlightA == i || highlightB == i);
            final isMin = (highlightA == i);
            final color = isHighlight
                ? (highlightType == StepType.swap ? swapColor : compareColor)
                : (isDark
                      ? Colors.orange.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.1));

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  // Scanning Beam Effect for Current Min
                  if (isMin)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: itemWidth.clamp(30, 45) + 10,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.amberAccent.withValues(alpha: 0.3),
                              Colors.amberAccent.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    width: itemWidth.clamp(30, 45),
                    height:
                        50.h +
                        (item.value / maxVal) * 30.h +
                        (isMin ? 10.h : 0), // Pop up if Min
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isMin
                            ? Colors.amberAccent
                            : isHighlight
                            ? Colors.white70
                            : (isDark ? Colors.white12 : Colors.black12),
                        width: isMin || isHighlight ? 2 : 1,
                      ),
                      boxShadow: [
                        if (isHighlight)
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isMin ? Icons.star : Icons.inventory_2_outlined,
                          size: 14.sp,
                          color: isMin ? Colors.amberAccent : Colors.white38,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item.value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isMin)
                    Positioned(
                      top: -30.h,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: 1.2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: 0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 25.h),
        // Conveyor Belt Base
        Container(
          height: 12.h,
          width: constraints.maxWidth * 0.8,
          decoration: BoxDecoration(
            color: Colors.blueGrey.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              8,
              (i) => Container(
                width: 2.w,
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          t.translate('lab_searching_min'),
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? Colors.white38 : Colors.black38,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildInsertionVisualizer(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isHighlight = (highlightA == i || highlightB == i);
          final isCompare = isHighlight && highlightType == StepType.compare;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            padding: EdgeInsets.all(8.w),
            width: 60.w,
            height: 90.h,
            transform: Matrix4.translationValues(0, isHighlight ? -15.h : 0, 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isHighlight
                    ? [swapColor.withValues(alpha: 0.9), swapColor]
                    : [
                        (isDark ? Colors.indigo : AppColors.primary).withValues(
                          alpha: 0.4,
                        ),
                        (isDark ? Colors.indigo : AppColors.primary).withValues(
                          alpha: 0.2,
                        ),
                      ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isHighlight
                    ? (isDark ? Colors.white54 : Colors.black54)
                    : (isDark ? Colors.white10 : Colors.black12),
                width: isHighlight ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: isHighlight ? 15 : 5,
                  offset: Offset(0, isHighlight ? 10 : 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Card Tab
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 10.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Icon(Icons.style, size: 10.sp, color: Colors.white24),
                  ],
                ),
                Text(
                  item.value.toString(),
                  style: GoogleFonts.firaCode(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: isHighlight
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
                if (isCompare)
                  Icon(Icons.swap_horiz, size: 14.sp, color: Colors.white70)
                else
                  SizedBox(height: 14.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuickVisualizer(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final barPadding = 4.w;
    final itemWidth =
        (constraints.maxWidth - (items.length * barPadding * 2)) / items.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(items.length, (i) {
            final item = items[i];
            final isHighlight = (highlightA == i || highlightB == i);
            final isPivot = (highlightA == i);
            final height = 20.h + (item.value / maxVal) * 110.h;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: barPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: itemWidth.clamp(15, 30),
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isHighlight
                            ? [
                                (isPivot ? Colors.pinkAccent : swapColor)
                                    .withValues(alpha: 0.9),
                                (isPivot ? Colors.pinkAccent : swapColor)
                                    .withValues(alpha: 0.6),
                              ]
                            : [
                                (isDark ? Colors.cyanAccent : AppColors.primary)
                                    .withValues(alpha: 0.5),
                                (isDark ? Colors.cyanAccent : AppColors.primary)
                                    .withValues(alpha: 0.1),
                              ],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8.r),
                        bottom: Radius.circular(4.r),
                      ),
                      boxShadow: [
                        if (isHighlight)
                          BoxShadow(
                            color: (isPivot ? Colors.pinkAccent : swapColor)
                                .withValues(alpha: 0.5),
                            blurRadius: 15,
                            spreadRadius: 1,
                            offset: const Offset(0, -5),
                          ),
                      ],
                      border: isPivot
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            item.value.toString(),
                            style: GoogleFonts.firaCode(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (isPivot)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Text(
                        "PIVOT",
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    SizedBox(height: 12.h),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
