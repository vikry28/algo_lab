import 'dart:async';
import '../entities/array_item.dart';
import 'bubble_sort_usecase.dart';

class InsertionSortUsecase {
  Stream<SortStep> execute(
    List<ArrayItem> input, {
    Duration stepDelay = const Duration(milliseconds: 300),
  }) async* {
    final arr = input.map((e) => e.copyWith(value: e.value)).toList();
    final n = arr.length;
    for (int i = 1; i < n; i++) {
      int j = i;
      while (j > 0) {
        yield SortStep(
          type: StepType.compare,
          indexA: j - 1,
          indexB: j,
          snapshot: arr.map((e) => e.copyWith(value: e.value)).toList(),
        );
        await Future.delayed(stepDelay);
        if (arr[j - 1].value > arr[j].value) {
          final tmp = arr[j - 1].value;
          arr[j - 1].value = arr[j].value;
          arr[j].value = tmp;
          yield SortStep(
            type: StepType.swap,
            indexA: j - 1,
            indexB: j,
            snapshot: arr.map((e) => e.copyWith(value: e.value)).toList(),
          );
          await Future.delayed(stepDelay);
        } else {
          break;
        }
        j--;
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
