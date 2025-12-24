import 'package:algo_lab/features/sorting_lab/domain/entities/array_item.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/bubble_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/insertion_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/merge_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/quick_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/selection_sort_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SelectionSortUseCase', () {
    late SelectionSortUsecase usecase;

    setUp(() {
      usecase = SelectionSortUsecase();
    });

    test('should sort list correctly', () async {
      final input = [
        ArrayItem(value: 5),
        ArrayItem(value: 3),
        ArrayItem(value: 1),
        ArrayItem(value: 4),
        ArrayItem(value: 2),
      ];

      final stream = usecase.execute(input, stepDelay: Duration.zero);
      final steps = await stream.toList();

      // Check last step is done
      expect(steps.last.type, StepType.done);

      // Check result
      final sortedSnapshot = steps.last.snapshot.map((e) => e.value).toList();
      expect(sortedSnapshot, [1, 2, 3, 4, 5]);
    });
  });

  group('InsertionSortUseCase', () {
    late InsertionSortUsecase usecase;

    setUp(() {
      usecase = InsertionSortUsecase();
    });

    test('should sort list correctly', () async {
      final input = [
        ArrayItem(value: 5),
        ArrayItem(value: 1),
        ArrayItem(value: 4),
        ArrayItem(value: 2),
        ArrayItem(value: 8),
      ];

      final stream = usecase.execute(input, stepDelay: Duration.zero);
      final steps = await stream.toList();

      expect(steps.last.type, StepType.done);
      final sortedSnapshot = steps.last.snapshot.map((e) => e.value).toList();
      expect(sortedSnapshot, [1, 2, 4, 5, 8]);
    });

    test('should handle already sorted list', () async {
      final input = [
        ArrayItem(value: 1),
        ArrayItem(value: 2),
        ArrayItem(value: 3),
      ];

      final stream = usecase.execute(input, stepDelay: Duration.zero);
      final steps = await stream.toList();

      expect(steps.last.type, StepType.done);
      final sortedSnapshot = steps.last.snapshot.map((e) => e.value).toList();
      expect(sortedSnapshot, [1, 2, 3]);
    });
  });

  group('BubbleSortUseCase', () {
    late BubbleSortUsecase usecase;

    setUp(() {
      usecase = BubbleSortUsecase();
    });

    test('should sort list correctly', () async {
      final input = [
        ArrayItem(value: 5),
        ArrayItem(value: 3),
        ArrayItem(value: 1),
        ArrayItem(value: 4),
        ArrayItem(value: 2),
      ];

      final stream = usecase.execute(input, stepDelay: Duration.zero);
      final steps = await stream.toList();

      expect(steps.last.type, StepType.done);
      final sortedSnapshot = steps.last.snapshot.map((e) => e.value).toList();
      expect(sortedSnapshot, [1, 2, 3, 4, 5]);
    });
  });

  group('MergeSortUseCase', () {
    late MergeSortUsecase usecase;

    setUp(() {
      usecase = MergeSortUsecase();
    });

    test('should sort list correctly', () async {
      final input = [
        ArrayItem(value: 5),
        ArrayItem(value: 1),
        ArrayItem(value: 4),
        ArrayItem(value: 2),
        ArrayItem(value: 8),
      ];

      final stream = usecase.execute(input, stepDelay: Duration.zero);
      final steps = await stream.toList();

      expect(steps.last.type, StepType.done);
      final sortedSnapshot = steps.last.snapshot.map((e) => e.value).toList();
      expect(sortedSnapshot, [1, 2, 4, 5, 8]);
    });
  });

  group('QuickSortUseCase', () {
    late QuickSortUsecase usecase;

    setUp(() {
      usecase = QuickSortUsecase();
    });

    test('should sort list correctly', () async {
      final input = [
        ArrayItem(value: 10),
        ArrayItem(value: 7),
        ArrayItem(value: 8),
        ArrayItem(value: 9),
        ArrayItem(value: 1),
        ArrayItem(value: 5),
      ];

      final stream = usecase.execute(input, stepDelay: Duration.zero);
      final steps = await stream.toList();

      expect(steps.last.type, StepType.done);
      final sortedSnapshot = steps.last.snapshot.map((e) => e.value).toList();
      expect(sortedSnapshot, [1, 5, 7, 8, 9, 10]);
    });
  });
}
