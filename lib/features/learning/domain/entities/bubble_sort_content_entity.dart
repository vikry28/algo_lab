class BubbleSortContentEntity {
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

  const BubbleSortContentEntity({
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
}

class QuizQuestion {
  final String question;
  final String correctAnswer;
  final String codeTemplate;
  final String hint;

  const QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.codeTemplate,
    required this.hint,
  });
}
