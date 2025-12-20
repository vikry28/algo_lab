import '../../domain/entities/algorithm_content_entity.dart';

/// Konten pembelajaran untuk SEMUA algoritma sorting
class SortingAlgorithmsContent {
  // Insertion Sort
  static AlgorithmContentEntity getInsertionSort(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'insertion_summary',
      understandingText: 'insertion_understanding',

      algorithmSteps: [
        'insertion_step_1',
        'insertion_step_2',
        'insertion_step_3',
        'insertion_step_4',
        'insertion_step_5',
        'insertion_step_6',
      ],

      codeExample: isId
          ? '''void insertionSort(List<int> arr) {
  int n = arr.length;
  
  for (int i = 1; i < n; i++) {
    int key = arr[i];
    int j = i - 1;
    
    print('Menyisipkan: \$key');
    
    // Geser elemen yang lebih besar ke kanan
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j--;
    }
    
    arr[j + 1] = key;
    print('Hasil: \$arr\\n');
  }
}

void main() {
  List<int> arr = [12, 11, 13, 5, 6];
  print('Array awal: \$arr\\n');
  insertionSort(arr);
  print('Hasil akhir: \$arr');
}'''
          : '''void insertionSort(List<int> arr) {
  int n = arr.length;
  
  for (int i = 1; i < n; i++) {
    int key = arr[i];
    int j = i - 1;
    
    print('Inserting: \$key');
    
    // Shift larger elements to the right
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j--;
    }
    
    arr[j + 1] = key;
    print('Result: \$arr\\n');
  }
}

void main() {
  List<int> arr = [12, 11, 13, 5, 6];
  print('Initial Array: \$arr\\n');
  insertionSort(arr);
  print('Final Result: \$arr');
}''',

      output: isId
          ? '''Array awal: [12, 11, 13, 5, 6]

Menyisipkan: 11
Hasil: [11, 12, 13, 5, 6]

Menyisipkan: 13
Hasil: [11, 12, 13, 5, 6]

Menyisipkan: 5
Hasil: [5, 11, 12, 13, 6]

Menyisipkan: 6
Hasil: [5, 6, 11, 12, 13]

Hasil akhir: [5, 6, 11, 12, 13]'''
          : '''Initial Array: [12, 11, 13, 5, 6]

Inserting: 11
Result: [11, 12, 13, 5, 6]

Inserting: 13
Result: [11, 12, 13, 5, 6]

Inserting: 5
Result: [5, 11, 12, 13, 6]

Inserting: 6
Result: [5, 6, 11, 12, 13]

Final Result: [5, 6, 11, 12, 13]''',

      timeComplexity: 'insertion_time_complexity',
      spaceComplexity: 'insertion_space_complexity',

      advantages: [
        'insertion_advantage_1',
        'insertion_advantage_2',
        'insertion_advantage_3',
        'insertion_advantage_4',
        'insertion_advantage_5',
      ],

      disadvantages: [
        'insertion_disadvantage_1',
        'insertion_disadvantage_2',
        'insertion_disadvantage_3',
      ],

      visualSteps: [
        'insertion_visual_step_1',
        'insertion_visual_step_2',
        'insertion_visual_step_3',
        'insertion_visual_step_4',
        'insertion_visual_step_5',
        'insertion_visual_step_6',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'insertion_quiz_1_question',
          correctAnswer: '''void insertionSort(List<int> arr) {
  for (int i = 1; i < arr.length; i++) {
    int key = arr[i];
    int j = i - 1;
    
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j--;
    }
    
    arr[j + 1] = key;
  }
}''',
          codeTemplate: isId
              ? '''void insertionSort(List<int> arr) {
  // Implementasikan insertion sort
  
}'''
              : '''void insertionSort(List<int> arr) {
  // Implement insertion sort
  
}''',
          hint: 'insertion_quiz_1_hint',
        ),
      ],

      useCases: 'insertion_use_cases',
      realWorldExample: 'insertion_real_world',
    );
  }

  // Selection Sort
  static AlgorithmContentEntity getSelectionSort(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'selection_summary',
      understandingText: 'selection_understanding',

      algorithmSteps: [
        'selection_step_1',
        'selection_step_2',
        'selection_step_3',
        'selection_step_4',
        'selection_step_5',
      ],

      codeExample: isId
          ? '''void selectionSort(List<int> arr) {
  int n = arr.length;
  
  for (int i = 0; i < n - 1; i++) {
    int minIdx = i;
    
    // Cari elemen minimum
    for (int j = i + 1; j < n; j++) {
      if (arr[j] < arr[minIdx]) {
        minIdx = j;
      }
    }
    
    // Swap
    if (minIdx != i) {
      int temp = arr[i];
      arr[i] = arr[minIdx];
      arr[minIdx] = temp;
      print('Swap \${arr[minIdx]} dengan \${arr[i]}: \$arr');
    }
  }
}

void main() {
  List<int> arr = [64, 25, 12, 22, 11];
  print('Array awal: \$arr\\n');
  selectionSort(arr);
  print('\\nHasil akhir: \$arr');
}'''
          : '''void selectionSort(List<int> arr) {
  int n = arr.length;
  
  for (int i = 0; i < n - 1; i++) {
    int minIdx = i;
    
    // Find minimum element
    for (int j = i + 1; j < n; j++) {
      if (arr[j] < arr[minIdx]) {
        minIdx = j;
      }
    }
    
    // Swap
    if (minIdx != i) {
      int temp = arr[i];
      arr[i] = arr[minIdx];
      arr[minIdx] = temp;
      print('Swap \${arr[minIdx]} with \${arr[i]}: \$arr');
    }
  }
}

void main() {
  List<int> arr = [64, 25, 12, 22, 11];
  print('Initial Array: \$arr\\n');
  selectionSort(arr);
  print('\\nFinal Result: \$arr');
}''',

      output: isId
          ? '''Array awal: [64, 25, 12, 22, 11]

Swap 64 dengan 11: [11, 25, 12, 22, 64]
Swap 25 dengan 12: [11, 12, 25, 22, 64]
Swap 25 dengan 22: [11, 12, 22, 25, 64]

Hasil akhir: [11, 12, 22, 25, 64]'''
          : '''Initial Array: [64, 25, 12, 22, 11]

Swap 64 with 11: [11, 25, 12, 22, 64]
Swap 25 with 12: [11, 12, 25, 22, 64]
Swap 25 with 22: [11, 12, 22, 25, 64]

Final Result: [11, 12, 22, 25, 64]''',

      timeComplexity: 'selection_time_complexity',
      spaceComplexity: 'selection_space_complexity',

      advantages: [
        'selection_advantage_1',
        'selection_advantage_2',
        'selection_advantage_3',
        'selection_advantage_4',
      ],

      disadvantages: [
        'selection_disadvantage_1',
        'selection_disadvantage_2',
        'selection_disadvantage_3',
        'selection_disadvantage_4',
      ],

      visualSteps: [
        'selection_visual_step_1',
        'selection_visual_step_2',
        'selection_visual_step_3',
        'selection_visual_step_4',
        'selection_visual_step_5',
        'selection_visual_step_6',
        'selection_visual_step_7',
        'selection_visual_step_8',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'selection_quiz_1_question',
          correctAnswer: '''void selectionSort(List<int> arr) {
  int n = arr.length;
  
  for (int i = 0; i < n - 1; i++) {
    int minIdx = i;
    
    for (int j = i + 1; j < n; j++) {
      if (arr[j] < arr[minIdx]) {
        minIdx = j;
      }
    }
    
    if (minIdx != i) {
      int temp = arr[i];
      arr[i] = arr[minIdx];
      arr[minIdx] = temp;
    }
  }
}''',
          codeTemplate: isId
              ? '''void selectionSort(List<int> arr) {
  // Implementasikan selection sort
  
}'''
              : '''void selectionSort(List<int> arr) {
  // Implement selection sort
  
}''',
          hint: 'selection_quiz_1_hint',
        ),
      ],

      useCases: 'selection_use_cases',
      realWorldExample: 'selection_real_world',
    );
  }

  // Heap Sort
  static AlgorithmContentEntity getHeapSort(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'heap_summary',
      understandingText: 'heap_understanding',

      algorithmSteps: [
        'heap_step_1',
        'heap_step_2',
        'heap_step_3',
        'heap_step_4',
        'heap_step_5',
      ],

      codeExample: isId
          ? '''void heapSort(List<int> arr) {
  int n = arr.length;
  
  // Bangun max heap
  for (int i = n ~/ 2 - 1; i >= 0; i--) {
    heapify(arr, n, i);
  }
  
  // Extract elemen satu per satu
  for (int i = n - 1; i > 0; i--) {
    // Swap root dengan elemen terakhir
    int temp = arr[0];
    arr[0] = arr[i];
    arr[i] = temp;
    
    // Heapify root
    heapify(arr, i, 0);
  }
}

void heapify(List<int> arr, int n, int i) {
  int largest = i;
  int left = 2 * i + 1;
  int right = 2 * i + 2;
  
  if (left < n && arr[left] > arr[largest]) {
    largest = left;
  }
  
  if (right < n && arr[right] > arr[largest]) {
    largest = right;
  }
  
  if (largest != i) {
    int temp = arr[i];
    arr[i] = arr[largest];
    arr[largest] = temp;
    
    heapify(arr, n, largest);
  }
}

void main() {
  List<int> arr = [12, 11, 13, 5, 6, 7];
  print('Array awal: \$arr');
  heapSort(arr);
  print('Hasil akhir: \$arr');
}'''
          : '''void heapSort(List<int> arr) {
  int n = arr.length;
  
  // Build max heap
  for (int i = n ~/ 2 - 1; i >= 0; i--) {
    heapify(arr, n, i);
  }
  
  // Extract elements one by one
  for (int i = n - 1; i > 0; i--) {
    // Swap root with last element
    int temp = arr[0];
    arr[0] = arr[i];
    arr[i] = temp;
    
    // Heapify root
    heapify(arr, i, 0);
  }
}

void heapify(List<int> arr, int n, int i) {
  int largest = i;
  int left = 2 * i + 1;
  int right = 2 * i + 2;
  
  if (left < n && arr[left] > arr[largest]) {
    largest = left;
  }
  
  if (right < n && arr[right] > arr[largest]) {
    largest = right;
  }
  
  if (largest != i) {
    int temp = arr[i];
    arr[i] = arr[largest];
    arr[largest] = temp;
    
    heapify(arr, n, largest);
  }
}

void main() {
  List<int> arr = [12, 11, 13, 5, 6, 7];
  print('Initial Array: \$arr');
  heapSort(arr);
  print('Final Result: \$arr');
}''',

      output: isId
          ? '''Array awal: [12, 11, 13, 5, 6, 7]
Hasil akhir: [5, 6, 7, 11, 12, 13]'''
          : '''Initial Array: [12, 11, 13, 5, 6, 7]
Final Result: [5, 6, 7, 11, 12, 13]''',

      timeComplexity: 'heap_time_complexity',
      spaceComplexity: 'heap_space_complexity',

      advantages: [
        'heap_advantage_1',
        'heap_advantage_2',
        'heap_advantage_3',
        'heap_advantage_4',
      ],

      disadvantages: [
        'heap_disadvantage_1',
        'heap_disadvantage_2',
        'heap_disadvantage_3',
        'heap_disadvantage_4',
      ],

      visualSteps: [
        'heap_visual_step_1',
        'heap_visual_step_2',
        'heap_visual_step_3',
        'heap_visual_step_4',
        'heap_visual_step_5',
        'heap_visual_step_6',
        'heap_visual_step_7',
        'heap_visual_step_8',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'heap_quiz_1_question',
          correctAnswer: '''void heapify(List<int> arr, int n, int i) {
  int largest = i;
  int left = 2 * i + 1;
  int right = 2 * i + 2;
  
  if (left < n && arr[left] > arr[largest]) {
    largest = left;
  }
  
  if (right < n && arr[right] > arr[largest]) {
    largest = right;
  }
  
  if (largest != i) {
    int temp = arr[i];
    arr[i] = arr[largest];
    arr[largest] = temp;
    heapify(arr, n, largest);
  }
}''',
          codeTemplate: isId
              ? '''void heapify(List<int> arr, int n, int i) {
  // Implementasikan heapify
  
}'''
              : '''void heapify(List<int> arr, int n, int i) {
  // Implement heapify
  
}''',
          hint: 'heap_quiz_1_hint',
        ),
      ],

      useCases: 'heap_use_cases',
      realWorldExample: 'heap_real_world',
    );
  }
}
