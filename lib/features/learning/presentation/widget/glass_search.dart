import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_localizations.dart';
import '../provider/learning_provider.dart';

class GlassSearchField extends StatefulWidget {
  final bool isDark;
  const GlassSearchField({super.key, required this.isDark});

  @override
  State<GlassSearchField> createState() => GlassSearchFieldState();
}

class GlassSearchFieldState extends State<GlassSearchField> {
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;
  late final FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final provider = Provider.of<LearningProvider>(context);

    return Row(
      children: [
        // Square Icon Button
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: isDark ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.search, color: Colors.black, size: 24.sp),
        ),
        SizedBox(width: 12.w),
        // Search Field
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.shade200,
              border: Border.all(
                color: _isFocused
                    ? (isDark
                          ? Colors.cyanAccent.withValues(alpha: 0.5)
                          : Colors.blueAccent)
                    : Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              cursorColor: isDark ? Colors.cyanAccent : Colors.blueAccent,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('search_hint'),
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                isDense: false,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              onChanged: (value) {
                provider.filterItems(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
