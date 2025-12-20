import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../data/models/enum.dart';
import '../../domain/entities/array_item.dart';
import '../../domain/usecases/bubble_sort_usecase.dart';
import '../../domain/usecases/selection_sort_usecase.dart';
import '../../domain/usecases/insertion_sort_usecase.dart';
import '../../domain/usecases/merge_sort_usecase.dart';
import '../../domain/usecases/quick_sort_usecase.dart';
import '../../utils/sorting_logger.dart';

class CaseStudy {
  final String titleKey;
  final String descriptionKey;
  final String metricName;
  final String icon;

  CaseStudy({
    required this.titleKey,
    required this.descriptionKey,
    required this.metricName,
    required this.icon,
  });
}

class SortingProvider extends ChangeNotifier {
  final BubbleSortUsecase bubble;
  final SelectionSortUsecase selection;
  final InsertionSortUsecase insertion;
  final MergeSortUsecase merge;
  final QuickSortUsecase quick;
  final SortingLogger logger;

  SortingProvider({
    required this.bubble,
    required this.selection,
    required this.insertion,
    required this.merge,
    required this.quick,
    required this.logger,
  });

  List<ArrayItem> items = [];
  bool isRunning = false;
  Duration stepDelay = const Duration(milliseconds: 300);

  int comparisons = 0;
  int swaps = 0;

  int? highlightA;
  int? highlightB;
  StepType? highlightType;

  int stepCounter = 0;

  bool isFinished = false;

  CaseStudy get currentCaseStudy {
    switch (selectedAlgorithm) {
      case SortingAlgorithm.bubble:
        return CaseStudy(
          titleKey: "lab_bubble_title",
          descriptionKey: "lab_bubble_desc",
          metricName: "Throughput",
          icon: "🫧",
        );
      case SortingAlgorithm.selection:
        return CaseStudy(
          titleKey: "lab_selection_title",
          descriptionKey: "lab_selection_desc",
          metricName: "Efficiency",
          icon: "📦",
        );
      case SortingAlgorithm.insertion:
        return CaseStudy(
          titleKey: "lab_insertion_title",
          descriptionKey: "lab_insertion_desc",
          metricName: "Stability",
          icon: "🃏",
        );
      case SortingAlgorithm.quick:
        return CaseStudy(
          titleKey: "lab_quick_title",
          descriptionKey: "lab_quick_desc",
          metricName: "Divide & Conquer",
          icon: "⚡",
        );
    }
  }

  StreamSubscription<SortStep>? _sub;

  Color compareColor = Colors.cyanAccent;
  Color swapColor = Colors.pinkAccent;

  DateTime? _startTime;
  Duration elapsed = Duration.zero;

  void _startTimer() {
    _startTime = DateTime.now();
    elapsed = Duration.zero;
  }

  void _endTimer() {
    if (_startTime != null) {
      elapsed = DateTime.now().difference(_startTime!);
    }
  }

  void resetTimer() {
    _startTime = null;
    elapsed = Duration.zero;
    notifyListeners();
  }

  Future<void> generateInitial(List<ArrayItem> list) async {
    items = list.map((e) => e.copyWith(value: e.value)).toList();

    comparisons = 0;
    swaps = 0;
    highlightA = highlightB = null;
    highlightType = null;
    stepCounter = 0;

    logger.clear();
    isFinished = false;
    AppLogger.debug('Sorting state reset');
    notifyListeners();
  }

  void setStepDelay(Duration d) {
    stepDelay = d;
    notifyListeners();
  }

  void _listen(Stream<SortStep> stream) {
    _sub = stream.listen(
      (step) {
        highlightType = step.type;
        highlightA = step.indexA >= 0 ? step.indexA : null;
        highlightB = step.indexB >= 0 ? step.indexB : null;

        items = step.snapshot.map((e) => e.copyWith(value: e.value)).toList();

        switch (step.type) {
          case StepType.compare:
            comparisons++;
            logger.log("Compare ${step.indexA} & ${step.indexB}");
            break;
          case StepType.swap:
            swaps++;
            logger.log("Swap ${step.indexA} & ${step.indexB}");
            break;
          case StepType.done:
            isFinished = true;
            logger.log("Sorting done");
            sl<AnalyticsService>().logEvent(
              name: 'sorting_finished',
              parameters: {
                'algorithm': selectedAlgorithm.name,
                'comparisons': comparisons,
                'swaps': swaps,
              },
            );
            AppLogger.info('Sorting finished: ${selectedAlgorithm.name}');
            break;
        }

        stepCounter++;
        notifyListeners();
      },
      onDone: () {
        isRunning = false;
        _endTimer();
        _stopTicker();
        notifyListeners();
      },
    );
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
    isRunning = false;
    _stopTicker();
    logger.log("Stopped");
    notifyListeners();
  }

  Future<void> restartWith(List<ArrayItem> items) async {
    stop();
    await generateInitial(items);
  }

  void _startSort(Stream<SortStep> stream, String name) {
    stop();
    isRunning = true;

    logger.log("Start $name");
    sl<AnalyticsService>().logEvent(
      name: 'sorting_started',
      parameters: {'algorithm': name},
    );
    AppLogger.info('Starting sorting animation: $name');
    notifyListeners();

    _listen(stream);
  }

  void startBubbleSort() {
    _startSort(bubble.execute(items, stepDelay: stepDelay), "Bubble Sort");
  }

  void startSelectionSort() {
    _startSort(
      selection.execute(items, stepDelay: stepDelay),
      "Selection Sort",
    );
  }

  void startInsertionSort() {
    _startSort(
      insertion.execute(items, stepDelay: stepDelay),
      "Insertion Sort",
    );
  }

  void startMergeSort() {
    _startSort(merge.execute(items, stepDelay: stepDelay), "Merge Sort");
  }

  void startQuickSort() {
    _startSort(quick.execute(items, stepDelay: stepDelay), "Quick Sort");
  }

  SortingAlgorithm selectedAlgorithm = SortingAlgorithm.bubble;

  void changeAlgorithm(SortingAlgorithm algo) {
    selectedAlgorithm = algo;
    resetTimer();
    generateForAlgorithm(algo);
    notifyListeners();
  }

  void generateForAlgorithm(SortingAlgorithm algo) {
    final List<int> values;
    switch (algo) {
      case SortingAlgorithm.bubble:
        values = [85, 42, 91, 12, 67, 34, 55, 10];
        break;
      case SortingAlgorithm.selection:
        values = [15, 3, 22, 10, 8, 30, 1, 18];
        break;
      case SortingAlgorithm.insertion:
        values = [502, 101, 890, 234, 445, 120, 678, 321];
        break;
      case SortingAlgorithm.quick:
        values = [4500, 1200, 9800, 3100, 7600, 2200, 5400, 8900];
        break;
    }

    final newItems = List.generate(
      values.length,
      (i) => ArrayItem(value: values[i], id: i),
    );
    generateInitial(newItems);
  }

  void startSelected() {
    stop();
    resetTimer();
    _startTimer();
    _startTicker();
    isRunning = true;

    switch (selectedAlgorithm) {
      case SortingAlgorithm.bubble:
        startBubbleSort();
        break;
      case SortingAlgorithm.selection:
        startSelectionSort();
        break;
      case SortingAlgorithm.insertion:
        startInsertionSort();
        break;
      case SortingAlgorithm.quick:
        startQuickSort();
        break;
    }
  }

  Timer? _ticker;

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_startTime != null && isRunning) {
        elapsed = DateTime.now().difference(_startTime!);
        notifyListeners();
      }
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _sub?.cancel();
    _stopTicker();
    super.dispose();
  }
}
