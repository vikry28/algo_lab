import 'package:get_it/get_it.dart';
import '../../features/home/data/datasources/algorithm_local_datasource.dart';
import '../services/analytics_service.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import '../../features/home/data/repository/algorithm_repository_impl.dart';
import '../../features/home/domain/repository/algorithm_repository.dart';
import '../../features/home/domain/usecases/get_algorithms_usecase.dart';
import '../../features/learning/data/datasources/learning_remote_datasource.dart';
import '../../features/learning/data/repository/learning_repository_impl.dart';
import '../../features/learning/domain/repository/learning_repository.dart';
import '../../features/learning/domain/usecases/get_learning_items.dart';
import '../../features/sorting_lab/domain/usecases/bubble_sort_usecase.dart';
import '../../features/sorting_lab/domain/usecases/insertion_sort_usecase.dart';
import '../../features/sorting_lab/domain/usecases/merge_sort_usecase.dart';
import '../../features/sorting_lab/domain/usecases/quick_sort_usecase.dart';
import '../../features/sorting_lab/domain/usecases/selection_sort_usecase.dart';
import '../../features/sorting_lab/utils/sorting_logger.dart';
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/check_onboarding_status_usecase.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import '../../features/onboarding/domain/usecases/reset_onboarding_usecase.dart';
import '../../features/pathfinding/domain/usecases/astar_usecase.dart';
import '../../features/pathfinding/presentation/provider/pathfinding_provider.dart';
import '../../features/cryptography_lab/domain/usecases/rsa_usecase.dart';
import '../../features/cryptography_lab/presentation/provider/rsa_provider.dart';
import '../../features/graph_lab/domain/usecases/dijkstra_usecase.dart';
import '../../features/graph_lab/presentation/provider/graph_provider.dart';
import '../../features/profile/data/repository/profile_repository_impl.dart';
import '../../features/profile/domain/repository/profile_repository.dart';
import '../../features/profile/domain/usecases/profile_usecases.dart';
import '../../features/profile/data/repository/achievement_repository_impl.dart';
import '../../features/profile/domain/repository/achievement_repository.dart';
import '../../features/profile/domain/usecases/achievement_usecases.dart';

final sl = GetIt.instance;

/// Service Locator untuk Dependency Injection
/// Mengikuti prinsip Clean Architecture dengan layer separation
class ServiceLocator {
  static Future<void> init() async {
    // ========== CORE ==========
    sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
    sl.registerLazySingleton<AuthService>(() => AuthService());
    sl.registerLazySingleton<FirestoreService>(() => FirestoreService());
    sl.registerLazySingleton<NotificationService>(() => NotificationService());

    // ========== HOME FEATURE ==========
    // Data Sources
    sl.registerLazySingleton<AlgorithmLocalDataSource>(
      () => AlgorithmLocalDataSourceImpl(),
    );

    // Repositories
    sl.registerLazySingleton<AlgorithmRepository>(
      () => AlgorithmRepositoryImpl(localDataSource: sl()),
    );

    // Use Cases
    sl.registerLazySingleton(() => GetAlgorithmsUseCase(sl()));

    // ========== LEARNING FEATURE ==========
    // Data Sources
    sl.registerLazySingleton<LearningRemoteDataSource>(
      () => LearningRemoteDataSourceImpl(),
    );

    // Repositories
    sl.registerLazySingleton<LearningRepository>(
      () => LearningRepositoryImpl(remoteDataSource: sl()),
    );

    // Use Cases
    sl.registerLazySingleton(() => GetLearningItems(sl()));

    // ========== BUBBLE SORT FEATURE ==========
    // Use Cases
    sl.registerLazySingleton(() => BubbleSortUsecase());
    sl.registerLazySingleton(() => SelectionSortUsecase());
    sl.registerLazySingleton(() => InsertionSortUsecase());
    sl.registerLazySingleton(() => MergeSortUsecase());
    sl.registerLazySingleton(() => QuickSortUsecase());
    sl.registerLazySingleton(() => AStarUseCase());
    sl.registerLazySingleton(() => RSAUseCase());
    sl.registerLazySingleton(() => DijkstraUseCase());

    // PROVIDERS
    sl.registerFactory(() => PathfindingProvider());
    sl.registerFactory(() => RSAProvider());
    sl.registerFactory(() => GraphProvider());

    // Utils
    sl.registerLazySingleton(() => SortingLogger());

    // ========== ONBOARDING FEATURE ==========
    // Data Sources
    sl.registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(),
    );

    // Repositories
    sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(localDataSource: sl()),
    );

    // Use Cases
    sl.registerLazySingleton(() => CompleteOnboardingUseCase(sl()));
    sl.registerLazySingleton(() => ResetOnboardingUseCase(sl()));
    sl.registerLazySingleton(() => CheckOnboardingStatusUseCase(sl()));

    // ========== PROFILE FEATURE ==========
    // Repositories
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(firestoreService: sl()),
    );

    // Use Cases
    sl.registerLazySingleton(() => GetProfileUseCase(sl()));
    sl.registerLazySingleton(() => WatchProfileUseCase(sl()));
    sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

    // Achievements
    sl.registerLazySingleton<AchievementRepository>(
      () => AchievementRepositoryImpl(firestoreService: sl()),
    );
    sl.registerLazySingleton(() => GetAchievementsUseCase(sl()));
    sl.registerLazySingleton(() => GetBadgesUseCase(sl()));
    sl.registerLazySingleton(() => UnlockAchievementUseCase(sl()));
    sl.registerLazySingleton(() => UnlockBadgeUseCase(sl()));
  }
}
