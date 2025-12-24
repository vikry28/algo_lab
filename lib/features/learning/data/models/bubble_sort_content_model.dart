import '../../domain/entities/bubble_sort_content_entity.dart';

class BubbleSortContentModel {
  final String summaryText;
  final String understandingText;
  final List<String> algorithmSteps;
  final String codeExample;
  final String output;
  final String timeComplexity;
  final String spaceComplexity;
  final List<String> advantages;
  final List<String> disadvantages;
  final List<String> visualSteps;
  final List<QuizQuestion> quizQuestions;

  const BubbleSortContentModel({
    required this.summaryText,
    required this.understandingText,
    required this.algorithmSteps,
    required this.codeExample,
    required this.output,
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.advantages,
    required this.disadvantages,
    required this.visualSteps,
    required this.quizQuestions,
  });

  BubbleSortContentEntity toEntity() {
    return BubbleSortContentEntity(
      summaryText: summaryText,
      understandingText: understandingText,
      algorithmSteps: algorithmSteps,
      codeExample: codeExample,
      output: output,
      timeComplexity: timeComplexity,
      spaceComplexity: spaceComplexity,
      advantages: advantages,
      disadvantages: disadvantages,
      visualSteps: visualSteps,
      quizQuestions: quizQuestions,
    );
  }

  factory BubbleSortContentModel.fromJson(Map<String, dynamic> json) {
    return BubbleSortContentModel(
      summaryText: json['summaryText'] ?? '',
      understandingText: json['understandingText'] ?? '',
      algorithmSteps: List<String>.from(json['algorithmSteps'] ?? []),
      codeExample: json['codeExample'] ?? '',
      output: json['output'] ?? '',
      timeComplexity: json['timeComplexity'] ?? '',
      spaceComplexity: json['spaceComplexity'] ?? '',
      advantages: List<String>.from(json['advantages'] ?? []),
      disadvantages: List<String>.from(json['disadvantages'] ?? []),
      visualSteps: List<String>.from(json['visualSteps'] ?? []),
      quizQuestions:
          (json['quizQuestions'] as List?)
              ?.map(
                (q) => QuizQuestion(
                  question: q['question'] ?? '',
                  correctAnswer: q['correctAnswer'] ?? '',
                  codeTemplate: q['codeTemplate'] ?? '',
                  hint: q['hint'] ?? '',
                ),
              )
              .toList() ??
          [],
    );
  }
}
