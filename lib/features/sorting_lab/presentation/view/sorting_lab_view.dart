import 'dart:math';
import 'dart:ui';
import 'package:algo_lab/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widget/app_bar.dart';
import '../../domain/entities/array_item.dart';
import '../../data/datasources/sorting_local_datasource.dart';
import '../provider/sorting_provider.dart';
import '../widget/specialized_visualizers.dart';
import '../../../home/presentation/widget/modern_confirm_dialog.dart';
import '../../data/models/enum.dart';

class SortingLabView extends StatefulWidget {
  const SortingLabView({super.key, required this.index});
  final int index;

  @override
  State<SortingLabView> createState() => _SortingLabViewState();
}

class _SortingLabViewState extends State<SortingLabView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _lastStepCounter = 0;
  late SortingProvider provider;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index >= 0 && widget.index < SortingAlgorithm.values.length) {
        provider.changeAlgorithm(SortingAlgorithm.values[widget.index]);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<SortingProvider>(context, listen: false);

    if (provider.items.isEmpty) {
      Future.microtask(() {
        if (mounted) {
          provider.generateForAlgorithm(provider.selectedAlgorithm);
        }
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  double _maxValue() {
    if (provider.items.isEmpty) return 1;
    return provider.items.map((e) => e.value).reduce(max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final glass = Theme.of(context).extension<GlassTheme>()!;
    final t = AppLocalizations.of(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: AppConstants.animationMedium,
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
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
            child: Container(color: glass.color.withValues(alpha: 0.03)),
          ),
          SafeArea(
            child: Consumer<SortingProvider>(
              builder: (context, prov, _) {
                if (prov.stepCounter != _lastStepCounter) {
                  _lastStepCounter = prov.stepCounter;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _animController.forward(from: 0.0);
                  });
                }

                final maxVal = _maxValue();
                final textColor = isDark ? Colors.white : Colors.black87;
                final caseStudy = prov.currentCaseStudy;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 5.h,
                  ),
                  child: Stack(
                    children: [
                      CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            pinned: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            expandedHeight: 70.h,
                            flexibleSpace: GlassAppBar(
                              title: t.translate(caseStudy.titleKey),
                              autoBack: true,
                              isDark: isDark,
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                          SliverToBoxAdapter(
                            child: _algoSelector(prov, textColor, t),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                          // Case Study Card
                          SliverToBoxAdapter(
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    caseStudy.icon,
                                    style: TextStyle(fontSize: 24.sp),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${t.translate('lab_case_study')}: ${t.translate(caseStudy.titleKey).toUpperCase()}",
                                          style: AppTypography.labelSmall
                                              .copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          t.translate(caseStudy.descriptionKey),
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                color: textColor.withValues(
                                                  alpha: 0.7,
                                                ),
                                                fontSize: 11.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SliverToBoxAdapter(child: SizedBox(height: 22.h)),
                          SliverToBoxAdapter(
                            child: Text(
                              t.translate('lab_active_visualization'),
                              style: AppTypography.body.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: textColor.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                          // The Specialized Visualizer
                          SliverToBoxAdapter(
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: 220.h,
                                maxHeight: 350.h,
                              ),
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: glass.color,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(color: glass.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: SpecializedVisualizer(
                                  algorithm: prov.selectedAlgorithm,
                                  items: prov.items,
                                  maxVal: maxVal,
                                  highlightA: prov.highlightA,
                                  highlightB: prov.highlightB,
                                  highlightType: prov.highlightType,
                                  compareColor: prov.compareColor,
                                  swapColor: prov.swapColor,
                                ),
                              ),
                            ),
                          ),

                          SliverToBoxAdapter(child: SizedBox(height: 18.h)),
                          SliverToBoxAdapter(
                            child: Row(
                              children: [
                                metricWidget(
                                  t.translate("comparisons"),
                                  prov.comparisons.toString(),
                                  Colors.cyanAccent,
                                  glass,
                                ),
                                SizedBox(width: 10.w),
                                metricWidget(
                                  t.translate("swaps"),
                                  prov.swaps.toString(),
                                  Colors.purpleAccent,
                                  glass,
                                ),
                                SizedBox(width: 10.w),
                                metricWidget(
                                  caseStudy.metricName,
                                  "${(100 - (prov.comparisons * 0.5)).clamp(0, 100).toStringAsFixed(1)}%",
                                  Colors.amberAccent,
                                  glass,
                                ),
                              ],
                            ),
                          ),

                          SliverToBoxAdapter(child: SizedBox(height: 22.h)),
                          SliverToBoxAdapter(
                            child: _speedSlider(prov, textColor, glass, t),
                          ),

                          SliverToBoxAdapter(child: SizedBox(height: 22.h)),
                          SliverToBoxAdapter(
                            child: Row(
                              children: [
                                controlButton(
                                  context: context,
                                  icon: Icons.play_arrow,
                                  label: t.translate('lab_run'),
                                  color: Colors.greenAccent,
                                  onTap: prov.isRunning
                                      ? null
                                      : () => prov.startSelected(),
                                ),
                                SizedBox(width: 12.w),
                                controlButton(
                                  context: context,
                                  icon: Icons.refresh,
                                  label: t.translate('lab_shuffle'),
                                  color: Colors.pinkAccent,
                                  onTap: () {
                                    final rnd = SortingLocalDatasource()
                                        .generateRandom(length: 10, max: 100);
                                    final newItems = List.generate(
                                      rnd.length,
                                      (i) => ArrayItem(value: rnd[i], id: i),
                                    );
                                    prov.generateInitial(newItems);
                                  },
                                ),
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 42.h)),
                        ],
                      ),
                      if (prov.isFinished) _buildResultOverlay(prov, t, glass),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultOverlay(
    SortingProvider prov,
    AppLocalizations t,
    GlassTheme glass,
  ) {
    return ModernConfirmDialog(
      title: t.translate('lab_simulation_done'),
      message: t
          .translate('lab_result_msg')
          .replaceFirst('{swaps}', prov.swaps.toString())
          .replaceFirst('{comparisons}', prov.comparisons.toString()),
      icon: Icons.auto_awesome,
      confirmLabel: t.translate('lab_shuffle'),
      cancelLabel: t.translate('common_cancel'),
      closeOnConfirm: false,
      closeOnCancel: false,
      onConfirm: () => prov.generateForAlgorithm(prov.selectedAlgorithm),
      onCancel: () => prov.generateInitial(prov.items),
    );
  }

  Widget _algoSelector(
    SortingProvider prov,
    Color textColor,
    AppLocalizations t,
  ) {
    final glass = Theme.of(context).extension<GlassTheme>()!;
    final algorithms = [
      {
        "name": "Bubble",
        "algo": SortingAlgorithm.bubble,
        "key": "bubble_sort_title",
      },
      {
        "name": "Selection",
        "algo": SortingAlgorithm.selection,
        "key": "selection_sort_title",
      },
      {
        "name": "Insertion",
        "algo": SortingAlgorithm.insertion,
        "key": "insertion_sort_title",
      },
      {
        "name": "Quick",
        "algo": SortingAlgorithm.quick,
        "key": "quick_sort_title",
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: glass.border),
      ),
      child: Row(
        children: algorithms.map((tab) {
          final bool active = prov.selectedAlgorithm == tab["algo"];
          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  prov.changeAlgorithm(tab["algo"] as SortingAlgorithm),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    t.translate(tab["key"] as String).split(' ').first,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: active
                          ? Colors.white
                          : textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _speedSlider(
    SortingProvider prov,
    Color textColor,
    GlassTheme glass,
    AppLocalizations t,
  ) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.translate('lab_speed'),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                "${(1050 - prov.stepDelay.inMilliseconds)}ms",
                style: TextStyle(fontSize: 11.sp, color: AppColors.primary),
              ),
            ],
          ),
          Slider(
            value: prov.stepDelay.inMilliseconds.toDouble(),
            min: 50,
            max: 1000,
            activeColor: AppColors.primary,
            onChanged: (v) =>
                prov.setStepDelay(Duration(milliseconds: v.round())),
          ),
        ],
      ),
    );
  }

  Widget metricWidget(
    String title,
    String value,
    Color color,
    GlassTheme glass,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: glass.color,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: glass.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget controlButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Opacity(
          opacity: onTap == null ? 0.4 : 1.0,
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
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
