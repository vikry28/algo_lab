import 'package:algo_lab/features/sorting_lab/domain/entities/array_item.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/bubble_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/selection_sort_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SelectionSortUsecase selectionSortUsecase;

  setUp(() {
    selectionSortUsecase = SelectionSortUsecase();
  });

  group('SelectionSortUsecase - Basic Functionality', () {
    test('sorts an unsorted array correctly', () async {
      final input = [
        ArrayItem(value: 64, id: 0),
        ArrayItem(value: 25, id: 1),
        ArrayItem(value: 12, id: 2),
        ArrayItem(value: 22, id: 3),
        ArrayItem(value: 11, id: 4),
      ];

      final stream = selectionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.type, StepType.done);
      expect(lastStep.snapshot[0].value, 11);
      expect(lastStep.snapshot[1].value, 12);
      expect(lastStep.snapshot[2].value, 22);
      expect(lastStep.snapshot[3].value, 25);
      expect(lastStep.snapshot[4].value, 64);
    });

    test('handles already sorted array', () async {
      final input = [
        ArrayItem(value: 1, id: 0),
        ArrayItem(value: 2, id: 1),
        ArrayItem(value: 3, id: 2),
        ArrayItem(value: 4, id: 3),
      ];

      final stream = selectionSortUsecase.execute(
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
      expect(lastStep.snapshot[3].value, 4);
    });

    test('handles single element array', () async {
      final input = [ArrayItem(value: 99, id: 0)];

      final stream = selectionSortUsecase.execute(
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
      expect(lastStep.snapshot[0].value, 99);
    });

    test('handles empty array', () async {
      final input = <ArrayItem>[];

      final stream = selectionSortUsecase.execute(
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
        ArrayItem(value: 5, id: 0),
        ArrayItem(value: 2, id: 1),
        ArrayItem(value: 5, id: 2),
        ArrayItem(value: 1, id: 3),
      ];

      final stream = selectionSortUsecase.execute(
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
      expect(lastStep.snapshot[2].value, 5);
      expect(lastStep.snapshot[3].value, 5);
    });
  });

  group('SelectionSortUsecase - Step Types', () {
    test('emits compare and swap steps', () async {
      final input = [
        ArrayItem(value: 3, id: 0),
        ArrayItem(value: 1, id: 1),
        ArrayItem(value: 2, id: 2),
      ];

      final stream = selectionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      final steps = await stream.toList();

      expect(steps.any((s) => s.type == StepType.compare), true);
      expect(steps.any((s) => s.type == StepType.swap), true);
      expect(steps.last.type, StepType.done);
    });

    test('final step has indices -1, -1', () async {
      final input = [ArrayItem(value: 2, id: 0), ArrayItem(value: 1, id: 1)];

      final stream = selectionSortUsecase.execute(
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

  group('SelectionSortUsecase - Edge Cases', () {
    test('handles reverse sorted array', () async {
      final input = [
        ArrayItem(value: 9, id: 0),
        ArrayItem(value: 7, id: 1),
        ArrayItem(value: 5, id: 2),
        ArrayItem(value: 3, id: 3),
        ArrayItem(value: 1, id: 4),
      ];

      final stream = selectionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.snapshot[0].value, 1);
      expect(lastStep.snapshot[1].value, 3);
      expect(lastStep.snapshot[2].value, 5);
      expect(lastStep.snapshot[3].value, 7);
      expect(lastStep.snapshot[4].value, 9);
    });

    test('handles two element array', () async {
      final input = [ArrayItem(value: 10, id: 0), ArrayItem(value: 5, id: 1)];

      final stream = selectionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep!.snapshot[0].value, 5);
      expect(lastStep.snapshot[1].value, 10);
    });

    test('handles negative numbers', () async {
      final input = [
        ArrayItem(value: -5, id: 0),
        ArrayItem(value: 3, id: 1),
        ArrayItem(value: -10, id: 2),
        ArrayItem(value: 0, id: 3),
      ];

      final stream = selectionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep!.snapshot[0].value, -10);
      expect(lastStep.snapshot[1].value, -5);
      expect(lastStep.snapshot[2].value, 0);
      expect(lastStep.snapshot[3].value, 3);
    });
  });

  group('SelectionSortUsecase - Algorithm Correctness', () {
    test('minimum element is selected in each pass', () async {
      final input = [
        ArrayItem(value: 29, id: 0),
        ArrayItem(value: 10, id: 1),
        ArrayItem(value: 14, id: 2),
        ArrayItem(value: 37, id: 3),
      ];

      final stream = selectionSortUsecase.execute(
        input,
        stepDelay: Duration.zero,
      );

      final steps = await stream.toList();
      final swapSteps = steps.where((s) => s.type == StepType.swap).toList();

      // Selection sort should make n-1 swaps at most
      expect(swapSteps.length, lessThanOrEqualTo(input.length - 1));
    });
  });
}
