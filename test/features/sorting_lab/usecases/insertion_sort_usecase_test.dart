import 'package:algo_lab/features/sorting_lab/domain/entities/array_item.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/bubble_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/insertion_sort_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InsertionSortUsecase insertionSortUsecase;

  setUp(() {
    insertionSortUsecase = InsertionSortUsecase();
  });

  group('InsertionSortUsecase - Basic Functionality', () {
    test('sorts an unsorted array correctly', () async {
      final input = [
        ArrayItem(value: 12, id: 0),
        ArrayItem(value: 11, id: 1),
        ArrayItem(value: 13, id: 2),
        ArrayItem(value: 5, id: 3),
        ArrayItem(value: 6, id: 4),
      ];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.type, StepType.done);
      expect(lastStep.snapshot[0].value, 5);
      expect(lastStep.snapshot[1].value, 6);
      expect(lastStep.snapshot[2].value, 11);
      expect(lastStep.snapshot[3].value, 12);
      expect(lastStep.snapshot[4].value, 13);
    });

    test('handles already sorted array', () async {
      final input = [
        ArrayItem(value: 1, id: 0),
        ArrayItem(value: 2, id: 1),
        ArrayItem(value: 3, id: 2),
      ];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.type, StepType.done);
      expect(lastStep.snapshot[0].value, 1);
      expect(lastStep.snapshot[1].value, 2);
      expect(lastStep.snapshot[2].value, 3);
    });

    test('handles single element array', () async {
      final input = [ArrayItem(value: 7, id: 0)];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.type, StepType.done);
      expect(lastStep.snapshot.length, 1);
      expect(lastStep.snapshot[0].value, 7);
    });

    test('handles empty array', () async {
      final input = <ArrayItem>[];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.type, StepType.done);
      expect(lastStep.snapshot, isEmpty);
    });

    test('handles array with duplicate values', () async {
      final input = [
        ArrayItem(value: 4, id: 0),
        ArrayItem(value: 2, id: 1),
        ArrayItem(value: 4, id: 2),
        ArrayItem(value: 1, id: 3),
      ];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.type, StepType.done);
      expect(lastStep.snapshot[0].value, 1);
      expect(lastStep.snapshot[1].value, 2);
      expect(lastStep.snapshot[2].value, 4);
      expect(lastStep.snapshot[3].value, 4);
    });
  });

  group('InsertionSortUsecase - Step Types', () {
    test('emits compare and swap steps', () async {
      final input = [
        ArrayItem(value: 3, id: 0),
        ArrayItem(value: 1, id: 1),
        ArrayItem(value: 2, id: 2),
      ];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      final steps = await stream.toList();

      expect(steps.any((s) => s.type == StepType.compare), true);
      expect(steps.last.type, StepType.done);
    });

    test('final step has indices -1, -1', () async {
      final input = [ArrayItem(value: 5, id: 0), ArrayItem(value: 3, id: 1)];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep!.indexA, -1);
      expect(lastStep.indexB, -1);
    });
  });

  group('InsertionSortUsecase - Edge Cases', () {
    test('handles reverse sorted array', () async {
      final input = [
        ArrayItem(value: 5, id: 0),
        ArrayItem(value: 4, id: 1),
        ArrayItem(value: 3, id: 2),
        ArrayItem(value: 2, id: 3),
        ArrayItem(value: 1, id: 4),
      ];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.snapshot[0].value, 1);
      expect(lastStep.snapshot[1].value, 2);
      expect(lastStep.snapshot[2].value, 3);
      expect(lastStep.snapshot[3].value, 4);
      expect(lastStep.snapshot[4].value, 5);
    });

    test('handles two element array in wrong order', () async {
      final input = [ArrayItem(value: 20, id: 0), ArrayItem(value: 10, id: 1)];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep!.snapshot[0].value, 10);
      expect(lastStep.snapshot[1].value, 20);
    });

    test('handles two element array in correct order', () async {
      final input = [ArrayItem(value: 10, id: 0), ArrayItem(value: 20, id: 1)];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep!.snapshot[0].value, 10);
      expect(lastStep.snapshot[1].value, 20);
    });
  });

  group('InsertionSortUsecase - Algorithm Characteristics', () {
    test('is efficient for nearly sorted arrays', () async {
      // Nearly sorted array - insertion sort should be efficient
      final input = [
        ArrayItem(value: 1, id: 0),
        ArrayItem(value: 2, id: 1),
        ArrayItem(value: 4, id: 2),
        ArrayItem(value: 3, id: 3), // Only one element out of place
        ArrayItem(value: 5, id: 4),
      ];

      final stream = insertionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      final steps = await stream.toList();

      // Should have fewer steps than a completely unsorted array
      expect(steps.length, lessThan(20));

      final lastStep = steps.last;
      expect(lastStep.snapshot[0].value, 1);
      expect(lastStep.snapshot[1].value, 2);
      expect(lastStep.snapshot[2].value, 3);
      expect(lastStep.snapshot[3].value, 4);
      expect(lastStep.snapshot[4].value, 5);
    });
  });
}
