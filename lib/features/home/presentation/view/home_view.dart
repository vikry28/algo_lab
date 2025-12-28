import 'package:algo_lab/core/theme/theme_extension.dart';
import 'package:algo_lab/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../provider/home_provider.dart';
import '../widget/algo_bottom_sheet.dart';
import '../widget/algo_card.dart';
import '../widget/app_bar.dart';
import '../widget/header_section.dart';
import '../widget/last_learn_card.dart';
import '../widget/summary_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select((ThemeProvider t) => t.isDark);
    final glass = Theme.of(context).extension<GlassTheme>()!;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.transparent,
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

          Container(color: glass.color.withValues(alpha: 0.03)),

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
                      onToggle: () {
                        context.read<ThemeProvider>().toggleTheme();
                      },
                      onLanguageToggle: () {
                        context.read<ThemeProvider>().toggleLocale();
                      },
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                  SliverToBoxAdapter(
                    child: Text(
                      AppLocalizations.of(context).translate('home_title'),
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
                      AppLocalizations.of(context).translate('home_subtitle'),
                      style: AppTypography.body.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                  SliverToBoxAdapter(child: SummarySection(isDark: isDark)),

                  SliverToBoxAdapter(child: SizedBox(height: 26.h)),

                  SliverToBoxAdapter(child: LastLearnedCard(isDark: isDark)),

                  SliverToBoxAdapter(child: SizedBox(height: 26.h)),

                  SliverToBoxAdapter(
                    child: HeaderSection(
                      isDark: isDark,
                      title: AppLocalizations.of(
                        context,
                      ).translate('catalog_title'),
                      onTap: () {
                        openAlgoBottomSheet(context, isDark, glass);
                      },
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 28.h)),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 150.h),
                    sliver: Consumer<HomeProvider>(
                      builder: (context, provider, child) {
                        final fullList = provider.algorithms;
                        final displayList = fullList.take(4).toList();
                        if (provider.loading) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 50.h),
                                child: CircularProgressIndicator(
                                  color: isDark
                                      ? AppColors.chipPurple
                                      : AppColors.chipBlue,
                                ),
                              ),
                            ),
                          );
                        }

                        if (displayList.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 50.h),
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  ).translate('no_algorithms'),
                                  style: AppTypography.body.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        final langCode = Localizations.localeOf(
                          context,
                        ).languageCode;
                        return SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 18,
                                crossAxisSpacing: 18,
                                childAspectRatio: 0.88,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final algo = displayList[index];
                            final t = AppLocalizations.of(context);

                            final globalIndex = provider.algorithms.indexOf(
                              algo,
                            );

                            return TiltAlgoCard(
                              title: algo.titleKey.isNotEmpty
                                  ? t.translate(algo.titleKey)
                                  : algo.getTitle(langCode),
                              subtitle: algo.descriptionKey.isNotEmpty
                                  ? t.translate(algo.descriptionKey)
                                  : algo.getDescription(langCode),
                              icon: AppIcons.getIcon(algo.icon),
                              color: Color(int.parse(algo.colorHex, radix: 16)),
                              isDark: isDark,
                              index: globalIndex,
                            );
                          }, childCount: displayList.length),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openAlgoBottomSheet(
    BuildContext context,
    bool isDark,
    GlassTheme glass,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => AlgoBottomSheet(isDark: isDark, glass: glass),
    );
  }
}
