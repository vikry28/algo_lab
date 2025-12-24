import '../entities/bubble_sort_content_entity.dart';
import '../repository/bubble_sort_content_repository.dart';

class GetBubbleSortContent {
  final BubbleSortContentRepository repository;

  GetBubbleSortContent(this.repository);

  BubbleSortContentEntity call({
    required String summaryText,
    required String understandingText,
    required List<String> algorithmSteps,
  }) {
    return repository.getBubbleSortContent(
      summaryText: summaryText,
      understandingText: understandingText,
      algorithmSteps: algorithmSteps,
    );
  }
}
