import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int xpThreshold;
  final String? requiredLessonId;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.xpThreshold = 0,
    this.requiredLessonId,
  });
}
