import 'dart:async';
import '../entities/array_item.dart';

enum StepType { compare, swap, done }

class SortStep {
  final StepType type;
  final int indexA;
  final int indexB;
  final List<ArrayItem> snapshot;

  SortStep({
    required this.type,
    required this.indexA,
    required this.indexB,
    required this.snapshot,
  });
}

class BubbleSortUsecase {
  Stream<SortStep> execute(
    List<ArrayItem> input, {
    Duration stepDelay = const Duration(milliseconds: 300),
  }) async* {
    final arr = input.map((e) => e.copyWith(value: e.value)).toList();
    final n = arr.length;
    bool swapped;
    for (int i = 0; i < n; i++) {
      swapped = false;
      for (int j = 0; j < n - i - 1; j++) {
        // compare
        yield SortStep(
          type: StepType.compare,
          indexA: j,
          indexB: j + 1,
          snapshot: arr.map((e) => e.copyWith(value: e.value)).toList(),
        );
        await Future.delayed(stepDelay);
        if (arr[j].value > arr[j + 1].value) {
          final tmp = arr[j].value;
          arr[j].value = arr[j + 1].value;
          arr[j + 1].value = tmp;
          swapped = true;
          yield SortStep(
            type: StepType.swap,
            indexA: j,
            indexB: j + 1,
            snapshot: arr.map((e) => e.copyWith(value: e.value)).toList(),
          );
          await Future.delayed(stepDelay);
        }
      }
      if (!swapped) break;
    }
    yield SortStep(
      type: StepType.done,
      indexA: -1,
      indexB: -1,
      snapshot: arr.map((e) => e.copyWith(value: e.value)).toList(),
    );
  }
}
