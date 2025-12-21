import 'dart:ui';
import 'package:algo_lab/core/constants/app_icons.dart';
import 'package:algo_lab/core/constants/app_typography.dart';
import 'package:algo_lab/core/constants/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../domain/entities/algorithm_entity.dart';
import '../provider/home_provider.dart';

class AlgoBottomSheet extends StatefulWidget {
  final bool isDark;
  final GlassTheme glass;

  const AlgoBottomSheet({super.key, required this.isDark, required this.glass});

  @override
  State<AlgoBottomSheet> createState() => _AlgoBottomSheetState();
}

class _AlgoBottomSheetState extends State<AlgoBottomSheet> {
  late PageController _pageController;
  late TextEditingController _searchController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.65, initialPage: 0);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final glass = widget.glass;

    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.95,
      minChildSize: 0.55,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          child: Stack(
            children: [
              // 1. Background
              _buildBackground(isDark),

              // 2. Glass Effect
              _buildGlassLayer(glass),

              // 3. Content
              Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  final algorithms = provider.filteredAlgorithms;

                  if (algorithms.isEmpty && provider.algorithms.isNotEmpty) {
                    return _buildNoResults(textSecondary);
                  }
                  if (algorithms.isEmpty) return const SizedBox();

                  return ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(height: 12.h),
                      _buildGripHandle(textSecondary),
                      SizedBox(height: 20.h),
                      _buildTitleRow(context, textPrimary),
                      SizedBox(height: 24.h),
                      _buildSearchAndFilter(
                        context,
                        isDark,
                        textPrimary,
                        textSecondary,
                        provider,
                      ),
                      SizedBox(height: 20.h),
                      _buildCategories(
                        context,
                        isDark,
                        textPrimary,
                        textSecondary,
                        provider,
                      ),
                      SizedBox(height: 15.h),
                      _buildCarousel(algorithms, isDark, provider),
                      SizedBox(height: 10.h),
                      _buildActionButtons(context),
                      SizedBox(height: 10.h),
                      _buildFooter(textSecondary),
                      SizedBox(
                        height: 20.h + MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground(bool isDark) {
    return AnimatedContainer(
      duration: AppConstants.animationMedium,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildGlassLayer(GlassTheme glass) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
      child: Container(
        decoration: BoxDecoration(
          color: glass.color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          border: Border(
            top: BorderSide(color: glass.border, width: glass.borderWidth),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResults(Color textSecondary) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.h),
        child: Text(
          'No algorithms found',
          style: AppTypography.body.copyWith(color: textSecondary),
        ),
      ),
    );
  }

  Widget _buildGripHandle(Color textSecondary) {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: textSecondary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context, Color textPrimary) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.translate('bottom_sheet_title_1'),
                style: AppTypography.h2.copyWith(
                  fontSize: 18.sp,
                  color: textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                l10n.translate('bottom_sheet_title_2'),
                style: AppTypography.h2.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: textPrimary.withValues(alpha: 0.05),
              ),
              child: Icon(
                Icons.close_rounded,
                color: textPrimary.withValues(alpha: 0.5),
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
    HomeProvider provider,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBackground[1]
                    : Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: textPrimary.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: textSecondary, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: provider.updateSearchQuery,
                      style: AppTypography.body.copyWith(
                        color: textPrimary,
                        fontSize: 14.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        ).translate('bottom_sheet_search'),
                        hintStyle: AppTypography.body.copyWith(
                          color: textSecondary.withValues(alpha: 0.5),
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            height: 48.h,
            width: 48.h,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground[1]
                  : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: textPrimary.withValues(alpha: 0.05)),
            ),
            child: Icon(Icons.tune_rounded, color: textSecondary, size: 20.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
    HomeProvider provider,
  ) {
    final l10n = AppLocalizations.of(context);
    final categories = ['all', 'sorting', 'graph', 'search', 'tree'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: categories.map((cat) {
          final isSelected = provider.selectedCategory == cat;
          return _buildCategoryChip(
            l10n.translate('category_$cat'),
            isSelected,
            isDark,
            textPrimary,
            textSecondary,
            () => provider.selectCategory(cat),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCarousel(
    List<AlgorithmEntity> algorithms,
    bool isDark,
    HomeProvider provider,
  ) {
    return SizedBox(
      height: 380.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: algorithms.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          final algoItem = algorithms[index];
          final isSelected = index == _currentIndex;

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double scale = 1.0;
              if (_pageController.position.haveDimensions) {
                double page = _pageController.page!;
                scale = (1 - ((page - index).abs() * 0.25)).clamp(0.75, 1.0);
              } else {
                scale = isSelected ? 1.0 : 0.75;
              }

              final langCode = Localizations.localeOf(context).languageCode;
              final t = AppLocalizations.of(context);
              final globalIndex = provider.algorithms.indexOf(algoItem);

              return Center(
                child: Transform.scale(
                  scale: scale,
                  child: GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        GoRouter.of(context).push('/algorithm/$globalIndex');
                      } else {
                        _pageController.animateToPage(
                          index,
                          duration: AppConstants.animationMedium,
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: _AlgoCard(
                      title: algoItem.titleKey.isNotEmpty
                          ? t.translate(algoItem.titleKey)
                          : algoItem.getTitle(langCode),
                      description: algoItem.descriptionKey.isNotEmpty
                          ? t.translate(algoItem.descriptionKey)
                          : algoItem.getDescription(langCode),
                      icon: AppIcons.getIcon(algoItem.icon),
                      color: Color(int.parse(algoItem.colorHex, radix: 16)),
                      isSelected: isSelected,
                      isDark: isDark,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.read<HomeProvider>();
    final algorithms = provider.filteredAlgorithms;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF06B6D4)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              if (algorithms.isNotEmpty && _currentIndex < algorithms.length) {
                final globalIndex = provider.algorithms.indexOf(
                  algorithms[_currentIndex],
                );
                GoRouter.of(context).push('/algorithm/$globalIndex');
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.translate('bottom_sheet_start'),
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(Color textSecondary) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Text(
        l10n.translate('bottom_sheet_detail'),
        style: AppTypography.bodySmall.copyWith(
          color: textSecondary.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    bool isSelected,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : textPrimary.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isSelected ? Colors.white : textSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _AlgoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final bool isDark;

  const _AlgoCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassTheme>()!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 250.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isSelected ? color.withValues(alpha: 0.5) : glass.border,
          width: isSelected ? 1.5 : glass.borderWidth,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 25.r,
              spreadRadius: -4,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isSelected ? 80.w : 52.w,
            height: isSelected ? 80.h : 52.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, size: isSelected ? 36.sp : 26.sp, color: color),
          ),
          SizedBox(height: 18.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontSize: isSelected ? 18.sp : 15.sp,
            ),
          ),
          if (isSelected) ...[
            SizedBox(height: 8.h),
            Text(
              description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                fontSize: 12.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
