import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../features/home/presentation/provider/home_provider.dart';
import '../../features/learning/presentation/provider/learning_provider.dart';
import '../../features/sorting_lab/presentation/provider/sorting_provider.dart';
import '../../features/learning/presentation/provider/universal_algorithm_provider.dart';
import '../../features/onboarding/presentation/provider/onboarding_provider.dart';
import '../../features/splash/presentation/provider/splash_provider.dart';
import '../../features/profile/presentation/provider/achievement_provider.dart';
import '../../features/profile/presentation/provider/profile_provider.dart';
import '../../features/pathfinding/presentation/provider/pathfinding_provider.dart';
import '../../features/cryptography_lab/presentation/provider/rsa_provider.dart';
import '../theme/theme_provider.dart';
import 'service_locator.dart';

/// Factory untuk membuat Provider instances
/// Mengikuti prinsip Dependency Injection dengan Service Locator
class ProviderFactory {
  static List<SingleChildWidget> providers() {
    return [
      // ========== THEME PROVIDER ==========
      ChangeNotifierProvider(create: (_) => ThemeProvider()),

      // ========== SPLASH PROVIDER ==========
      ChangeNotifierProvider(
        create: (_) => SplashProvider(
          checkOnboardingStatusUseCase: sl(),
          authService: sl(),
          getProfileUseCase: sl(),
        ),
      ),

      // ========== ONBOARDING PROVIDER ==========
      ChangeNotifierProvider(
        create: (_) => OnboardingProvider(
          completeOnboardingUseCase: sl(),
          authService: sl(),
        ),
      ),

      // ========== HOME PROVIDER ==========
      ChangeNotifierProvider(
        create: (_) =>
            HomeProvider(getAlgorithmsUseCase: sl())..fetchAlgorithms(),
      ),

      // ========== LEARNING PROVIDER ==========
      ChangeNotifierProvider(
        create: (_) =>
            LearningProvider(getLearningItems: sl())..loadLearningItems(),
      ),

      // ========== SORTING PROVIDER ==========
      ChangeNotifierProvider(
        create: (_) => SortingProvider(
          bubble: sl(),
          selection: sl(),
          insertion: sl(),
          merge: sl(),
          quick: sl(),
          logger: sl(),
        ),
      ),

      // ========== UNIVERSAL ALGORITHM PROVIDER ==========
      ChangeNotifierProxyProvider<LearningProvider, UniversalAlgorithmProvider>(
        create: (context) => UniversalAlgorithmProvider(),
        update: (context, learning, previous) {
          if (previous == null) {
            return UniversalAlgorithmProvider()..setLearningProvider(learning);
          }
          return previous..setLearningProvider(learning);
        },
      ),

      // ========== PROFILE PROVIDER ==========
      ChangeNotifierProxyProvider<LearningProvider, ProfileProvider>(
        create: (_) => ProfileProvider(
          getProfileUseCase: sl(),
          watchProfileUseCase: sl(),
          updateProfileUseCase: sl(),
          authService: sl(),
          notificationService: sl(),
        ),
        update: (context, learning, previous) {
          if (previous == null) {
            return ProfileProvider(
              getProfileUseCase: sl(),
              watchProfileUseCase: sl(),
              updateProfileUseCase: sl(),
              authService: sl(),
              notificationService: sl(),
            )..setLearningProvider(learning);
          }
          return previous..setLearningProvider(learning);
        },
      ),

      // ========== ACHIEVEMENT PROVIDER ==========
      ChangeNotifierProxyProvider2<
        LearningProvider,
        ProfileProvider,
        AchievementProvider
      >(
        create: (context) => AchievementProvider(
          learningProvider: context.read<LearningProvider>(),
          profileProvider: context.read<ProfileProvider>(),
          getAchievementsUseCase: sl(),
          getBadgesUseCase: sl(),
        ),
        update: (context, learning, profile, previous) {
          if (previous == null) {
            return AchievementProvider(
              learningProvider: learning,
              profileProvider: profile,
              getAchievementsUseCase: sl(),
              getBadgesUseCase: sl(),
            );
          }
          return previous;
        },
      ),
      // ========== PATHFINDING PROVIDER ==========
      ChangeNotifierProvider(create: (_) => sl<PathfindingProvider>()),
      ChangeNotifierProvider(create: (_) => sl<RSAProvider>()),
      // ========== CRYPTOGRAPHY LAB PROVIDER ==========
    ];
  }
}
