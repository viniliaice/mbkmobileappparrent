import 'math_question.dart';

class MathLesson {
  final String id;
  final String title;
  final String description;
  final Difficulty difficulty;
  final MathTopic topic;
  final int xpReward;

  const MathLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.topic,
    required this.xpReward,
  });
}
