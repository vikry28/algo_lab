import 'package:provider/provider.dart';
import '../../features/sorting_lab/domain/usecases/bubble_sort_usecase.dart';
import '../../features/sorting_lab/domain/usecases/insertion_sort_usecase.dart';
import '../../features/sorting_lab/domain/usecases/merge_sort_usecase.dart';
import '../../features/sorting_lab/domain/usecases/quick_sort_usecase.dart';
import '../../features/sorting_lab/domain/usecases/selection_sort_usecase.dart';
import '../../features/sorting_lab/presentation/provider/sorting_provider.dart';
import '../../features/sorting_lab/utils/sorting_logger.dart';
import '../../features/home/data/datasources/algorithm_local_datasource.dart';
import '../../features/home/data/repository/algorithm_repository_impl.dart';
import '../../features/home/domain/usecases/get_algorithms_usecase.dart';
import '../../features/home/presentation/provider/home_provider.dart';
import '../../features/learning/data/datasources/learning_remote_datasource.dart';
import '../../features/learning/data/repository/learning_repository_impl.dart';
import '../../features/learning/domain/usecases/get_learning_items.dart';
import '../../features/learning/presentation/provider/learning_provider.dart';
import '../../features/learning/presentation/provider/universal_algorithm_provider.dart';
import '../theme/theme_provider.dart';

class Injector {
  // ignore: strict_top_level_inference
  static providers() {
    // Theme
    final themeProvider = ThemeProvider();

    // Home Feature
    final localDataSource = AlgorithmLocalDataSourceImpl();
    final repository = AlgorithmRepositoryImpl(
      localDataSource: localDataSource,
    );
    final getAlgorithmsUseCase = GetAlgorithmsUseCase(repository);
    return [
      ChangeNotifierProvider(create: (_) => themeProvider),
      ChangeNotifierProvider(
        create: (_) =>
            HomeProvider(getAlgorithmsUseCase: getAlgorithmsUseCase)
              ..fetchAlgorithms(),
      ),
      ChangeNotifierProvider(
        create: (_) => LearningProvider(
          getLearningItems: GetLearningItems(
            LearningRepositoryImpl(
              remoteDataSource: LearningRemoteDataSourceImpl(),
            ),
          ),
        )..loadLearningItems(),
      ),
      ChangeNotifierProvider(
        create: (_) => SortingProvider(
          bubble: BubbleSortUsecase(),
          selection: SelectionSortUsecase(),
          insertion: InsertionSortUsecase(),
          merge: MergeSortUsecase(),
          quick: QuickSortUsecase(),
          logger: SortingLogger(),
        ),
      ),
      ChangeNotifierProvider(create: (_) => UniversalAlgorithmProvider()),
    ];
  }
}
