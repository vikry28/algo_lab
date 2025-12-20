// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../data/models/enum.dart';
import '../provider/sorting_provider.dart';

class AlgorithmSelector extends StatelessWidget {
  const AlgorithmSelector({super.key});

  final algoNames = const {
    SortingAlgorithm.bubble: "Bubble Sort",
    SortingAlgorithm.selection: "Selection Sort",
    SortingAlgorithm.insertion: "Insertion Sort",
    SortingAlgorithm.quick: "Quick Sort",
  };

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<SortingProvider>(context);
    final glass = Theme.of(context).extension<GlassTheme>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: glass.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Algorithm",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),

          /// Horizontal selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: SortingAlgorithm.values.map((algo) {
                final selected = prov.selectedAlgorithm == algo;

                return Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: GestureDetector(
                    onTap: () => prov.changeAlgorithm(algo),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        color: selected
                            ? Colors.cyanAccent.withOpacity(0.18)
                            : glass.color,
                        border: Border.all(
                          color: selected ? Colors.cyanAccent : glass.border,
                        ),
                        boxShadow: [
                          if (selected)
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.25),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _algoIcon(algo),
                            size: 18.sp,
                            color: selected
                                ? Colors.cyanAccent
                                : (isDark ? Colors.white70 : Colors.black54),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            algoNames[algo]!,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: selected
                                  ? Colors.cyanAccent
                                  : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _algoIcon(SortingAlgorithm algo) {
    switch (algo) {
      case SortingAlgorithm.bubble:
        return Icons.bubble_chart;
      case SortingAlgorithm.selection:
        return Icons.checklist;
      case SortingAlgorithm.insertion:
        return Icons.input;
      case SortingAlgorithm.quick:
        return Icons.flash_on;
    }
  }
}
