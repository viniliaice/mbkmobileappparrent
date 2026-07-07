import 'package:flutter/material.dart';
import 'lesson.dart';
import 'vocab_word.dart';
import 'geo_shape.dart';

class LearningTopic {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int order;
  final List<LearningLesson> lessons;

  const LearningTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.order,
    required this.lessons,
  });
}

class LearningLesson {
  final String id;
  final String title;
  final String objective;
  final String explanation;
  final List<LearningActivity> activities;
  final int xpReward;
  final String badgeName;
  final String? badgeIcon;
  final List<VocabWord>? vocabWords;
  final List<ShapeIntro>? shapeIntros;

  const LearningLesson({
    required this.id,
    required this.title,
    required this.objective,
    required this.explanation,
    required this.activities,
    this.xpReward = 50,
    this.badgeName = '',
    this.badgeIcon,
    this.vocabWords,
    this.shapeIntros,
  });
}

