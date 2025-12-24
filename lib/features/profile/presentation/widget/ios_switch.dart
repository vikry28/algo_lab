import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModernIOSSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ModernIOSSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<ModernIOSSwitch> createState() => _ModernIOSSwitchState();
}

class _ModernIOSSwitchState extends State<ModernIOSSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onChanged(!widget.value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 50.w,
        height: 28.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: widget.value
              ? const Color(0xFF34C759)
              : Colors.grey.withValues(alpha: 0.3),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: widget.value
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
