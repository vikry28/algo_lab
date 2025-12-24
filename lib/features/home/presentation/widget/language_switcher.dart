// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_icons.dart';
import '../../data/models/language_model.dart';
import 'dart:math';

class AnimatedLanguageSwitcher3DModern extends StatefulWidget {
  final List<LanguageOption> languages;
  final LanguageOption currentLanguage;
  final ValueChanged<LanguageOption> onChanged;

  const AnimatedLanguageSwitcher3DModern({
    super.key,
    required this.languages,
    required this.currentLanguage,
    required this.onChanged,
  });

  @override
  State<AnimatedLanguageSwitcher3DModern> createState() =>
      _AnimatedLanguageSwitcher3DModernState();
}

class _AnimatedLanguageSwitcher3DModernState
    extends State<AnimatedLanguageSwitcher3DModern>
    with SingleTickerProviderStateMixin {
  late LanguageOption selectedLanguage;
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconRotation;

  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.currentLanguage;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _iconRotation = Tween<double>(
      begin: 0,
      end: pi * 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        setState(() => _isFront = !_isFront);
      }
    });
  }

  void _switchLanguage() {
    final currentIndex = widget.languages.indexWhere(
      (lang) => lang.code == selectedLanguage.code,
    );
    final nextIndex = (currentIndex + 1) % widget.languages.length;
    final nextLang = widget.languages[nextIndex];

    _controller.forward();
    setState(() => selectedLanguage = nextLang);
    widget.onChanged(nextLang);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: _switchLanguage,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double angle = _flipAnimation.value;
          if (!_isFront) angle = angle - pi;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle)
              ..scale(_scaleAnimation.value),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedLanguage.flagEmoji,
                    key: ValueKey(selectedLanguage.code),
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  SizedBox(width: 6.w),
                  Transform.rotate(
                    angle: _iconRotation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? Colors.yellow.shade600
                            : Colors.blueAccent,
                      ),
                      padding: EdgeInsets.all(6.w),
                      child: Icon(
                        isDark ? AppIcons.language2 : AppIcons.language,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
