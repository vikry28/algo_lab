import 'dart:async';
import '../entities/array_item.dart';
import 'bubble_sort_usecase.dart';

class MergeSortUsecase {
  Stream<SortStep> execute(
    List<ArrayItem> input, {
    Duration stepDelay = const Duration(milliseconds: 300),
  }) async* {
    final arr = input.map((e) => e.copyWith(value: e.value)).toList();

    Future<List<ArrayItem>> mergeSort(
      List<ArrayItem> list,
      StreamController<SortStep> controller,
    ) async {
      if (list.length <= 1) return list;
      final mid = list.length ~/ 2;
      final left = await mergeSort(list.sublist(0, mid), controller);
      final right = await mergeSort(list.sublist(mid), controller);
      final merged = <ArrayItem>[];
      int i = 0, j = 0;
      while (i < left.length || j < right.length) {
        if (i < left.length && j < right.length) {
          controller.add(
            SortStep(
              type: StepType.compare,
              indexA: i,
              indexB: mid + j,
              snapshot: [...left, ...right],
            ),
          );
          await Future.delayed(stepDelay);
          if (left[i].value <= right[j].value) {
            merged.add(left[i++]);
          } else {
            merged.add(right[j++]);
          }
        } else if (i < left.length) {
          merged.add(left[i++]);
        } else {
          merged.add(right[j++]);
        }
      }

      return merged.map((e) => e.copyWith(value: e.value)).toList();
    }

    final controller = StreamController<SortStep>();

    controller.stream.listen((s) {});
    final sorted = await mergeSort(arr, controller);
    await controller.close();

    yield SortStep(
      type: StepType.done,
      indexA: -1,
      indexB: -1,
      snapshot: sorted,
    );
  }
}
