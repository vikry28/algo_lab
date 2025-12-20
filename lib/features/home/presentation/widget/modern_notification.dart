import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

enum ModernNotificationType { success, error, info }

class ModernNotification extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final ModernNotificationType type;

  const ModernNotification({
    super.key,
    required this.message,
    this.icon,
    this.iconColor,
    this.type = ModernNotificationType.success,
  });

  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    Color? iconColor,
    ModernNotificationType type = ModernNotificationType.success,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ModernNotificationWidget(
        message: message,
        icon: icon,
        iconColor: iconColor,
        type: type,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return _ModernContent(
      message: message,
      icon: icon,
      iconColor: iconColor,
      type: type,
    );
  }
}

class _ModernNotificationWidget extends StatefulWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final ModernNotificationType type;
  final VoidCallback onDismiss;

  const _ModernNotificationWidget({
    required this.message,
    this.icon,
    this.iconColor,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_ModernNotificationWidget> createState() =>
      _ModernNotificationWidgetState();
}

class _ModernNotificationWidgetState extends State<_ModernNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(opacity: _opacityAnimation.value, child: child),
              );
            },
            child: _ModernContent(
              message: widget.message,
              icon: widget.icon,
              iconColor: widget.iconColor,
              type: widget.type,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernContent extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final ModernNotificationType type;

  const _ModernContent({
    required this.message,
    this.icon,
    this.iconColor,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    IconData effectiveIcon;
    Color effectiveIconColor;
    List<Color> gradientColors;

    switch (type) {
      case ModernNotificationType.success:
        effectiveIcon = icon ?? Icons.check_circle_rounded;
        effectiveIconColor = iconColor ?? Colors.greenAccent;
        gradientColors = [
          AppColors.primary.withValues(alpha: 0.95),
          const Color(0xFF166534).withValues(alpha: 0.95), // Success dark green
        ];
        break;
      case ModernNotificationType.error:
        effectiveIcon = icon ?? Icons.error_outline_rounded;
        effectiveIconColor = iconColor ?? Colors.redAccent;
        gradientColors = [
          const Color(0xFF991B1B).withValues(alpha: 0.95), // Red
          const Color(0xFF7F1D1D).withValues(alpha: 0.95), // Dark Red
        ];
        break;
      case ModernNotificationType.info:
        effectiveIcon = icon ?? Icons.info_outline_rounded;
        effectiveIconColor = iconColor ?? Colors.blueAccent;
        gradientColors = [
          const Color(0xFF1E3A8A).withValues(alpha: 0.95),
          const Color(0xFF1E40AF).withValues(alpha: 0.95),
        ];
        break;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    effectiveIcon,
                    color: effectiveIconColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Flexible(
                  child: Text(
                    message,
                    style: AppTypography.titleMedium.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
