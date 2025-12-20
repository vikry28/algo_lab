import 'dart:async';
import '../entities/array_item.dart';
import 'bubble_sort_usecase.dart';

class QuickSortUsecase {
  Stream<SortStep> execute(
    List<ArrayItem> input, {
    Duration stepDelay = const Duration(milliseconds: 250),
  }) async* {
    final arr = input.map((e) => e.copyWith(value: e.value)).toList();
    final controller = StreamController<SortStep>();

    List<ArrayItem> clone() =>
        arr.map((e) => e.copyWith(value: e.value)).toList();

    Future<void> emit(SortStep s) async {
      controller.add(s);
      await Future.delayed(stepDelay);
    }

    Future<int> partition(int low, int high) async {
      final pivot = arr[high].value;
      int i = low;

      for (int j = low; j < high; j++) {
        await emit(
          SortStep(
            type: StepType.compare,
            indexA: j,
            indexB: high,
            snapshot: clone(),
          ),
        );

        if (arr[j].value < pivot) {
          final tmp = arr[i].value;
          arr[i].value = arr[j].value;
          arr[j].value = tmp;

          await emit(
            SortStep(
              type: StepType.swap,
              indexA: i,
              indexB: j,
              snapshot: clone(),
            ),
          );

          i++;
        }
      }

      final tmp2 = arr[i].value;
      arr[i].value = arr[high].value;
      arr[high].value = tmp2;

      await emit(
        SortStep(
          type: StepType.swap,
          indexA: i,
          indexB: high,
          snapshot: clone(),
        ),
      );

      return i;
    }

    Future<void> quick(int low, int high) async {
      if (low < high) {
        final p = await partition(low, high);
        await quick(low, p - 1);
        await quick(p + 1, high);
      }
    }

    unawaited(
      quick(0, arr.length - 1).then((_) async {
        await emit(
          SortStep(
            type: StepType.done,
            indexA: -1,
            indexB: -1,
            snapshot: clone(),
          ),
        );
        await controller.close();
      }),
    );

    yield* controller.stream;
  }
}
