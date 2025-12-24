import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_localizations.dart';
import '../widget/code_card.dart';
import '../widget/grid_background.dart';
import '../widget/onbard_page.dart';
import '../widget/rocket_card.dart';
import '../widget/sorting_visual.dart';
import '../provider/onboarding_provider.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  void initState() {
    super.initState();
    // Wrap in microtask to avoid build conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().setPage(0);
    });
  }

  Widget _buildPage(
    int pageIndex,
    OnboardingProvider provider,
    BuildContext context,
  ) {
    switch (pageIndex) {
      case 0:
        return OnboardPage(
          key: const ValueKey(0),
          index: 0,
          isActive: provider.currentIndex == 0,
          titleTop: AppLocalizations.of(
            context,
          ).translate("onboarding_step_1_header"),
          title: AppLocalizations.of(
            context,
          ).translate("onboarding_step_1_title"),
          body: AppLocalizations.of(
            context,
          ).translate("onboarding_step_1_body"),
          onNext: provider.nextPage,
          onBack: provider.previousPage,
          onSkip: provider.skipToLastPage,
          child: SortingVisualizer(),
        );
      case 1:
        return OnboardPage(
          key: const ValueKey(1),
          index: 1,
          isActive: provider.currentIndex == 1,
          titleTop: AppLocalizations.of(
            context,
          ).translate("onboarding_step_2_header"),
          title: AppLocalizations.of(
            context,
          ).translate("onboarding_step_2_title"),
          title2: AppLocalizations.of(
            context,
          ).translate("onboarding_step_2_subtitle"),
          body: "",
          onNext: provider.nextPage,
          onBack: provider.previousPage,
          onSkip: provider.skipToLastPage,
          child: CodeCard(),
        );
      default:
        return OnboardPage(
          key: const ValueKey(2),
          index: 2,
          isActive: provider.currentIndex == 2,
          titleTop: AppLocalizations.of(
            context,
          ).translate("onboarding_step_3_header"),
          title: AppLocalizations.of(
            context,
          ).translate("onboarding_step_3_title"),
          body: AppLocalizations.of(
            context,
          ).translate("onboarding_step_3_body"),
          onNext: provider.nextPage,
          onBack: provider.previousPage,
          onLogin: () async {
            final success = await provider.googleLogin(context);
            if (success && context.mounted) {
              context.go('/home');
            }
          },
          onQuickLogin: () async {
            final success = await provider.quickLogin(context);
            if (success && context.mounted) {
              context.go('/home');
            }
          },
          child: RocketCard(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              const GridBackground(),
              PageView.builder(
                controller: provider.pageController,
                itemCount: 3,
                onPageChanged: (index) => provider.setPage(index),
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: provider.pageController,
                    builder: (context, child) {
                      double scale = 1.0;
                      double opacity = 1.0;

                      if (provider.pageController.hasClients &&
                          provider.pageController.position.haveDimensions) {
                        final pageOffset =
                            provider.pageController.page ??
                            provider.pageController.initialPage.toDouble();
                        final diff = (pageOffset - index).abs();
                        scale = (1 - diff * 0.15).clamp(0.85, 1.0);
                        opacity = (1 - diff * 0.3).clamp(0.5, 1.0);
                      }

                      return Transform.scale(
                        scale: scale,
                        child: Opacity(opacity: opacity, child: child),
                      );
                    },
                    child: _buildPage(index, provider, context),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
