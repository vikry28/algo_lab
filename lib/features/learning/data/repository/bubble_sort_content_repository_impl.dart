import '../../domain/entities/bubble_sort_content_entity.dart';
import '../../domain/repository/bubble_sort_content_repository.dart';
import '../datasources/bubble_sort_content_datasource.dart';

class BubbleSortContentRepositoryImpl implements BubbleSortContentRepository {
  final BubbleSortContentDataSource dataSource;

  BubbleSortContentRepositoryImpl(this.dataSource);

  @override
  BubbleSortContentEntity getBubbleSortContent({
    required String summaryText,
    required String understandingText,
    required List<String> algorithmSteps,
  }) {
    final model = dataSource.getBubbleSortContent(
      summaryText: summaryText,
      understandingText: understandingText,
      algorithmSteps: algorithmSteps,
    );
    return model.toEntity();
  }
}
