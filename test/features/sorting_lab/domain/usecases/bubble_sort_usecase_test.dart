import 'package:flutter_test/flutter_test.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/bubble_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/entities/array_item.dart';

void main() {
  late BubbleSortUsecase bubbleSort;

  setUp(() {
    bubbleSort = BubbleSortUsecase();
  });

  group('BubbleSortUsecase Tests', () {
    test('Should sort list correctly', () async {
      final items = [
        ArrayItem(id: 0, value: 50),
        ArrayItem(id: 1, value: 20),
        ArrayItem(id: 2, value: 40),
        ArrayItem(id: 3, value: 10),
      ];

      final stream = bubbleSort.execute(items, stepDelay: Duration.zero);
      SortStep lastStep = await stream.last;

      expect(lastStep.type, equals(StepType.done));

      final resultValues = lastStep.snapshot.map((e) => e.value).toList();
      expect(resultValues, equals([10, 20, 40, 50]));
    });

    test('Should emit steps during sorting', () async {
      final items = [ArrayItem(id: 0, value: 5), ArrayItem(id: 1, value: 2)];

      final stream = bubbleSort.execute(items, stepDelay: Duration.zero);
      final steps = await stream.toList();

      // For 2 elements:
      // 1. Compare (5, 2)
      // 2. Swap (2, 5)
      // 3. Done
      expect(steps.any((s) => s.type == StepType.compare), isTrue);
      expect(steps.any((s) => s.type == StepType.swap), isTrue);
      expect(steps.last.type, equals(StepType.done));
    });
  });
}
