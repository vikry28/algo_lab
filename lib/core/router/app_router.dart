import 'package:algo_lab/features/cryptography_lab/presentation/view/rsa_lab_view.dart';
import 'package:algo_lab/features/graph_lab/presentation/view/graph_lab_view.dart';
import 'package:algo_lab/features/pathfinding/presentation/view/pathfinding_lab_view.dart';
import 'package:algo_lab/features/sorting_lab/presentation/view/sorting_lab_view.dart';
import 'package:algo_lab/features/home/presentation/view/home_view.dart';
import 'package:algo_lab/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:algo_lab/features/splash/presentation/view/splash_view.dart';
import 'package:algo_lab/features/learning/presentation/view/learning_view.dart';
import 'package:algo_lab/features/learning/presentation/view/universal_algorithm_learning_view.dart';
import 'package:algo_lab/features/learning/presentation/provider/universal_algorithm_provider.dart';
import 'package:algo_lab/features/home/presentation/widget/home_shell.dart';
import 'package:algo_lab/features/profile/presentation/view/profile_view.dart';
import 'package:algo_lab/features/profile/presentation/view/achievements_view.dart';
import 'package:algo_lab/features/profile/presentation/view/edit_profile_view.dart';
import 'package:algo_lab/features/profile/presentation/view/security_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/analytics_service.dart';
import '../di/service_locator.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter({GlobalKey<NavigatorState>? navigatorKey}) {
    router = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/',
      observers: [sl<AnalyticsService>().observer],
      redirect: (context, state) {
        final authService = sl<AuthService>();
        final isLoggedIn = authService.currentUser != null;
        final isGoingToSplash = state.uri.path == '/';
        final isGoingToOnboard = state.uri.path == '/onboard';

        if (!isLoggedIn && !isGoingToOnboard && !isGoingToSplash) {
          return '/onboard';
        }
        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => SplashView()),
        GoRoute(
          path: '/onboard',
          builder: (context, state) => OnboardingView(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return HomeShell(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeView(),
            ),
            GoRoute(
              path: '/learn',
              builder: (context, state) => LearningView(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileView(),
            ),
          ],
        ),
        GoRoute(
          path: '/profile/edit',
          builder: (context, state) => const EditProfileView(),
        ),
        GoRoute(
          path: '/profile/security',
          builder: (context, state) => const SecurityView(),
        ),
        GoRoute(
          path: '/algorithm/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            if (id <= 3) {
              return SortingLabView(index: id);
            }
            if (id == 4) {
              return const RSALabView();
            }
            if (id == 5) {
              return const PathfindingLabView();
            }
            if (id == 6) {
              return const GraphLabView();
            }
            // Fallback for RSA (4) or others
            return SortingLabView(index: 0);
          },
        ),
        GoRoute(
          path: '/achievements',
          builder: (context, state) => const AchievementsView(),
        ),
        GoRoute(
          path: '/learn/:algorithmId',
          builder: (context, state) {
            final algorithmId = state.pathParameters['algorithmId']!;
            final title = state.uri.queryParameters['title'] ?? '';
            return ChangeNotifierProvider(
              create: (_) => UniversalAlgorithmProvider(),
              child: UniversalAlgorithmLearningView(
                algorithmId: algorithmId,
                title: title,
              ),
            );
          },
        ),
      ],
    );
  }
}
