import '../../domain/entities/bubble_sort_content_entity.dart';
import '../models/bubble_sort_content_model.dart';

class BubbleSortContentDataSource {
  // Dart code example untuk bubble sort dengan studi kasus nyata
  static const String _dartCodeExample =
      '''// Studi Kasus: Mengurutkan Nilai Ujian Siswa
// Seorang guru memiliki daftar nilai ujian yang perlu diurutkan

void bubbleSort(List<int> scores) {
  int n = scores.length;
  print('Nilai awal: \$scores\\n');
  
  for (int i = 0; i < n - 1; i++) {
    print('--- Pass \${i + 1} ---');
    bool swapped = false;
    
    for (int j = 0; j < n - i - 1; j++) {
      print('Bandingkan: \${scores[j]} vs \${scores[j + 1]}');
      
      if (scores[j] > scores[j + 1]) {
        // Swap elemen
        int temp = scores[j];
        scores[j] = scores[j + 1];
        scores[j + 1] = temp;
        swapped = true;
        print('  → Tukar! Hasil: \$scores');
      } else {
        print('  → Tidak perlu tukar');
      }
    }
    
    print('Setelah pass \${i + 1}: \$scores\\n');
    
    // Optimasi: jika tidak ada swap, array sudah terurut
    if (!swapped) {
      print('Tidak ada pertukaran, array sudah terurut!');
      break;
    }
  }
}

void main() {
  // Nilai ujian 7 siswa (skala 0-100)
  List<int> studentScores = [64, 34, 25, 12, 22, 11, 90];
  
  print('=== BUBBLE SORT: Mengurutkan Nilai Siswa ===\\n');
  bubbleSort(studentScores);
  
  print('\\n=== HASIL AKHIR ===');
  print('Nilai terurut: \$studentScores');
  print('Nilai terendah: \${studentScores.first}');
  print('Nilai tertinggi: \${studentScores.last}');
}''';

  static const String _output = '''=== BUBBLE SORT: Mengurutkan Nilai Siswa ===

Nilai awal: [64, 34, 25, 12, 22, 11, 90]

--- Pass 1 ---
Bandingkan: 64 vs 34
  → Tukar! Hasil: [34, 64, 25, 12, 22, 11, 90]
Bandingkan: 64 vs 25
  → Tukar! Hasil: [34, 25, 64, 12, 22, 11, 90]
Bandingkan: 64 vs 12
  → Tukar! Hasil: [34, 25, 12, 64, 22, 11, 90]
Bandingkan: 64 vs 22
  → Tukar! Hasil: [34, 25, 12, 22, 64, 11, 90]
Bandingkan: 64 vs 11
  → Tukar! Hasil: [34, 25, 12, 22, 11, 64, 90]
Bandingkan: 64 vs 90
  → Tidak perlu tukar
Setelah pass 1: [34, 25, 12, 22, 11, 64, 90]

--- Pass 2 ---
Bandingkan: 34 vs 25
  → Tukar! Hasil: [25, 34, 12, 22, 11, 64, 90]
Bandingkan: 34 vs 12
  → Tukar! Hasil: [25, 12, 34, 22, 11, 64, 90]
Bandingkan: 34 vs 22
  → Tukar! Hasil: [25, 12, 22, 34, 11, 64, 90]
Bandingkan: 34 vs 11
  → Tukar! Hasil: [25, 12, 22, 11, 34, 64, 90]
Bandingkan: 34 vs 64
  → Tidak perlu tukar
Setelah pass 2: [25, 12, 22, 11, 34, 64, 90]

... (proses berlanjut) ...

=== HASIL AKHIR ===
Nilai terurut: [11, 12, 22, 25, 34, 64, 90]
Nilai terendah: 11
Nilai tertinggi: 90''';

  static const String _timeComplexity =
      '''• Best Case: O(n) - ketika array sudah terurut
• Average Case: O(n²) - ketika array acak
• Worst Case: O(n²) - ketika array terurut terbalik''';

  static const String _spaceComplexity =
      '''• O(1) - hanya membutuhkan variabel temporary untuk swap
• In-place sorting algorithm (tidak memerlukan array tambahan)''';

  static const List<String> _advantages = [
    'Mudah dipahami dan diimplementasikan',
    'Tidak memerlukan memori tambahan (in-place)',
    'Stabil - mempertahankan urutan elemen yang sama',
    'Dapat mendeteksi jika array sudah terurut',
  ];

  static const List<String> _disadvantages = [
    'Sangat lambat untuk dataset besar (O(n²))',
    'Tidak efisien dibanding algoritma modern',
    'Banyak operasi perbandingan dan swap',
    'Tidak cocok untuk aplikasi production',
  ];

  static const List<String> _visualSteps = [
    '📊 Array awal: [64, 34, 25, 12, 22]',
    '🔄 Pass 1: Bandingkan pasangan bersebelahan',
    '   64 > 34 → Tukar → [34, 64, 25, 12, 22]',
    '   64 > 25 → Tukar → [34, 25, 64, 12, 22]',
    '   64 > 12 → Tukar → [34, 25, 12, 64, 22]',
    '   64 > 22 → Tukar → [34, 25, 12, 22, 64] ✓',
    '🔄 Pass 2: Elemen terbesar sudah di akhir',
    '   34 > 25 → Tukar → [25, 34, 12, 22, 64]',
    '   34 > 12 → Tukar → [25, 12, 34, 22, 64]',
    '   34 > 22 → Tukar → [25, 12, 22, 34, 64] ✓',
    '🔄 Pass 3-4: Proses berlanjut...',
    '✅ Hasil akhir: [12, 22, 25, 34, 64]',
  ];

  static final List<QuizQuestion> _quizQuestions = [
    QuizQuestion(
      question:
          'Soal 1: Implementasikan fungsi bubbleSort yang mengurutkan array secara ascending',
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
      codeTemplate: '''void bubbleSort(List<int> arr) {
  // Tulis kode Anda di sini
  
}

void main() {
  List<int> numbers = [5, 2, 8, 1, 9];
  bubbleSort(numbers);
  print(numbers); // Output: [1, 2, 5, 8, 9]
}''',
      hint:
          'Gunakan nested loop. Loop luar untuk pass, loop dalam untuk perbandingan. Jangan lupa swap!',
    ),
    QuizQuestion(
      question:
          'Soal 2: Tambahkan optimasi untuk menghentikan sorting jika array sudah terurut',
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
      codeTemplate: '''void bubbleSortOptimized(List<int> arr) {
  // Tambahkan flag untuk deteksi jika sudah terurut
  
}

void main() {
  List<int> numbers = [1, 2, 3, 4, 5]; // Sudah terurut
  bubbleSortOptimized(numbers);
  print('Optimasi berhasil!');
}''',
      hint:
          'Gunakan boolean flag "swapped". Jika tidak ada swap dalam satu pass, array sudah terurut!',
    ),
    QuizQuestion(
      question:
          'Soal 3: Modifikasi bubble sort untuk mengurutkan secara descending (terbesar ke terkecil)',
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
      codeTemplate: '''void bubbleSortDescending(List<int> arr) {
  // Ubah kondisi perbandingan untuk descending
  
}

void main() {
  List<int> numbers = [3, 1, 4, 1, 5];
  bubbleSortDescending(numbers);
  print(numbers); // Output: [5, 4, 3, 1, 1]
}''',
      hint:
          'Ubah operator perbandingan dari > menjadi < untuk descending order',
    ),
  ];

  BubbleSortContentModel getBubbleSortContent({
    required String summaryText,
    required String understandingText,
    required List<String> algorithmSteps,
  }) {
    return BubbleSortContentModel(
      summaryText: summaryText,
      understandingText: understandingText,
      algorithmSteps: algorithmSteps,
      codeExample: _dartCodeExample,
      output: _output,
      timeComplexity: _timeComplexity,
      spaceComplexity: _spaceComplexity,
      advantages: _advantages,
      disadvantages: _disadvantages,
      visualSteps: _visualSteps,
      quizQuestions: _quizQuestions,
    );
  }
}
