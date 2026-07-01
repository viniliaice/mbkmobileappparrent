enum MathTopic {
  counting,
  numberRecognition,
  addition,
  subtraction,
  multiplication,
  division,
  fractions,
  decimals,
  time,
  money,
  measurement,
  geometry,
  patterns,
  wordProblems,
  placeValue,
}

enum Difficulty { easy, medium, hard }

enum QuestionType {
  multipleChoice,
  fillBlank,
  tapCorrect,
  dragOrder,
  numberLine,
  matching,
}

class MathQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final MathTopic topic;
  final Difficulty difficulty;
  final QuestionType type;
  final int grade;
  final String hint;
  final String explanation;

  const MathQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.topic,
    required this.difficulty,
    required this.type,
    required this.grade,
    this.hint = '',
    this.explanation = '',
  });
}
