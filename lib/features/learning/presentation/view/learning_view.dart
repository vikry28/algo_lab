import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widget/app_bar.dart';
import '../provider/learning_provider.dart';
import '../widget/glass_search.dart';
import '../widget/learning_module_card.dart';

class LearningView extends StatelessWidget {
  const LearningView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final glass = Theme.of(context).extension<GlassTheme>()!;
    final provider = Provider.of<LearningProvider>(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.transparent,
      body: Stack(
        children: [
          // Background Gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Overall Glass Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
            child: Container(color: glass.color.withValues(alpha: 0.05)),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 5.h),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    backgroundColor: AppColors.transparent,
                    expandedHeight: 70.h,
                    flexibleSpace: GlassAppBar(
                      isDark: isDark,
                      onToggle: () => theme.toggleTheme(),
                      onLanguageToggle: () => theme.toggleLocale(),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  SliverToBoxAdapter(
                    child: Text(
                      AppLocalizations.of(context).translate('learning_title'),
                      style: AppTypography.h1.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontSize: 28.sp,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).translate('learning_subtitle'),
                      style: AppTypography.body.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 24.h)),

                  // Search
                  SliverToBoxAdapter(child: GlassSearchField(isDark: isDark)),
                  SliverToBoxAdapter(child: SizedBox(height: 24.h)),

                  // Filter Chips
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: List.generate(provider.filters.length, (
                          index,
                        ) {
                          final isSelected =
                              provider.selectedFilterIndex == index;
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: InkWell(
                              onTap: () => provider.setFilter(index),
                              borderRadius: BorderRadius.circular(20),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                            ? Colors.white.withValues(
                                                alpha: 0.05,
                                              )
                                            : Colors.black.withValues(
                                                alpha: 0.05,
                                              )),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark
                                              ? Colors.white.withValues(
                                                  alpha: 0.1,
                                                )
                                              : Colors.black.withValues(
                                                  alpha: 0.1,
                                                )),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    if (isSelected && index != 0) ...[
                                      Icon(
                                        // Simple mapping for icons based on index/text
                                        _getFilterIcon(provider.filters[index]),
                                        size: 16.sp,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 8.w),
                                    ],
                                    Text(
                                      AppLocalizations.of(context).translate(
                                        'category_${provider.filters[index]}',
                                      ),
                                      style: AppTypography.body.copyWith(
                                        color: isSelected
                                            ? Colors.black
                                            : (isDark
                                                  ? Colors.white70
                                                  : Colors.black54),
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 32.h)),

                  // "Modul Populer" Header
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withValues(alpha: 0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          AppLocalizations.of(
                            context,
                          ).translate('popular_modules'),
                          style: AppTypography.h2.copyWith(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // Modules List
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = provider.filteredModules[index];
                      // Determine if locked
                      final isLocked = provider.isLocked(item.id);

                      return LearningModuleCard(
                        item: item,
                        progress: provider.getProgress(item.id),
                        icon: provider.getIcon(item.id),
                        iconColor: provider.getColor(item.id),
                        isLocked: isLocked,
                        onTap: () async {
                          final title = AppLocalizations.of(
                            context,
                          ).translate(item.title);

                          await context.push(
                            '/learn/${item.id}?title=${Uri.encodeComponent(title)}',
                          );

                          // Refresh progress after returning
                          provider.refreshProgress();
                        },
                      );
                    }, childCount: provider.filteredModules.length),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFilterIcon(String filter) {
    // Check known filter keys
    switch (filter) {
      case 'sorting':
        return AppIcons.selection;
      case 'graph':
        return AppIcons.graph;
      case 'search':
        return AppIcons.search;
      case 'cryptography':
        return AppIcons.rsa;
      case 'tree':
        return AppIcons.astar;
      default:
        return AppIcons.learn;
    }
  }
}
