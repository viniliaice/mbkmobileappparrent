import 'activity.dart';

class LearningActivity {
  final String id;
  final ActivityType type;
  final String question;
  final String hint;
  final List<String> options;
  final String correctAnswer;
  final int difficulty;
  final int order;

  const LearningActivity({
    required this.id,
    required this.type,
    required this.question,
    this.hint = '',
    this.options = const [],
    required this.correctAnswer,
    this.difficulty = 1,
    this.order = 0,
  });
}
