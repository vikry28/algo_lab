import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_extension.dart';
import '../provider/graph_provider.dart';

class AlgorithmSelector extends StatelessWidget {
  final GraphProvider prov;
  final GlassTheme glass;
  final bool isDark;

  const AlgorithmSelector({
    super.key,
    required this.prov,
    required this.glass,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: glass.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.settings_input_component_rounded,
            color: Colors.cyanAccent,
            size: 16.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "ALGORITHM MODE:",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          DropdownButton<AlgorithmType>(
            value: prov.algorithmType,
            dropdownColor: isDark ? Colors.grey[900] : Colors.white,
            style: TextStyle(
              color: isDark ? Colors.cyanAccent : Colors.cyan.shade800,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
            underline: Container(),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.cyanAccent),
            onChanged: prov.isRunning
                ? null
                : (AlgorithmType? newValue) {
                    if (newValue != null) {
                      prov.setAlgorithmType(newValue);
                    }
                  },
            items: const [
              DropdownMenuItem(
                value: AlgorithmType.dijkstra,
                child: Text("Dijkstra (Standard)"),
              ),
              DropdownMenuItem(
                value: AlgorithmType.kShortestPath,
                child: Text("K-Shortest Paths"),
              ),
              DropdownMenuItem(
                value: AlgorithmType.ecmp,
                child: Text("ECMP / Flow"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
