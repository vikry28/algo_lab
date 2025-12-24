import 'package:algo_lab/features/sorting_lab/data/models/enum.dart';
import 'package:algo_lab/features/sorting_lab/domain/entities/array_item.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/bubble_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/selection_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/insertion_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/merge_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/domain/usecases/quick_sort_usecase.dart';
import 'package:algo_lab/features/sorting_lab/presentation/provider/sorting_provider.dart';
import 'package:algo_lab/features/sorting_lab/utils/sorting_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SortingProvider sortingProvider;
  late BubbleSortUsecase bubbleSort;
  late SelectionSortUsecase selectionSort;
  late InsertionSortUsecase insertionSort;
  late MergeSortUsecase mergeSort;
  late QuickSortUsecase quickSort;
  late SortingLogger logger;

  setUp(() {
    bubbleSort = BubbleSortUsecase();
    selectionSort = SelectionSortUsecase();
    insertionSort = InsertionSortUsecase();
    mergeSort = MergeSortUsecase();
    quickSort = QuickSortUsecase();
    logger = SortingLogger();

    sortingProvider = SortingProvider(
      bubble: bubbleSort,
      selection: selectionSort,
      insertion: insertionSort,
      merge: mergeSort,
      quick: quickSort,
      logger: logger,
    );
  });

  tearDown(() {
    sortingProvider.dispose();
  });

  group('SortingProvider - Initialization', () {
    test('initial state is correct', () {
      expect(sortingProvider.items, isEmpty);
      expect(sortingProvider.isRunning, false);
      expect(sortingProvider.comparisons, 0);
      expect(sortingProvider.swaps, 0);
      expect(sortingProvider.highlightA, isNull);
      expect(sortingProvider.highlightB, isNull);
      expect(sortingProvider.isFinished, false);
      expect(sortingProvider.selectedAlgorithm, SortingAlgorithm.bubble);
    });

    test('step delay has default value', () {
      expect(sortingProvider.stepDelay, const Duration(milliseconds: 300));
    });

    test('elapsed time starts at zero', () {
      expect(sortingProvider.elapsed, Duration.zero);
    });
  });

  group('SortingProvider - Generate Initial', () {
    test('generateInitial resets state correctly', () async {
      final testItems = [
        ArrayItem(value: 5, id: 0),
        ArrayItem(value: 3, id: 1),
        ArrayItem(value: 8, id: 2),
      ];

      await sortingProvider.generateInitial(testItems);

      expect(sortingProvider.items.length, 3);
      expect(sortingProvider.comparisons, 0);
      expect(sortingProvider.swaps, 0);
      expect(sortingProvider.highlightA, isNull);
      expect(sortingProvider.highlightB, isNull);
      expect(sortingProvider.isFinished, false);
      expect(sortingProvider.stepCounter, 0);
    });

    test('generateInitial creates copies of items', () async {
      final testItems = [
        ArrayItem(value: 5, id: 0),
        ArrayItem(value: 3, id: 1),
      ];

      await sortingProvider.generateInitial(testItems);

      expect(sortingProvider.items[0].value, 5);
      expect(sortingProvider.items[1].value, 3);
      expect(sortingProvider.items.length, testItems.length);
    });
  });

  group('SortingProvider - Algorithm Selection', () {
    test('changeAlgorithm updates selected algorithm', () {
      sortingProvider.changeAlgorithm(SortingAlgorithm.selection);
      expect(sortingProvider.selectedAlgorithm, SortingAlgorithm.selection);
    });

    test('changeAlgorithm resets timer', () {
      sortingProvider.changeAlgorithm(SortingAlgorithm.insertion);
      expect(sortingProvider.elapsed, Duration.zero);
    });

    test('generateForAlgorithm creates appropriate data for bubble sort', () {
      sortingProvider.generateForAlgorithm(SortingAlgorithm.bubble);
      expect(sortingProvider.items.length, 8);
      expect(sortingProvider.items[0].value, 85);
    });

    test(
      'generateForAlgorithm creates appropriate data for selection sort',
      () {
        sortingProvider.generateForAlgorithm(SortingAlgorithm.selection);
        expect(sortingProvider.items.length, 8);
        expect(sortingProvider.items[0].value, 15);
      },
    );

    test(
      'generateForAlgorithm creates appropriate data for insertion sort',
      () {
        sortingProvider.generateForAlgorithm(SortingAlgorithm.insertion);
        expect(sortingProvider.items.length, 8);
        expect(sortingProvider.items[0].value, 502);
      },
    );

    test('generateForAlgorithm creates appropriate data for quick sort', () {
      sortingProvider.generateForAlgorithm(SortingAlgorithm.quick);
      expect(sortingProvider.items.length, 8);
      expect(sortingProvider.items[0].value, 4500);
    });
  });

  group('SortingProvider - Case Studies', () {
    test('currentCaseStudy returns correct data for bubble sort', () {
      sortingProvider.changeAlgorithm(SortingAlgorithm.bubble);
      final caseStudy = sortingProvider.currentCaseStudy;

      expect(caseStudy.titleKey, "lab_bubble_title");
      expect(caseStudy.descriptionKey, "lab_bubble_desc");
      expect(caseStudy.icon, "🫧");
    });

    test('currentCaseStudy returns correct data for selection sort', () {
      sortingProvider.changeAlgorithm(SortingAlgorithm.selection);
      final caseStudy = sortingProvider.currentCaseStudy;

      expect(caseStudy.titleKey, "lab_selection_title");
      expect(caseStudy.descriptionKey, "lab_selection_desc");
      expect(caseStudy.icon, "📦");
    });

    test('currentCaseStudy returns correct data for insertion sort', () {
      sortingProvider.changeAlgorithm(SortingAlgorithm.insertion);
      final caseStudy = sortingProvider.currentCaseStudy;

      expect(caseStudy.titleKey, "lab_insertion_title");
      expect(caseStudy.descriptionKey, "lab_insertion_desc");
      expect(caseStudy.icon, "🃏");
    });

    test('currentCaseStudy returns correct data for quick sort', () {
      sortingProvider.changeAlgorithm(SortingAlgorithm.quick);
      final caseStudy = sortingProvider.currentCaseStudy;

      expect(caseStudy.titleKey, "lab_quick_title");
      expect(caseStudy.descriptionKey, "lab_quick_desc");
      expect(caseStudy.icon, "⚡");
    });
  });

  group('SortingProvider - Step Delay', () {
    test('setStepDelay updates delay value', () {
      const newDelay = Duration(milliseconds: 500);
      sortingProvider.setStepDelay(newDelay);

      expect(sortingProvider.stepDelay, newDelay);
    });
  });

  group('SortingProvider - Timer', () {
    test('resetTimer clears elapsed time', () {
      sortingProvider.resetTimer();
      expect(sortingProvider.elapsed, Duration.zero);
    });
  });

  group('SortingProvider - Stop and Restart', () {
    test('stop sets isRunning to false', () {
      sortingProvider.stop();
      expect(sortingProvider.isRunning, false);
    });

    test('restartWith resets state with new items', () async {
      final newItems = [
        ArrayItem(value: 10, id: 0),
        ArrayItem(value: 5, id: 1),
      ];

      await sortingProvider.restartWith(newItems);

      expect(sortingProvider.items.length, 2);
      expect(sortingProvider.isRunning, false);
      expect(sortingProvider.comparisons, 0);
      expect(sortingProvider.swaps, 0);
    });
  });
}
