import '../../domain/entities/algorithm_content_entity.dart';

/// Konten pembelajaran untuk SEMUA algoritma pencarian
class SearchAlgorithmsContent {
  // Linear Search
  static AlgorithmContentEntity getLinearSearch(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'linear_summary',
      understandingText: 'linear_understanding',

      algorithmSteps: [
        'linear_step_1',
        'linear_step_2',
        'linear_step_3',
        'linear_step_4',
        'linear_step_5',
        'linear_step_6',
      ],

      codeExample: isId
          ? '''int linearSearch(List<int> arr, int target) {
  print('Mencari: \$target dalam \$arr\\n');
  
  for (int i = 0; i < arr.length; i++) {
    print('Cek index \$i: \${arr[i]}');
    
    if (arr[i] == target) {
      print('✅ Ditemukan di index \$i!');
      return i;
    }
  }
  
  print('❌ Tidak ditemukan');
  return -1;
}

void main() {
  List<int> arr = [64, 34, 25, 12, 22, 11, 90];
  
  int result1 = linearSearch(arr, 22);
  print('\\nHasil: index \$result1\\n');
  
  int result2 = linearSearch(arr, 100);
  print('\\nHasil: index \$result2');
}'''
          : '''int linearSearch(List<int> arr, int target) {
  print('Searching for: \$target in \$arr\\n');
  
  for (int i = 0; i < arr.length; i++) {
    print('Checking index \$i: \${arr[i]}');
    
    if (arr[i] == target) {
      print('✅ Found at index \$i!');
      return i;
    }
  }
  
  print('❌ Not found');
  return -1;
}

void main() {
  List<int> arr = [64, 34, 25, 12, 22, 11, 90];
  
  int result1 = linearSearch(arr, 22);
  print('\\nResult: index \$result1\\n');
  
  int result2 = linearSearch(arr, 100);
  print('\\nResult: index \$result2');
}''',

      output: isId
          ? '''Mencari: 22 dalam [64, 34, 25, 12, 22, 11, 90]

Cek index 0: 64
Cek index 1: 34
Cek index 2: 25
Cek index 3: 12
Cek index 4: 22
✅ Ditemukan di index 4!

Hasil: index 4

Mencari: 100 dalam [64, 34, 25, 12, 22, 11, 90]

Cek index 0: 64
Cek index 1: 34
Cek index 2: 25
Cek index 3: 12
Cek index 4: 22
Cek index 5: 11
Cek index 6: 90
❌ Tidak ditemukan

Hasil: index -1'''
          : '''Searching for: 22 in [64, 34, 25, 12, 22, 11, 90]

Checking index 0: 64
Checking index 1: 34
Checking index 2: 25
Checking index 3: 12
Checking index 4: 22
✅ Found at index 4!

Result: index 4

Searching for: 100 in [64, 34, 25, 12, 22, 11, 90]

Checking index 0: 64
Checking index 1: 34
Checking index 2: 25
Checking index 3: 12
Checking index 4: 22
Checking index 5: 11
Checking index 6: 90
❌ Not found

Result: index -1''',

      timeComplexity: 'linear_time_complexity',
      spaceComplexity: 'linear_space_complexity',

      advantages: [
        'linear_advantage_1',
        'linear_advantage_2',
        'linear_advantage_3',
        'linear_advantage_4',
        'linear_advantage_5',
      ],

      disadvantages: [
        'linear_disadvantage_1',
        'linear_disadvantage_2',
        'linear_disadvantage_3',
      ],

      visualSteps: [
        'linear_visual_step_1',
        'linear_visual_step_2',
        'linear_visual_step_3',
        'linear_visual_step_4',
        'linear_visual_step_5',
        'linear_visual_step_6',
        'linear_visual_step_7',
        'linear_visual_step_8',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'linear_quiz_1_question',
          correctAnswer: '''int linearSearch(List<int> arr, int target) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == target) {
      return i;
    }
  }
  return -1;
}''',
          codeTemplate: isId
              ? '''int linearSearch(List<int> arr, int target) {
  // Implementasikan linear search
  
}'''
              : '''int linearSearch(List<int> arr, int target) {
  // Implement linear search
  
}''',
          hint: 'linear_quiz_1_hint',
        ),
        QuizQuestion(
          question: 'linear_quiz_2_question',
          correctAnswer:
              '''List<int> linearSearchAll(List<int> arr, int target) {
  List<int> indices = [];
  
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == target) {
      indices.add(i);
    }
  }
  
  return indices;
}''',
          codeTemplate: isId
              ? '''List<int> linearSearchAll(List<int> arr, int target) {
  // Return list semua index yang cocok
  
}'''
              : '''List<int> linearSearchAll(List<int> arr, int target) {
  // Return list of all matching indices
  
}''',
          hint: 'linear_quiz_2_hint',
        ),
        QuizQuestion(
          question: 'linear_quiz_3_question',
          correctAnswer:
              '''int linearSearchSentinel(List<int> arr, int target) {
  int n = arr.length;
  int last = arr[n - 1];
  arr[n - 1] = target;
  
  int i = 0;
  while (arr[i] != target) {
    i++;
  }
  
  arr[n - 1] = last;
  
  if (i < n - 1 || arr[n - 1] == target) {
    return i;
  }
  return -1;
}''',
          codeTemplate: isId
              ? '''int linearSearchSentinel(List<int> arr, int target) {
  // Gunakan sentinel untuk menghindari cek i < n
  
}'''
              : '''int linearSearchSentinel(List<int> arr, int target) {
  // Use sentinel to avoid i < n check
  
}''',
          hint: 'linear_quiz_3_hint',
        ),
      ],

      useCases: 'linear_use_cases',
      realWorldExample: 'linear_real_world',
    );
  }

  // Binary Search
  static AlgorithmContentEntity getBinarySearch(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'binary_summary',
      understandingText: 'binary_understanding',

      algorithmSteps: [
        'binary_step_1',
        'binary_step_2',
        'binary_step_3',
        'binary_step_4',
        'binary_step_5',
        'binary_step_6',
      ],

      codeExample: isId
          ? '''int binarySearch(List<int> arr, int target) {
  int left = 0;
  int right = arr.length - 1;
  
  print('Mencari: \$target dalam \$arr\\n');
  
  while (left <= right) {
    int mid = left + (right - left) ~/ 2;
    
    print('Range [\$left..\$right], Mid=\$mid, Value=\${arr[mid]}');
    
    if (arr[mid] == target) {
      print('✅ Ditemukan di index \$mid!');
      return mid;
    }
    
    if (arr[mid] < target) {
      print('  → Cari di kanan\\n');
      left = mid + 1;
    } else {
      print('  → Cari di kiri\\n');
      right = mid - 1;
    }
  }
  
  print('❌ Tidak ditemukan');
  return -1;
}

void main() {
  List<int> arr = [11, 12, 22, 25, 34, 64, 90]; // HARUS TERURUT!
  
  int result = binarySearch(arr, 25);
  print('\\nHasil: index \$result');
}'''
          : '''int binarySearch(List<int> arr, int target) {
  int left = 0;
  int right = arr.length - 1;
  
  print('Searching for: \$target in \$arr\\n');
  
  while (left <= right) {
    int mid = left + (right - left) ~/ 2;
    
    print('Range [\$left..\$right], Mid=\$mid, Value=\${arr[mid]}');
    
    if (arr[mid] == target) {
      print('✅ Found at index \$mid!');
      return mid;
    }
    
    if (arr[mid] < target) {
      print('  → Search right\\n');
      left = mid + 1;
    } else {
      print('  → Search left\\n');
      right = mid - 1;
    }
  }
  
  print('❌ Not found');
  return -1;
}

void main() {
  List<int> arr = [11, 12, 22, 25, 34, 64, 90]; // MUST BE SORTED!
  
  int result = binarySearch(arr, 25);
  print('\\nResult: index \$result');
}''',

      output: isId
          ? '''Mencari: 25 dalam [11, 12, 22, 25, 34, 64, 90]

Range [0..6], Mid=3, Value=25
✅ Ditemukan di index 3!

Hasil: index 3'''
          : '''Searching for: 25 in [11, 12, 22, 25, 34, 64, 90]

Range [0..6], Mid=3, Value=25
✅ Found at index 3!

Result: index 3''',

      timeComplexity: 'binary_time_complexity',
      spaceComplexity: 'binary_space_complexity',

      advantages: [
        'binary_advantage_1',
        'binary_advantage_2',
        'binary_advantage_3',
        'binary_advantage_4',
      ],

      disadvantages: [
        'binary_disadvantage_1',
        'binary_disadvantage_2',
        'binary_disadvantage_3',
      ],

      visualSteps: [
        'binary_visual_step_1',
        'binary_visual_step_2',
        'binary_visual_step_3',
        'binary_visual_step_4',
        'binary_visual_step_5',
        'binary_visual_step_6',
        'binary_visual_step_7',
        'binary_visual_step_8',
        'binary_visual_step_9',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'binary_quiz_1_question',
          correctAnswer: '''int binarySearch(List<int> arr, int target) {
  int left = 0;
  int right = arr.length - 1;
  
  while (left <= right) {
    int mid = left + (right - left) ~/ 2;
    
    if (arr[mid] == target) {
      return mid;
    }
    
    if (arr[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  
  return -1;
}''',
          codeTemplate: isId
              ? '''int binarySearch(List<int> arr, int target) {
  // Implementasikan binary search iteratif
  
}'''
              : '''int binarySearch(List<int> arr, int target) {
  // Implement iterative binary search
  
}''',
          hint: 'binary_quiz_1_hint',
        ),
        QuizQuestion(
          question: 'binary_quiz_2_question',
          correctAnswer:
              '''int binarySearchRecursive(List<int> arr, int target, int left, int right) {
  if (left > right) return -1;
  
  int mid = left + (right - left) ~/ 2;
  
  if (arr[mid] == target) return mid;
  
  if (arr[mid] < target) {
    return binarySearchRecursive(arr, target, mid + 1, right);
  } else {
    return binarySearchRecursive(arr, target, left, mid - 1);
  }
}''',
          codeTemplate: isId
              ? '''int binarySearchRecursive(List<int> arr, int target, int left, int right) {
  // Implementasikan rekursif
  
}'''
              : '''int binarySearchRecursive(List<int> arr, int target, int left, int right) {
  // Implement recursive
  
}''',
          hint: 'binary_quiz_2_hint',
        ),
        QuizQuestion(
          question: 'binary_quiz_3_question',
          correctAnswer: '''int binarySearchFirst(List<int> arr, int target) {
  int left = 0, right = arr.length - 1;
  int result = -1;
  
  while (left <= right) {
    int mid = left + (right - left) ~/ 2;
    
    if (arr[mid] == target) {
      result = mid;
      right = mid - 1; // Cari di kiri
    } else if (arr[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  
  return result;
}''',
          codeTemplate: isId
              ? '''int binarySearchFirst(List<int> arr, int target) {
  // Cari kemunculan pertama
  
}'''
              : '''int binarySearchFirst(List<int> arr, int target) {
  // Find first occurrence
  
}''',
          hint: 'binary_quiz_3_hint',
        ),
      ],

      useCases: 'binary_use_cases',
      realWorldExample: 'binary_real_world',
    );
  }

  // Interpolation Search
  static AlgorithmContentEntity getInterpolationSearch(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'interpolation_summary',
      understandingText: 'interpolation_understanding',

      algorithmSteps: [
        'interpolation_step_1',
        'interpolation_step_2',
        'interpolation_step_3',
        'interpolation_step_4',
        'interpolation_step_5',
        'interpolation_step_6',
      ],

      codeExample: isId
          ? '''int interpolationSearch(List<int> arr, int target) {
  int low = 0;
  int high = arr.length - 1;
  
  print('Mencari: \$target dalam \$arr\\n');
  
  while (low <= high && target >= arr[low] && target <= arr[high]) {
    if (low == high) {
      if (arr[low] == target) return low;
      return -1;
    }
    
    // Hitung posisi dengan interpolasi
    int pos = low + 
      ((target - arr[low]) * (high - low) ~/ (arr[high] - arr[low]));
    
    print('Range [\$low..\$high], Pos=\$pos, Value=\${arr[pos]}');
    
    if (arr[pos] == target) {
      print('✅ Ditemukan di index \$pos!');
      return pos;
    }
    
    if (arr[pos] < target) {
      print('  → Cari di kanan\\n');
      low = pos + 1;
    } else {
      print('  → Cari di kiri\\n');
      high = pos - 1;
    }
  }
  
  print('❌ Tidak ditemukan');
  return -1;
}

void main() {
  List<int> arr = [10, 20, 30, 40, 50, 60, 70, 80, 90];
  
  int result = interpolationSearch(arr, 70);
  print('\\nHasil: index \$result');
}'''
          : '''int interpolationSearch(List<int> arr, int target) {
  int low = 0;
  int high = arr.length - 1;
  
  print('Searching for: \$target in \$arr\\n');
  
  while (low <= high && target >= arr[low] && target <= arr[high]) {
    if (low == high) {
      if (arr[low] == target) return low;
      return -1;
    }
    
    // Calculate position with interpolation
    int pos = low + 
      ((target - arr[low]) * (high - low) ~/ (arr[high] - arr[low]));
    
    print('Range [\$low..\$high], Pos=\$pos, Value=\${arr[pos]}');
    
    if (arr[pos] == target) {
      print('✅ Found at index \$pos!');
      return pos;
    }
    
    if (arr[pos] < target) {
      print('  → Search right\\n');
      low = pos + 1;
    } else {
      print('  → Search left\\n');
      high = pos - 1;
    }
  }
  
  print('❌ Not found');
  return -1;
}

void main() {
  List<int> arr = [10, 20, 30, 40, 50, 60, 70, 80, 90];
  
  int result = interpolationSearch(arr, 70);
  print('\\nResult: index \$result');
}''',

      output: isId
          ? '''Mencari: 70 dalam [10, 20, 30, 40, 50, 60, 70, 80, 90]

Range [0..8], Pos=6, Value=70
✅ Ditemukan di index 6!

Hasil: index 6'''
          : '''Searching for: 70 in [10, 20, 30, 40, 50, 60, 70, 80, 90]

Range [0..8], Pos=6, Value=70
✅ Found at index 6!

Result: index 6''',

      timeComplexity: 'interpolation_time_complexity',
      spaceComplexity: 'interpolation_space_complexity',

      advantages: [
        'interpolation_advantage_1',
        'interpolation_advantage_2',
        'interpolation_advantage_3',
      ],

      disadvantages: [
        'interpolation_disadvantage_1',
        'interpolation_disadvantage_2',
        'interpolation_disadvantage_3',
        'interpolation_disadvantage_4',
      ],

      visualSteps: [
        'interpolation_visual_step_1',
        'interpolation_visual_step_2',
        'interpolation_visual_step_3',
        'interpolation_visual_step_4',
        'interpolation_visual_step_5',
        'interpolation_visual_step_6',
        'interpolation_visual_step_7',
        'interpolation_visual_step_8',
        'interpolation_visual_step_9',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'interpolation_quiz_1_question',
          correctAnswer: '''int interpolationSearch(List<int> arr, int target) {
  int low = 0;
  int high = arr.length - 1;
  
  while (low <= high && target >= arr[low] && target <= arr[high]) {
    if (low == high) {
      if (arr[low] == target) return low;
      return -1;
    }
    
    int pos = low + 
      ((target - arr[low]) * (high - low) ~/ (arr[high] - arr[low]));
    
    if (arr[pos] == target) return pos;
    
    if (arr[pos] < target) {
      low = pos + 1;
    } else {
      high = pos - 1;
    }
  }
  
  return -1;
}''',
          codeTemplate: isId
              ? '''int interpolationSearch(List<int> arr, int target) {
  // Implementasikan interpolation search
  
}'''
              : '''int interpolationSearch(List<int> arr, int target) {
  // Implement interpolation search
  
}''',
          hint: 'interpolation_quiz_1_hint',
        ),
      ],

      useCases: 'interpolation_use_cases',
      realWorldExample: 'interpolation_real_world',
    );
  }
}
