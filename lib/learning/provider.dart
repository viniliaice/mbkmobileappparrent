import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/progress.dart';
import 'models/achievement.dart';
import 'models/topic.dart';
import 'data/content.dart';

class LearningProvider extends ChangeNotifier {
  static const _prefsKey = 'learning_progress';
  static const _xpKey = 'learning_xp';

  final Map<String, Map<String, LessonProgress>> _progressByStudent = {};
  final Map<String, int> _xpByStudent = {};
  Set<String> _unlockedAchievements = {};
  DateTime? _lastActiveDate;
  int _currentStreak = 0;

  bool _loaded = false;
  Achievement? _lastUnlockedAchievement;

  Map<String, Map<String, LessonProgress>> get progressByStudent =>
      _progressByStudent;
  Map<String, int> get xpByStudent => _xpByStudent;
  Set<String> get unlockedAchievements => _unlockedAchievements;
  int get currentStreak => _currentStreak;
  bool get loaded => _loaded;
  Achievement? get lastUnlockedAchievement => _lastUnlockedAchievement;

  LessonProgress? getProgress(String studentId, String lessonId) =>
      _progressByStudent[studentId]?[lessonId];

  int getXp(String studentId) => _xpByStudent[studentId] ?? 0;

  bool isLessonCompleted(String studentId, String lessonId) =>
      _progressByStudent[studentId]?[lessonId]?.completed ?? false;

  bool isLessonUnlocked(String studentId, String lessonId,
      List<dynamic> topicLessons) {
    if (_progressByStudent[studentId] == null) return lessonId == topicLessons.first.id;
    for (int i = 0; i < topicLessons.length; i++) {
      if (topicLessons[i].id == lessonId) {
        if (i == 0) return true;
        return _progressByStudent[studentId]?[topicLessons[i - 1].id]?.completed ?? false;
      }
    }
    return false;
  }

  double getTopicProgress(String studentId, List<dynamic> topicLessons) {
    if (topicLessons.isEmpty) return 0;
    int completed = 0;
    for (final lesson in topicLessons) {
      if (_progressByStudent[studentId]?[lesson.id]?.completed ?? false) {
        completed++;
      }
    }
    return completed / topicLessons.length;
  }

  int get totalAchievements => achievements.length;
  int get unlockedCount => _unlockedAchievements.length;

  int getCompletedLessonsCount(String studentId) {
    if (_progressByStudent[studentId] == null) return 0;
    return _progressByStudent[studentId]!.values.where((p) => p.completed).length;
  }

  double getOverallAccuracy(String studentId) {
    if (_progressByStudent[studentId] == null) return 0;
    final lessons = _progressByStudent[studentId]!.values.where((p) => p.totalActivities > 0);
    if (lessons.isEmpty) return 0;
    final totalCorrect = lessons.fold<int>(0, (sum, p) => sum + p.correctCount);
    final total = lessons.fold<int>(0, (sum, p) => sum + p.totalActivities);
    if (total == 0) return 0;
    return totalCorrect / total;
  }

  Future<void> loadProgress() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      for (final studentEntry in decoded.entries) {
        final studentId = studentEntry.key;
        final lessonsMap = studentEntry.value as Map<String, dynamic>;
        _progressByStudent[studentId] = {};
        for (final lessonEntry in lessonsMap.entries) {
          _progressByStudent[studentId]![lessonEntry.key] =
              LessonProgress.fromJson(
                  lessonEntry.value as Map<String, dynamic>);
        }
      }
    }
    final xpRaw = prefs.getString(_xpKey);
    if (xpRaw != null) {
      final decoded = jsonDecode(xpRaw) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        _xpByStudent[entry.key] = entry.value as int;
      }
    }
    final streakDay = prefs.getInt('learning_streak_day');
    final streakCount = prefs.getInt('learning_streak_count');
    if (streakDay != null && streakCount != null) {
      _lastActiveDate = DateTime.fromMillisecondsSinceEpoch(streakDay);
      _currentStreak = streakCount;
      final now = DateTime.now();
      final diff = now.difference(_lastActiveDate!).inDays;
      if (diff > 1) _currentStreak = 0;
    }
    final achRaw = prefs.getString('learning_achievements');
    if (achRaw != null) {
      _unlockedAchievements = (jsonDecode(achRaw) as List<dynamic>).cast<String>().toSet();
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = <String, dynamic>{};
    for (final studentEntry in _progressByStudent.entries) {
      final lessonsMap = <String, dynamic>{};
      for (final lessonEntry in studentEntry.value.entries) {
        lessonsMap[lessonEntry.key] = lessonEntry.value.toJson();
      }
      encoded[studentEntry.key] = lessonsMap;
    }
    await prefs.setString(_prefsKey, jsonEncode(encoded));
    await prefs.setString(_xpKey, jsonEncode(_xpByStudent));
    await prefs.setString('learning_achievements', jsonEncode(_unlockedAchievements.toList()));
    await prefs.setInt('learning_streak_day', _lastActiveDate?.millisecondsSinceEpoch ?? 0);
    await prefs.setInt('learning_streak_count', _currentStreak);
  }

  int getTotalTimeSpent(String studentId) {
    if (_progressByStudent[studentId] == null) return 0;
    return _progressByStudent[studentId]!.values
        .fold<int>(0, (sum, p) => sum + p.timeSpentInSeconds);
  }

  Future<Achievement?> completeLesson(
      String studentId, String lessonId, int correctCount, int totalActivities, {int timeSpentInSeconds = 0}) async {
    _progressByStudent.putIfAbsent(studentId, () => {});
    final existing = _progressByStudent[studentId]![lessonId];
    _xpByStudent.putIfAbsent(studentId, () => 0);

    final lesson = _findLesson(lessonId);
    if (lesson == null) return null;

    final xpGained = lesson.xpReward;
    _xpByStudent[studentId] = _xpByStudent[studentId]! + xpGained;

    _progressByStudent[studentId]![lessonId] = LessonProgress(
      lessonId: lessonId,
      completed: true,
      xpEarned: (existing?.xpEarned ?? 0) + xpGained,
      totalAttempts: (existing?.totalAttempts ?? 0) + 1,
      correctCount: (existing?.correctCount ?? 0) + correctCount,
      totalActivities: (existing?.totalActivities ?? 0) + totalActivities,
      timeSpentInSeconds: (existing?.timeSpentInSeconds ?? 0) + timeSpentInSeconds,
      lastAttemptedAt: DateTime.now(),
      completedAt: DateTime.now(),
    );

    _updateStreak();
    _lastUnlockedAchievement = _checkNewAchievements(studentId);
    await _saveProgress();
    notifyListeners();
    return _lastUnlockedAchievement;
  }

  void _updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_lastActiveDate == null) {
      _currentStreak = 1;
    } else {
      final last = DateTime(_lastActiveDate!.year, _lastActiveDate!.month, _lastActiveDate!.day);
      final diff = today.difference(last).inDays;
      if (diff == 1) {
        _currentStreak++;
      } else if (diff > 1) {
        _currentStreak = 1;
      }
    }
    _lastActiveDate = today;
  }

  Achievement? _checkNewAchievements(String studentId) {
    final xp = _xpByStudent[studentId] ?? 0;
    final completed = getCompletedLessonsCount(studentId);
    final accuracy = getOverallAccuracy(studentId);

    for (final ach in achievements) {
      if (_unlockedAchievements.contains(ach.id)) continue;
      bool unlock = false;
      if (ach.id == 'first_lesson' && completed >= 1) unlock = true;
      if (ach.id == 'five_lessons' && completed >= 5) unlock = true;
      if (ach.id == 'ten_lessons' && completed >= 10) unlock = true;
      if (ach.id == 'xp_100' && xp >= 100) unlock = true;
      if (ach.id == 'xp_500' && xp >= 500) unlock = true;
      if (ach.id == 'perfect_accuracy' && accuracy >= 0.9 && completed >= 3) unlock = true;
      if (ach.id == 'streak_3' && _currentStreak >= 3) unlock = true;
      if (ach.id == 'streak_7' && _currentStreak >= 7) unlock = true;
      if (ach.id == 'math_starter' && _isSubjectCompleted(studentId, true) >= 3) unlock = true;
      if (ach.id == 'eng_starter' && _isSubjectCompleted(studentId, false) >= 3) unlock = true;
      if (ach.id == 'scholar' && completed >= 15) unlock = true;
      if (unlock) {
        _unlockedAchievements.add(ach.id);
        return ach;
      }
    }
    return null;
  }

  int _isSubjectCompleted(String studentId, bool isMath) {
    final topics = LearningContent.topicsForSubject(isMath);
    int count = 0;
    for (final topic in topics) {
      for (final lesson in topic.lessons) {
        if (_progressByStudent[studentId]?[lesson.id]?.completed ?? false) {
          count++;
        }
      }
    }
    return count;
  }

  void clearLastAchievement() {
    _lastUnlockedAchievement = null;
    notifyListeners();
  }

  LearningLesson? _findLesson(String lessonId) {
    for (final topic in [
      ...LearningContent.mathematics,
      ...LearningContent.english
    ]) {
      for (final lesson in topic.lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    return null;
  }

  Map<String, List<String>> getWeakStrongTopics(String studentId) {
    final weak = <String>[];
    final strong = <String>[];
    for (final topic in [
      ...LearningContent.mathematics,
      ...LearningContent.english
    ]) {
      if (topic.lessons.isEmpty) continue;
      int completed = 0;
      for (final lesson in topic.lessons) {
        if (_progressByStudent[studentId]?[lesson.id]?.completed ?? false) {
          completed++;
        }
      }
      final ratio = completed / topic.lessons.length;
      if (ratio >= 0.8) {
        strong.add(topic.title);
      } else if (ratio < 0.4 && completed > 0) {
        weak.add(topic.title);
      }
    }
    return {'weak': weak, 'strong': strong};
  }

  static List<Achievement> get achievements => [
        const Achievement(
          id: 'first_lesson',
          name: 'First Steps',
          description: 'Complete your first lesson',
          icon: Icons.directions_walk,
          color: Colors.green,
        ),
        const Achievement(
          id: 'five_lessons',
          name: 'Eager Learner',
          description: 'Complete 5 lessons',
          icon: Icons.school,
          color: Colors.blue,
        ),
        const Achievement(
          id: 'ten_lessons',
          name: 'Dedicated Student',
          description: 'Complete 10 lessons',
          icon: Icons.auto_awesome,
          color: Colors.purple,
        ),
        const Achievement(
          id: 'xp_100',
          name: 'Point Collector',
          description: 'Earn 100 XP',
          icon: Icons.stars,
          color: Colors.amber,
        ),
        const Achievement(
          id: 'xp_500',
          name: 'XP Champion',
          description: 'Earn 500 XP',
          icon: Icons.emoji_events,
          color: Colors.orange,
        ),
        const Achievement(
          id: 'perfect_accuracy',
          name: 'Perfect Score',
          description: 'Score 90% or higher across 3+ lessons',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        const Achievement(
          id: 'streak_3',
          name: 'Coming Back',
          description: 'Maintain a 3-day streak',
          icon: Icons.local_fire_department,
          color: Colors.red,
        ),
        const Achievement(
          id: 'streak_7',
          name: 'Week Warrior',
          description: 'Maintain a 7-day streak',
          icon: Icons.whatshot,
          color: Colors.deepOrange,
        ),
        const Achievement(
          id: 'math_starter',
          name: 'Math Whiz',
          description: 'Complete 3 math lessons',
          icon: Icons.calculate,
          color: Colors.blue,
        ),
        const Achievement(
          id: 'eng_starter',
          name: 'Word Wizard',
          description: 'Complete 3 English lessons',
          icon: Icons.menu_book,
          color: Colors.teal,
        ),
        const Achievement(
          id: 'scholar',
          name: 'Scholar',
          description: 'Complete 15 lessons',
          icon: Icons.workspace_premium,
          color: Colors.indigo,
        ),
      ];
}
