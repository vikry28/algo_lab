import 'package:algo_lab/features/sorting_lab/domain/entities/array_item.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/bubble_sort_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BubbleSortUsecase bubbleSortUsecase;

  setUp(() {
    bubbleSortUsecase = BubbleSortUsecase();
  });

  group('BubbleSortUsecase - Basic Functionality', () {
    test('sorts an unsorted array correctly', () async {
      final input = [
        ArrayItem(value: 5, id: 0),
        ArrayItem(value: 2, id: 1),
        ArrayItem(value: 8, id: 2),
        ArrayItem(value: 1, id: 3),
      ];

      final stream = bubbleSortUsecase.execute(input, stepDelay: Duration.zero);

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.type, StepType.done);
      expect(lastStep.snapshot[0].value, 1);
      expect(lastStep.snapshot[1].value, 2);
      expect(lastStep.snapshot[2].value, 5);
      expect(lastStep.snapshot[3].value, 8);
    });

    test('handles already sorted array', () async {
      final input = [
        ArrayItem(value: 1, id: 0),
        ArrayItem(value: 2, id: 1),
        ArrayItem(value: 3, id: 2),
      ];

      final stream = bubbleSortUsecase.execute(input, stepDelay: Duration.zero);

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
      final input = [ArrayItem(value: 42, id: 0)];

      final stream = bubbleSortUsecase.execute(input, stepDelay: Duration.zero);

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.type, StepType.done);
      expect(lastStep.snapshot.length, 1);
      expect(lastStep.snapshot[0].value, 42);
    });

    test('handles empty array', () async {
      final input = <ArrayItem>[];

      final stream = bubbleSortUsecase.execute(input, stepDelay: Duration.zero);

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
        ArrayItem(value: 3, id: 0),
        ArrayItem(value: 1, id: 1),
        ArrayItem(value: 3, id: 2),
        ArrayItem(value: 2, id: 3),
      ];

      final stream = bubbleSortUsecase.execute(input, stepDelay: Duration.zero);

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep, isNotNull);
      expect(lastStep!.type, StepType.done);
      expect(lastStep.snapshot[0].value, 1);
      expect(lastStep.snapshot[1].value, 2);
      expect(lastStep.snapshot[2].value, 3);
      expect(lastStep.snapshot[3].value, 3);
    });
  });

  group('BubbleSortUsecase - Step Types', () {
    test('emits compare and swap steps', () async {
      final input = [ArrayItem(value: 3, id: 0), ArrayItem(value: 1, id: 1)];

      final stream = bubbleSortUsecase.execute(input, stepDelay: Duration.zero);

      final steps = await stream.toList();

      expect(steps.any((s) => s.type == StepType.compare), true);
      expect(steps.any((s) => s.type == StepType.swap), true);
      expect(steps.last.type, StepType.done);
    });

    test('final step has indices -1, -1', () async {
      final input = [ArrayItem(value: 2, id: 0), ArrayItem(value: 1, id: 1)];

      final stream = bubbleSortUsecase.execute(input, stepDelay: Duration.zero);

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep!.indexA, -1);
      expect(lastStep.indexB, -1);
    });
  });

  group('BubbleSortUsecase - Edge Cases', () {
    test('handles reverse sorted array', () async {
      final input = [
        ArrayItem(value: 5, id: 0),
        ArrayItem(value: 4, id: 1),
        ArrayItem(value: 3, id: 2),
        ArrayItem(value: 2, id: 3),
        ArrayItem(value: 1, id: 4),
      ];

      final stream = bubbleSortUsecase.execute(input, stepDelay: Duration.zero);

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

    test('handles large numbers', () async {
      final input = [
        ArrayItem(value: 1000, id: 0),
        ArrayItem(value: 500, id: 1),
        ArrayItem(value: 2000, id: 2),
      ];

      final stream = bubbleSortUsecase.execute(input, stepDelay: Duration.zero);

      SortStep? lastStep;
      await for (final step in stream) {
        lastStep = step;
      }

      expect(lastStep!.snapshot[0].value, 500);
      expect(lastStep.snapshot[1].value, 1000);
      expect(lastStep.snapshot[2].value, 2000);
    });
  });
}
