import '../../domain/entities/algorithm_content_entity.dart';
import 'sorting_algorithms_content.dart';
import 'search_algorithms_content.dart';
import 'graph_algorithms_content.dart';
import 'cryptography_algorithms_content.dart';

/// Master Datasource yang menyediakan konten pembelajaran untuk SEMUA algoritma
///
/// Struktur:
/// - Sorting Algorithms (6): Bubble, Quick, Merge, Insertion, Selection, Heap
/// - Search Algorithms (3): Linear, Binary, Interpolation
/// - Graph Algorithms (7): BFS, DFS, Dijkstra, Bellman-Ford, Floyd-Warshall, Kruskal, Prim
/// - Cryptography (5): Caesar, Vigenere, RSA, AES, SHA-256
class AlgorithmContentDataSource {
  /// Get konten pembelajaran berdasarkan algorithm ID
  /// [languageCode] determines the language of the code comments and output
  AlgorithmContentEntity? getContentById(
    String algorithmId,
    String languageCode,
  ) {
    switch (algorithmId) {
      // ============================================================
      // SORTING ALGORITHMS (6)
      // ============================================================
      case 'sort1': // Bubble Sort
        return getBubbleSortContent(languageCode);
      case 'sort2': // Quick Sort
        return getQuickSortContent(languageCode);
      case 'sort3': // Merge Sort
        return getMergeSortContent(languageCode);
      case 'sort4': // Insertion Sort
        return SortingAlgorithmsContent.getInsertionSort(languageCode);
      case 'sort5': // Selection Sort
        return SortingAlgorithmsContent.getSelectionSort(languageCode);
      case 'sort6': // Heap Sort
        return SortingAlgorithmsContent.getHeapSort(languageCode);

      // ============================================================
      // SEARCH ALGORITHMS (3)
      // ============================================================
      case 'search1': // Linear Search
        return SearchAlgorithmsContent.getLinearSearch(languageCode);
      case 'search2': // Binary Search
        return SearchAlgorithmsContent.getBinarySearch(languageCode);
      case 'search3': // Interpolation Search
        return SearchAlgorithmsContent.getInterpolationSearch(languageCode);

      // ============================================================
      // GRAPH ALGORITHMS (7) - ALL COMPLETE!
      // ============================================================
      case 'graph1': // Dijkstra
        return GraphAlgorithmsContent.getDijkstra(languageCode);
      case 'graph2': // BFS
        return GraphAlgorithmsContent.getBFS(languageCode);
      case 'graph3': // DFS
        return GraphAlgorithmsContent.getDFS(languageCode);
      case 'graph4': // Bellman-Ford
        return GraphAlgorithmsContent.getBellmanFord(languageCode);
      case 'graph5': // Floyd-Warshall
        return GraphAlgorithmsContent.getFloydWarshall(languageCode);
      case 'graph6': // Kruskal
        return GraphAlgorithmsContent.getKruskal(languageCode);
      case 'graph7': // Prim
        return GraphAlgorithmsContent.getPrim(languageCode);

      // ============================================================
      // CRYPTOGRAPHY (5) - ALL COMPLETE!
      // ============================================================
      case 'crypto1': // Caesar Cipher
        return CryptographyAlgorithmsContent.getCaesarCipher(languageCode);
      case 'crypto2': // Vigenere Cipher
        return CryptographyAlgorithmsContent.getVigenereCipher(languageCode);
      case 'crypto3': // RSA
        return CryptographyAlgorithmsContent.getRSA(languageCode);
      case 'crypto4': // AES
        return CryptographyAlgorithmsContent.getAES(languageCode);
      case 'crypto5': // SHA-256
        return CryptographyAlgorithmsContent.getSHA256(languageCode);

      default:
        return null;
    }
  }

  /// Check if content is available for an algorithm
  bool hasContent(String algorithmId) {
    // Check against English by default for availability check
    return getContentById(algorithmId, 'en') != null;
  }

  /// Get list of all algorithm IDs that have content
  List<String> getAvailableAlgorithms() {
    return [
      // Sorting (6)
      'sort1',
      'sort2',
      'sort3',
      'sort4',
      'sort5',
      'sort6',
      // Search (3)
      'search1',
      'search2',
      'search3',
      // Graph (7)
      'graph1',
      'graph2',
      'graph3',
      'graph4',
      'graph5',
      'graph6',
      'graph7',
      // Cryptography (5)
      'crypto1',
      'crypto2',
      'crypto3',
      'crypto4',
      'crypto5',
    ];
  }

  /// Get completion percentage of all modules
  double getOverallCompletion() {
    final total = 21; // Total algorithms
    final completed = getAvailableAlgorithms().length;
    return completed / total;
  }

  // ============================================================================
  // SORTING ALGORITHMS - Inline implementations for backward compatibility
  // ============================================================================

  AlgorithmContentEntity getBubbleSortContent(String languageCode) {
    bool isId = languageCode == 'id';

    return AlgorithmContentEntity(
      summaryText: 'bubble_summary_text',
      understandingText: 'bubble_understanding_text',

      algorithmSteps: [
        'bubble_step_1',
        'bubble_step_2',
        'bubble_step_3',
        'bubble_step_4',
        'bubble_step_5',
        'bubble_step_6',
        'bubble_step_7',
      ],

      codeExample: isId
          ? '''void bubbleSort(List<int> arr) {
  int n = arr.length;
  print('Array awal: \$arr\\n');
  
  for (int i = 0; i < n - 1; i++) {
    print('--- Pass \${i + 1} ---');
    bool swapped = false;
    
    for (int j = 0; j < n - i - 1; j++) {
      print('Bandingkan: \${arr[j]} vs \${arr[j + 1]}');
      
      if (arr[j] > arr[j + 1]) {
        // Swap
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
        swapped = true;
        print('  → Tukar! Hasil: \$arr');
      } else {
        print('  → Tidak perlu tukar');
      }
    }
    
    print('Setelah pass \${i + 1}: \$arr\\n');
    
    if (!swapped) {
      print('Array sudah terurut!');
      break;
    }
  }
}

void main() {
  List<int> numbers = [64, 34, 25, 12, 22];
  bubbleSort(numbers);
  print('\\nHasil akhir: \$numbers');
}'''
          : '''void bubbleSort(List<int> arr) {
  int n = arr.length;
  print('Initial Array: \$arr\\n');
  
  for (int i = 0; i < n - 1; i++) {
    print('--- Pass \${i + 1} ---');
    bool swapped = false;
    
    for (int j = 0; j < n - i - 1; j++) {
      print('Compare: \${arr[j]} vs \${arr[j + 1]}');
      
      if (arr[j] > arr[j + 1]) {
        // Swap
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
        swapped = true;
        print('  → Swap! Result: \$arr');
      } else {
        print('  → No swap needed');
      }
    }
    
    print('After pass \${i + 1}: \$arr\\n');
    
    if (!swapped) {
      print('Array is already sorted!');
      break;
    }
  }
}

void main() {
  List<int> numbers = [64, 34, 25, 12, 22];
  bubbleSort(numbers);
  print('\\nFinal Result: \$numbers');
}''',

      output: isId
          ? '''Array awal: [64, 34, 25, 12, 22]

--- Pass 1 ---
Bandingkan: 64 vs 34
  → Tukar! Hasil: [34, 64, 25, 12, 22]
Bandingkan: 64 vs 25
  → Tukar! Hasil: [34, 25, 64, 12, 22]
Bandingkan: 64 vs 12
  → Tukar! Hasil: [34, 25, 12, 64, 22]
Bandingkan: 64 vs 22
  → Tukar! Hasil: [34, 25, 12, 22, 64]
Setelah pass 1: [34, 25, 12, 22, 64]

--- Pass 2 ---
Bandingkan: 34 vs 25
  → Tukar! Hasil: [25, 34, 12, 22, 64]
...

Hasil akhir: [12, 22, 25, 34, 64]'''
          : '''Initial Array: [64, 34, 25, 12, 22]

--- Pass 1 ---
Compare: 64 vs 34
  → Swap! Result: [34, 64, 25, 12, 22]
Compare: 64 vs 25
  → Swap! Result: [34, 25, 64, 12, 22]
Compare: 64 vs 12
  → Swap! Result: [34, 25, 12, 64, 22]
Compare: 64 vs 22
  → Swap! Result: [34, 25, 12, 22, 64]
After pass 1: [34, 25, 12, 22, 64]

--- Pass 2 ---
Compare: 34 vs 25
  → Swap! Result: [25, 34, 12, 22, 64]
...

Final Result: [12, 22, 25, 34, 64]''',

      timeComplexity: 'bubble_time_complexity',
      spaceComplexity: 'bubble_space_complexity',

      advantages: [
        'bubble_advantage_1',
        'bubble_advantage_2',
        'bubble_advantage_3',
        'bubble_advantage_4',
        'bubble_advantage_5',
      ],

      disadvantages: [
        'bubble_disadvantage_1',
        'bubble_disadvantage_2',
        'bubble_disadvantage_3',
        'bubble_disadvantage_4',
        'bubble_disadvantage_5',
      ],

      visualSteps: [
        'bubble_visual_step_1',
        'bubble_visual_step_2',
        'bubble_visual_step_3',
        'bubble_visual_step_4',
        'bubble_visual_step_5',
        'bubble_visual_step_6',
        'bubble_visual_step_7',
        'bubble_visual_step_8',
        'bubble_visual_step_9',
        'bubble_visual_step_10',
        'bubble_visual_step_11',
        'bubble_visual_step_12',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'bubble_quiz_1_question',
          correctAnswer: '''void bubbleSort(List<int> arr) {
  int n = arr.length;
  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
      if (arr[j] > arr[j + 1]) {
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
    }
  }
}''',
          codeTemplate: isId
              ? '''void bubbleSort(List<int> arr) {
  // Tulis kode Anda di sini
  
}

void main() {
  List<int> numbers = [5, 2, 8, 1, 9];
  bubbleSort(numbers);
  print(numbers); // [1, 2, 5, 8, 9]
}'''
              : '''void bubbleSort(List<int> arr) {
  // Write your code here
  
}

void main() {
  List<int> numbers = [5, 2, 8, 1, 9];
  bubbleSort(numbers);
  print(numbers); // [1, 2, 5, 8, 9]
}''',
          hint: 'bubble_quiz_1_hint',
        ),
        QuizQuestion(
          question: 'bubble_quiz_2_question',
          correctAnswer: '''void bubbleSortOptimized(List<int> arr) {
  int n = arr.length;
  for (int i = 0; i < n - 1; i++) {
    bool swapped = false;
    for (int j = 0; j < n - i - 1; j++) {
      if (arr[j] > arr[j + 1]) {
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
        swapped = true;
      }
    }
    if (!swapped) break;
  }
}''',
          codeTemplate: isId
              ? '''void bubbleSortOptimized(List<int> arr) {
  // Tambahkan flag swapped
  
}'''
              : '''void bubbleSortOptimized(List<int> arr) {
  // Add swapped flag
  
}''',
          hint: 'bubble_quiz_2_hint',
        ),
        QuizQuestion(
          question: 'bubble_quiz_3_question',
          correctAnswer: '''void bubbleSortDescending(List<int> arr) {
  int n = arr.length;
  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
      if (arr[j] < arr[j + 1]) {
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
    }
  }
}''',
          codeTemplate: isId
              ? '''void bubbleSortDescending(List<int> arr) {
  // Ubah kondisi perbandingan
  
}'''
              : '''void bubbleSortDescending(List<int> arr) {
  // Change comparison condition
  
}''',
          hint: 'bubble_quiz_3_hint',
        ),
      ],

      useCases: 'bubble_use_cases',
      realWorldExample: 'bubble_real_world',
    );
  }

  AlgorithmContentEntity getQuickSortContent(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'quick_summary',
      understandingText: 'quick_understanding',

      algorithmSteps: [
        'quick_step_1',
        'quick_step_2',
        'quick_step_3',
        'quick_step_4',
        'quick_step_5',
        'quick_step_6',
      ],

      codeExample: isId
          ? '''void quickSort(List<int> arr, int low, int high) {
  if (low < high) {
    // Partisi dan dapatkan pivot index
    int pivotIndex = partition(arr, low, high);
    
    // Sort bagian kiri dan kanan pivot
    quickSort(arr, low, pivotIndex - 1);
    quickSort(arr, pivotIndex + 1, high);
  }
}

int partition(List<int> arr, int low, int high) {
  int pivot = arr[high];
  int i = low - 1;
  
  print('Pivot: \$pivot, Range: [\$low..\$high]');
  
  for (int j = low; j < high; j++) {
    if (arr[j] < pivot) {
      i++;
      // Swap arr[i] dan arr[j]
      int temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
    }
  }
  
  // Tempatkan pivot di posisi yang benar
  int temp = arr[i + 1];
  arr[i + 1] = arr[high];
  arr[high] = temp;
  
  print('Setelah partisi: \$arr\\n');
  return i + 1;
}

void main() {
  List<int> arr = [64, 34, 25, 12, 22, 11, 90];
  print('Array awal: \$arr\\n');
  quickSort(arr, 0, arr.length - 1);
  print('Hasil akhir: \$arr');
}'''
          : '''void quickSort(List<int> arr, int low, int high) {
  if (low < high) {
    int pivotIndex = partition(arr, low, high);
    quickSort(arr, low, pivotIndex - 1);
    quickSort(arr, pivotIndex + 1, high);
  }
}

int partition(List<int> arr, int low, int high) {
  int pivot = arr[high];
  int i = low - 1;
  
  print('Pivot: \$pivot, Range: [\$low..\$high]');
  
  for (int j = low; j < high; j++) {
    if (arr[j] < pivot) {
      i++;
      int temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
    }
  }
  
  int temp = arr[i + 1];
  arr[i + 1] = arr[high];
  arr[high] = temp;
  
  print('After partition: \$arr\\n');
  return i + 1;
}

void main() {
  List<int> arr = [64, 34, 25, 12, 22, 11, 90];
  print('Initial Array: \$arr\\n');
  quickSort(arr, 0, arr.length - 1);
  print('Final Result: \$arr');
}''',

      output: isId
          ? '''Array awal: [64, 34, 25, 12, 22, 11, 90]

Pivot: 90, Range: [0..6]
Setelah partisi: [64, 34, 25, 12, 22, 11, 90]

Pivot: 11, Range: [0..5]
Setelah partisi: [11, 34, 25, 12, 22, 64, 90]

Pivot: 64, Range: [1..5]
Setelah partisi: [11, 34, 25, 12, 22, 64, 90]
...

Hasil akhir: [11, 12, 22, 25, 34, 64, 90]'''
          : '''Initial Array: [64, 34, 25, 12, 22, 11, 90]

Pivot: 90, Range: [0..6]
After partition: [64, 34, 25, 12, 22, 11, 90]

Pivot: 11, Range: [0..5]
After partition: [11, 34, 25, 12, 22, 64, 90]

Pivot: 64, Range: [1..5]
After partition: [11, 34, 25, 12, 22, 64, 90]
...

Final Result: [11, 12, 22, 25, 34, 64, 90]''',

      timeComplexity: 'quick_time_complexity',
      spaceComplexity: 'quick_space_complexity',

      advantages: [
        'quick_advantage_1',
        'quick_advantage_2',
        'quick_advantage_3',
        'quick_advantage_4',
      ],

      disadvantages: [
        'quick_disadvantage_1',
        'quick_disadvantage_2',
        'quick_disadvantage_3',
      ],

      visualSteps: [
        'quick_visual_step_1',
        'quick_visual_step_2',
        'quick_visual_step_3',
        'quick_visual_step_4',
        'quick_visual_step_5',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'quick_quiz_1_question',
          correctAnswer: '''int partition(List<int> arr, int low, int high) {
  int pivot = arr[high];
  int i = low - 1;
  for (int j = low; j < high; j++) {
    if (arr[j] < pivot) {
      i++;
      int temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
    }
  }
  int temp = arr[i + 1];
  arr[i + 1] = arr[high];
  arr[high] = temp;
  return i + 1;
}''',
          codeTemplate: '''int partition(List<int> arr, int low, int high) {
  
}''',
          hint: 'quick_quiz_1_hint',
        ),
      ],

      useCases: 'quick_use_cases',

      realWorldExample: 'quick_real_world',
    );
  }

  AlgorithmContentEntity getMergeSortContent(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'merge_summary',
      understandingText: 'merge_understanding',

      algorithmSteps: [
        'merge_step_1',
        'merge_step_2',
        'merge_step_3',
        'merge_step_4',
      ],

      codeExample: isId
          ? '''void mergeSort(List<int> arr, int left, int right) {
  if (left < right) {
    int mid = left + (right - left) ~/ 2;
    mergeSort(arr, left, mid);
    mergeSort(arr, mid + 1, right);
    merge(arr, left, mid, right);
  }
}

void merge(List<int> arr, int left, int mid, int right) {
  List<int> leftArr = arr.sublist(left, mid + 1);
  List<int> rightArr = arr.sublist(mid + 1, right + 1);
  
  int i = 0, j = 0, k = left;
  
  while (i < leftArr.length && j < rightArr.length) {
    if (leftArr[i] <= rightArr[j]) {
      arr[k++] = leftArr[i++];
    } else {
      arr[k++] = rightArr[j++];
    }
  }
  
  while (i < leftArr.length) arr[k++] = leftArr[i++];
  while (j < rightArr.length) arr[k++] = rightArr[j++];
}

void main() {
  List<int> arr = [64, 34, 25, 12, 22];
  print('Array awal: \$arr');
  mergeSort(arr, 0, arr.length - 1);
  print('Hasil akhir: \$arr');
}'''
          : '''void mergeSort(List<int> arr, int left, int right) {
  if (left < right) {
    int mid = left + (right - left) ~/ 2;
    mergeSort(arr, left, mid);
    mergeSort(arr, mid + 1, right);
    merge(arr, left, mid, right);
  }
}

void merge(List<int> arr, int left, int mid, int right) {
  List<int> leftArr = arr.sublist(left, mid + 1);
  List<int> rightArr = arr.sublist(mid + 1, right + 1);
  
  int i = 0, j = 0, k = left;
  
  while (i < leftArr.length && j < rightArr.length) {
    if (leftArr[i] <= rightArr[j]) {
      arr[k++] = leftArr[i++];
    } else {
      arr[k++] = rightArr[j++];
    }
  }
  
  while (i < leftArr.length) arr[k++] = leftArr[i++];
  while (j < rightArr.length) arr[k++] = rightArr[j++];
}

void main() {
  List<int> arr = [64, 34, 25, 12, 22];
  print('Initial Array: \$arr');
  mergeSort(arr, 0, arr.length - 1);
  print('Final Result: \$arr');
}''',

      output: isId
          ? '''Array awal: [64, 34, 25, 12, 22]
Hasil akhir: [12, 22, 25, 34, 64]'''
          : '''Initial Array: [64, 34, 25, 12, 22]
Final Result: [12, 22, 25, 34, 64]''',

      timeComplexity: 'merge_time_complexity',
      spaceComplexity: 'merge_space_complexity',

      advantages: [
        'merge_advantage_1',
        'merge_advantage_2',
        'merge_advantage_3',
      ],

      disadvantages: ['merge_disadvantage_1', 'merge_disadvantage_2'],

      visualSteps: [
        'merge_visual_step_1',
        'merge_visual_step_2',
        'merge_visual_step_3',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'merge_quiz_1_question',
          correctAnswer:
              '''void merge(List<int> arr, int left, int mid, int right) {
  List<int> leftArr = arr.sublist(left, mid + 1);
  List<int> rightArr = arr.sublist(mid + 1, right + 1);
  int i = 0, j = 0, k = left;
  while (i < leftArr.length && j < rightArr.length) {
    if (leftArr[i] <= rightArr[j]) {
      arr[k++] = leftArr[i++];
    } else {
      arr[k++] = rightArr[j++];
    }
  }
  while (i < leftArr.length) arr[k++] = leftArr[i++];
  while (j < rightArr.length) arr[k++] = rightArr[j++];
}''',
          codeTemplate:
              '''void merge(List<int> arr, int left, int mid, int right) {
  // Implementasikan merge
  
}''',
          hint: 'merge_quiz_1_hint',
        ),
      ],

      useCases: 'merge_use_cases',
      realWorldExample: 'merge_real_world',
    );
  }
}
