// ignore_for_file: strict_top_level_inference

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/learning_category_entity.dart';
import '../provider/universal_algorithm_provider.dart';
import '../view/universal_algorithm_learning_view.dart';
import 'learning_chip.dart';

class GlassLearningCategoryTile extends StatefulWidget {
  final LearningCategoryEntity category;
  const GlassLearningCategoryTile({super.key, required this.category});

  @override
  State<GlassLearningCategoryTile> createState() =>
      _GlassLearningCategoryTileState();
}

class _GlassLearningCategoryTileState extends State<GlassLearningCategoryTile> {
  final bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.cardDark.withValues(alpha: 0.9)
              : AppColors.cardGlass.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white12
                : Colors.black12.withValues(alpha: 0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GlassAccordion(
          initiallyExpanded: _expanded,
          header: _buildHeader(isDark),
          content: _buildItems(context, isDark, loc),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Row(
        children: [
          Icon(
            getCategoryIcon(widget.category.id),
            size: 28.sp,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              widget.category.title,
              style: AppTypography.titleMedium.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItems(BuildContext context, bool isDark, AppLocalizations loc) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 18.h),
      child: Column(
        children: widget.category.items.map((item) {
          return Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => UniversalAlgorithmProvider(),
                      child: UniversalAlgorithmLearningView(
                        algorithmId: item.id,
                        title: item.title,
                      ),
                    ),
                  ),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                          colors: [
                            AppColors.gradientBlueStart.withValues(alpha: 0.85),
                            AppColors.gradientPurpleEnd.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [AppColors.cardGlass, Colors.grey.shade200],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIconBox(isDark),
                      SizedBox(width: 16.w),
                      Expanded(child: _buildItemContent(item, loc, isDark)),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIconBox(bool isDark) {
    return SizedBox(
      width: 48.w,
      height: 48.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox(),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.cardGlass.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.cardGlass.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            Center(
              child: Text(
                "∑",
                style: AppTypography.headlineMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 32.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemContent(item, AppLocalizations loc, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.translate(item.title),
          style: AppTypography.titleMedium.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          loc.translate(item.description),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: [
            if (item.hasCode)
              LearningChip(
                label: 'Teks',
                icon: AppIcons.description,
                isDark: isDark,
                color: AppColors.chipBlue,
              ),
            if (item.hasPlay)
              LearningChip(
                label: 'Video',
                icon: AppIcons.play,
                isDark: isDark,
                color: AppColors.chipPurple,
              ),
            if (item.hasLink)
              LearningChip(
                label: 'Eksternal',
                icon: AppIcons.externalLink,
                isDark: isDark,
                color: AppColors.chipTeal,
              ),
          ],
        ),
      ],
    );
  }
}

IconData getCategoryIcon(String categoryId) {
  switch (categoryId) {
    case 'sorting':
      return AppIcons.selection;
    case 'searching':
      return AppIcons.search;
    case 'graph':
      return AppIcons.graph;
    case 'crypto':
      return AppIcons.rsa;
    default:
      return AppIcons.learn;
  }
}

class GlassAccordion extends StatefulWidget {
  final Widget header;
  final Widget content;
  final bool initiallyExpanded;

  const GlassAccordion({
    super.key,
    required this.header,
    required this.content,
    this.initiallyExpanded = false,
  });

  @override
  State<GlassAccordion> createState() => _GlassAccordionState();
}

class _GlassAccordionState extends State<GlassAccordion>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _controller;
  late Animation<double> _sizeFactor;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _sizeFactor = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (_expanded) _controller.forward();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Column(
          children: [
            InkWell(onTap: _toggle, child: widget.header),
            SizeTransition(sizeFactor: _sizeFactor, child: widget.content),
          ],
        ),
      ),
    );
  }
}
