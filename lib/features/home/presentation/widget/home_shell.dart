import 'dart:ui';
import 'package:algo_lab/core/constants/app_colors.dart';
import 'package:algo_lab/core/constants/app_icons.dart';
import 'package:algo_lab/core/theme/theme_extension.dart';
import 'package:algo_lab/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:algo_lab/features/profile/presentation/provider/achievement_provider.dart';
import 'package:algo_lab/features/profile/presentation/widget/badge_unlocked_dialog.dart';

import '../../../../core/constants/app_localizations.dart';

class HomeShell extends StatefulWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  AchievementProvider? _achievementProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newProvider = context.watch<AchievementProvider>();
    if (_achievementProvider != newProvider) {
      _achievementProvider?.removeListener(_onAchievementChanged);
      _achievementProvider = newProvider;
      _achievementProvider?.addListener(_onAchievementChanged);
    }
  }

  @override
  void dispose() {
    _achievementProvider?.removeListener(_onAchievementChanged);
    super.dispose();
  }

  void _onAchievementChanged() {
    final id = _achievementProvider?.lastUnlockedBadge;
    if (id == null) return;

    // Only show dialog if currently on Home tab
    if (_currentIndex != 0) return;

    final badge = _achievementProvider!.badges.firstWhere(
      (b) => b.id == id,
      orElse: () => _achievementProvider!.badges.first,
    );

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.1),
          barrierDismissible: false,
          builder: (c) => BadgeUnlockedDialog(badge: badge),
        );
        _achievementProvider?.clearLastUnlockedBadge();
      });
    }
  }

  int get _currentIndex {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/learn')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0; // default to home
  }

  void _onTap(int index) {
    if (_currentIndex == index) return;

    final routes = ['/home', '/learn', '/profile'];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassTheme>()!;
    final isDark = context.select((ThemeProvider t) => t.isDark);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(child: widget.child),
          _FloatingNavBar(
            currentIndex: _currentIndex,
            onTap: _onTap,
            glass: glass,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final GlassTheme glass;
  final bool isDark;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.glass,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20.h,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 300.w),
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
              child: Container(
                height: 64.h,
                decoration: BoxDecoration(
                  color: glass.color,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: glass.border.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavBarItem(
                      icon: AppIcons.home,
                      label: AppLocalizations.of(
                        context,
                      ).translate('menu_home'),
                      isActive: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                    _NavBarItem(
                      icon: AppIcons.learn,
                      label: AppLocalizations.of(
                        context,
                      ).translate('menu_learn'),
                      isActive: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                    _NavBarItem(
                      icon: AppIcons.profile,
                      label: AppLocalizations.of(
                        context,
                      ).translate('menu_profile'),
                      isActive: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isActive ? AppColors.primary : Colors.grey.shade500,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: isActive ? null : 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    isActive ? label : "",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
