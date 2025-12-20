import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../data/datasources/algorithm_content_datasource.dart';
import '../../domain/entities/algorithm_content_entity.dart';
import '../provider/learning_provider.dart';

/// Universal provider untuk SEMUA algoritma pembelajaran
/// Menggantikan provider spesifik per algoritma
class UniversalAlgorithmProvider with ChangeNotifier {
  final AlgorithmContentDataSource _dataSource = AlgorithmContentDataSource();

  AlgorithmContentEntity? _content;
  AlgorithmContentEntity? get content => _content;

  String _output = '';
  String get output => _output;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Quiz state
  final Map<int, String> _userAnswers = {};
  final Map<int, bool?> _quizResults = {};
  final Map<int, String> _quizOutputs = {};

  // Progress tracking
  double _progress = 0.0;
  double get progress => _progress;

  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;

  String? _currentAlgorithmId;
  LearningProvider? _learningProvider;

  void setLearningProvider(LearningProvider provider) {
    _learningProvider = provider;
  }

  // Getters untuk quiz
  Map<int, String> get userAnswers => _userAnswers;
  Map<int, bool?> get quizResults => _quizResults;
  Map<int, String> get quizOutputs => _quizOutputs;

  int get totalQuizzes => _content?.quizQuestions.length ?? 0;
  int get completedQuizzes =>
      _quizResults.values.where((r) => r == true).length;

  /// Load content berdasarkan algorithm ID
  /// [languageCode] required to load localized content
  Future<void> loadContent(String algorithmId, String languageCode) async {
    _isLoading = true;
    _error = null;
    _currentAlgorithmId = algorithmId;
    notifyListeners();

    try {
      _content = _dataSource.getContentById(algorithmId, languageCode);

      if (_content == null) {
        _error = 'error_content_not_found';
        AppLogger.warning('Content not found for algorithm: $algorithmId');
      } else {
        // Log algorithm start
        sl<AnalyticsService>().logAlgorithmStarted(algorithmId);
        AppLogger.info('Started learning algorithm: $algorithmId');

        // Load progress
        await _loadProgress();

        // Initialize quiz controllers
        _userAnswers.clear();
        _quizResults.clear();
        _quizOutputs.clear();

        for (int i = 0; i < _content!.quizQuestions.length; i++) {
          _userAnswers[i] = _content!.quizQuestions[i].codeTemplate;
          _quizResults[i] = null;
          _quizOutputs[i] = '';
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Run code example
  void runCode() {
    if (_content == null) return;

    _output = _content!.output;
    _updateProgress();
    notifyListeners();
  }

  /// Submit quiz answer
  /// [localizations] is required to generate localized feedback messages
  void submitQuiz(
    int index,
    String userAnswer,
    AppLocalizations localizations,
  ) {
    if (_content == null || index >= _content!.quizQuestions.length) return;

    final question = _content!.quizQuestions[index];
    final correctAnswer = question.correctAnswer.trim();
    final userAnswerTrimmed = userAnswer.trim();

    final isCorrect = _compareCode(correctAnswer, userAnswerTrimmed);

    _quizResults[index] = isCorrect;
    _userAnswers[index] = userAnswer;

    if (isCorrect) {
      _quizOutputs[index] =
          '${localizations.translate('quiz_correct_msg')}\n\n${localizations.translate('quiz_explanation')}\n${_getExplanation(index, localizations)}';
    } else {
      _quizOutputs[index] =
          '${localizations.translate('quiz_incorrect_msg')}\n\n${localizations.translate('quiz_hint')} ${localizations.translate(question.hint)}\n\n${localizations.translate('quiz_expected_msg')}\n${question.correctAnswer}';
    }

    _updateProgress();
    notifyListeners();
  }

  /// Compare code (normalize whitespace and comments)
  bool _compareCode(String correct, String user) {
    String normalize(String code) {
      return code
          .replaceAll(RegExp(r'\s+'), ' ')
          .replaceAll(RegExp(r'//.*'), '')
          .trim();
    }

    return normalize(correct) == normalize(user);
  }

  /// Get explanation for quiz
  String _getExplanation(int index, AppLocalizations localizations) {
    return localizations.translate('quiz_default_explanation');
  }

  /// Reset quiz
  void resetQuiz(int index) {
    if (_content == null || index >= _content!.quizQuestions.length) return;

    _userAnswers[index] = _content!.quizQuestions[index].codeTemplate;
    _quizResults[index] = null;
    _quizOutputs[index] = '';

    _updateProgress();
    notifyListeners();
  }

  /// Reset all quizzes
  void resetAllQuizzes() {
    if (_content == null) return;

    for (int i = 0; i < _content!.quizQuestions.length; i++) {
      resetQuiz(i);
    }
  }

  /// Reset entire progress for this algorithm
  Future<void> resetProgress() async {
    if (_content == null) return;

    _output = '';
    _userAnswers.clear();
    _quizResults.clear();
    _quizOutputs.clear();

    // Reset inputs to templates
    for (int i = 0; i < _content!.quizQuestions.length; i++) {
      _userAnswers[i] = _content!.quizQuestions[i].codeTemplate;
      _quizResults[i] = null;
      _quizOutputs[i] = '';
    }

    _progress = 0.0;
    _isCompleted = false;

    await _saveProgress();
    notifyListeners();
  }

  /// Update progress
  void _updateProgress() {
    double sectionProgress = 0.0;

    // 20% untuk membuka konten
    if (_content != null) sectionProgress += 0.2;

    // 20% untuk menjalankan kode
    if (_output.isNotEmpty) sectionProgress += 0.2;

    // 60% untuk quiz
    if (totalQuizzes > 0) {
      final quizProgress = (completedQuizzes / totalQuizzes) * 0.6;
      sectionProgress += quizProgress;
    }

    _progress = sectionProgress;

    // Check completion
    if (totalQuizzes > 0 && completedQuizzes == totalQuizzes) {
      final allCorrect = _quizResults.values.every((result) => result == true);
      _isCompleted = allCorrect;

      if (_isCompleted) {
        sl<AnalyticsService>().logAlgorithmCompleted(_currentAlgorithmId!);
        AppLogger.info('Completed algorithm: $_currentAlgorithmId');
      }
    }

    _saveProgress();
  }

  /// Load progress from SharedPreferences
  Future<void> _loadProgress() async {
    if (_currentAlgorithmId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      _progress = prefs.getDouble('${_currentAlgorithmId}_progress') ?? 0.0;
      _isCompleted = prefs.getBool('${_currentAlgorithmId}_completed') ?? false;
    } catch (e) {
      debugPrint('Error loading progress: $e');
    }
  }

  /// Save progress to SharedPreferences
  Future<void> _saveProgress() async {
    if (_currentAlgorithmId == null) return;

    try {
      // Sync with Global Learning Provider
      if (_learningProvider != null) {
        await _learningProvider!.updateProgress(
          _currentAlgorithmId!,
          _progress,
        );
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('${_currentAlgorithmId}_progress', _progress);
      await prefs.setBool('${_currentAlgorithmId}_completed', _isCompleted);
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  /// Clear all data
  void clear() {
    _content = null;
    _output = '';
    _error = null;
    _userAnswers.clear();
    _quizResults.clear();
    _quizOutputs.clear();
    _progress = 0.0;
    _isCompleted = false;
    _currentAlgorithmId = null;
    notifyListeners();
  }
}
