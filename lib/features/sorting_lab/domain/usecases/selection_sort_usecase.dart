import 'dart:async';
import '../entities/array_item.dart';
import 'bubble_sort_usecase.dart';

class SelectionSortUsecase {
  Stream<SortStep> execute(
    List<ArrayItem> input, {
    Duration stepDelay = const Duration(milliseconds: 300),
  }) async* {
    final arr = input.map((e) => e.copyWith(value: e.value)).toList();
    final n = arr.length;
    for (int i = 0; i < n - 1; i++) {
      int minIdx = i;
      for (int j = i + 1; j < n; j++) {
        yield SortStep(
          type: StepType.compare,
          indexA: minIdx,
          indexB: j,
          snapshot: arr.map((e) => e.copyWith(value: e.value)).toList(),
        );
        await Future.delayed(stepDelay);
        if (arr[j].value < arr[minIdx].value) {
          minIdx = j;
        }
      }
      if (minIdx != i) {
        final tmp = arr[i].value;
        arr[i].value = arr[minIdx].value;
        arr[minIdx].value = tmp;
        yield SortStep(
          type: StepType.swap,
          indexA: i,
          indexB: minIdx,
          snapshot: arr.map((e) => e.copyWith(value: e.value)).toList(),
        );
        await Future.delayed(stepDelay);
      }
    }
    yield SortStep(
      type: StepType.done,
      indexA: -1,
      indexB: -1,
      snapshot: arr.map((e) => e.copyWith(value: e.value)).toList(),
    );
  }
}
