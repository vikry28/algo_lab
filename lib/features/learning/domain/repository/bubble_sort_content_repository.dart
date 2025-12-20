import '../../domain/entities/bubble_sort_content_entity.dart';

abstract class BubbleSortContentRepository {
  BubbleSortContentEntity getBubbleSortContent({
    required String summaryText,
    required String understandingText,
    required List<String> algorithmSteps,
  });
}
