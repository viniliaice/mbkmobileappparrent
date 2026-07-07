import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/lesson.dart';
import '../models/topic.dart';
import '../models/vocab_word.dart';
import '../models/geo_shape.dart';

/// Fluent factory helpers to create a [LearningActivity].
///
/// These reduce the boilerplate for declaring lessons. Examples:
///   A.mc('id', 'question?', 'hint', ['a','b','c'], 'b')
///   A.tap('id', 'Count 🍎🍎🍎', 'count them', ['2','3','4'], '3')
class A {
  const A._();

  static LearningActivity mc(
    String id,
    String question,
    String hint,
    List<String> options,
    String correct,
  ) =>
      LearningActivity(
        id: id,
        type: ActivityType.multipleChoice,
        question: question,
        hint: hint,
        options: options,
        correctAnswer: correct,
      );

  static LearningActivity tap(
    String id,
    String question,
    String hint,
    List<String> options,
    String correct,
  ) =>
      LearningActivity(
        id: id,
        type: ActivityType.tapCorrect,
        question: question,
        hint: hint,
        options: options,
        correctAnswer: correct,
      );

  static LearningActivity fb(
    String id,
    String question,
    String hint,
    List<String> options,
    String correct,
  ) =>
      LearningActivity(
        id: id,
        type: ActivityType.fillBlank,
        question: question,
        hint: hint,
        options: options,
        correctAnswer: correct,
      );

  static LearningActivity drag(
    String id,
    String question,
    String hint,
    List<String> options,
    String correct,
  ) =>
      LearningActivity(
        id: id,
        type: ActivityType.dragOrder,
        question: question,
        hint: hint,
        options: options,
        correctAnswer: correct,
      );

  static LearningActivity nl(
    String id,
    String question,
    String hint,
    List<String> options,
    String correct,
  ) =>
      LearningActivity(
        id: id,
        type: ActivityType.numberLine,
        question: question,
        hint: hint,
        options: options,
        correctAnswer: correct,
      );

  static LearningActivity mp(
    String id,
    String question,
    String hint,
    List<String> options,
    String correct,
  ) =>
      LearningActivity(
        id: id,
        type: ActivityType.matchPairs,
        question: question,
        hint: hint,
        options: options,
        correctAnswer: correct,
      );
}

/// A lesson descriptor. Use [toLesson] to materialize it.
class L {
  final String id;
  final String title;
  final String objective;
  final String explanation;
  final String badgeName;
  final String badgeIcon;
  final int xp;
  final List<LearningActivity> activities;
  final List<VocabWord>? vocabWords;
  final List<ShapeIntro>? shapeIntros;

  const L(
    this.id,
    this.title,
    this.objective,
    this.explanation,
    this.badgeName,
    this.badgeIcon, {
    required this.activities,
    this.xp = 50,
    this.vocabWords,
    this.shapeIntros,
  });

  LearningLesson toLesson() => LearningLesson(
        id: id,
        title: title,
        objective: objective,
        explanation: explanation,
        activities: activities,
        xpReward: xp,
        badgeName: badgeName,
        badgeIcon: badgeIcon,
        vocabWords: vocabWords,
        shapeIntros: shapeIntros,
      );
}

/// A topic descriptor with the metadata needed to build a [LearningTopic].
class T {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int order;
  final List<L> lessons;

  const T({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.order,
    required this.lessons,
  });

  LearningTopic toTopic() => LearningTopic(
        id: id,
        title: title,
        description: description,
        icon: icon,
        color: color,
        order: order,
        lessons: lessons.map((l) => l.toLesson()).toList(),
      );
}
