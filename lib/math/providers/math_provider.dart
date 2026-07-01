import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/math_question.dart';
import '../models/math_progress.dart';

class MathProvider extends ChangeNotifier {
  Map<String, StudentMathProgress> _allProgress = {};
  StudentMathProgress? _currentProgress;
  static const _storageKey = 'math_progress';

  StudentMathProgress? get currentProgress => _currentProgress;
  Map<String, StudentMathProgress> get allProgress => _allProgress;

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      final decoded = json.decode(data) as Map<String, dynamic>;
      _allProgress = decoded.map((k, v) =>
          MapEntry(k, StudentMathProgress.fromJson(v as Map<String, dynamic>)));
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(
        _allProgress.map((k, v) => MapEntry(k, v.toJson())));
    await prefs.setString(_storageKey, data);
  }

  void selectStudent(String studentId) {
    _currentProgress = _allProgress.putIfAbsent(
      studentId,
      () => StudentMathProgress(studentId: studentId),
    );
    notifyListeners();
  }

  StudentMathProgress _ensure(String studentId) {
    return _allProgress.putIfAbsent(
      studentId,
      () => StudentMathProgress(studentId: studentId),
    );
  }

  Future<void> recordSpeedChallenge({
    required String studentId,
    required int grade,
    required int durationSeconds,
    required int questionsAnswered,
    required int correctAnswers,
    required int finalScore,
    required int personalBest,
  }) async {
    final prev = _ensure(studentId);
    final accuracy = questionsAnswered > 0
        ? correctAnswers / questionsAnswered
        : 0.0;
    final xpEarned = correctAnswers * 10 + (correctAnswers == questionsAnswered ? 50 : 0);
    final result = SpeedChallengeResult(
      grade: grade,
      durationSeconds: durationSeconds,
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      finalScore: finalScore,
      personalBest: personalBest,
      accuracy: accuracy,
      date: DateTime.now(),
      xpEarned: xpEarned,
    );

    final now = DateTime.now();
    final lastDate = prev.lastPlayedDate;
    final isNewDay = lastDate == null ||
        now.year != lastDate.year ||
        now.month != lastDate.month ||
        now.day != lastDate.day;
    final newStreak = isNewDay ? prev.dailyStreak + 1 : prev.dailyStreak;
    final streakBonus = isNewDay && (now.difference(lastDate ?? now).inDays <= 1)
        ? newStreak * 5
        : isNewDay ? 1 : 0;

    final challenges = List<SpeedChallengeResult>.from(prev.recentSpeedChallenges);
    challenges.add(result);
    if (challenges.length > 50) challenges.removeAt(0);

    _currentProgress = prev.copyWith(
      totalXp: prev.totalXp + xpEarned + streakBonus,
      dailyStreak: newStreak > 7 ? 7 : newStreak,
      lastPlayedDate: now,
      recentSpeedChallenges: challenges,
    );
    _allProgress[studentId] = _currentProgress!;
    await _save();
    notifyListeners();
  }

  Future<void> recordLessonComplete({
    required String studentId,
    required MathTopic topic,
    required int score,
    required int totalQuestions,
    required int timeSpentSeconds,
  }) async {
    final prev = _ensure(studentId);
    final tp = prev.topicProgress[topic.name] ??
        TopicProgress(topicId: topic.name);
    final accuracy = totalQuestions > 0 ? score / totalQuestions : 0.0;
    final stars = accuracy >= 0.9 ? 3 : accuracy >= 0.7 ? 2 : 1;
    final xpEarned = score * 15 + (stars == 3 ? 30 : 0);

    final newTp = tp.copyWith(
      starsEarned: tp.starsEarned + stars,
      bestScore: score > tp.bestScore ? score : tp.bestScore,
      accuracy: accuracy,
      timeSpentSeconds: tp.timeSpentSeconds + timeSpentSeconds,
      totalAttempts: tp.totalAttempts + 1,
      correctAttempts: tp.correctAttempts + score,
      xpEarned: tp.xpEarned + xpEarned,
    );

    final newTopics = Map<String, TopicProgress>.from(prev.topicProgress);
    newTopics[topic.name] = newTp;

    _currentProgress = prev.copyWith(
      topicProgress: newTopics,
      totalXp: prev.totalXp + xpEarned,
      weeklyActiveMinutes: prev.weeklyActiveMinutes + (timeSpentSeconds ~/ 60),
    );
    _allProgress[studentId] = _currentProgress!;
    await _save();
    notifyListeners();
  }

  TopicProgress? topicProgress(String studentId, MathTopic topic) {
    return _ensure(studentId).topicProgress[topic.name];
  }

  int totalStars(String studentId) {
    return _ensure(studentId)
        .topicProgress
        .values
        .fold(0, (sum, t) => sum + t.starsEarned);
  }

  List<MathTopic> strongestTopics(String studentId) {
    final progress = _ensure(studentId).topicProgress;
    final sorted = progress.entries.toList()
      ..sort((a, b) => b.value.accuracy.compareTo(a.value.accuracy));
    return sorted.take(3).map((e) {
      return MathTopic.values.firstWhere((t) => t.name == e.key);
    }).toList();
  }

  List<MathTopic> weakestTopics(String studentId) {
    final progress = _ensure(studentId).topicProgress;
    final withData = progress.entries
        .where((e) => e.value.totalAttempts > 0)
        .toList()
      ..sort((a, b) => a.value.accuracy.compareTo(b.value.accuracy));
    return withData.take(3).map((e) {
      return MathTopic.values.firstWhere((t) => t.name == e.key);
    }).toList();
  }

  double averageAccuracy(String studentId) {
    final topics = _ensure(studentId).topicProgress.values
        .where((t) => t.totalAttempts > 0)
        .toList();
    if (topics.isEmpty) return 0;
    return topics.fold(0.0, (s, t) => s + t.accuracy) / topics.length;
  }

  int totalTimeSpentMinutes(String studentId) {
    return _ensure(studentId).weeklyActiveMinutes;
  }

  List<SpeedChallengeResult> recentResults(String studentId) {
    final results = _ensure(studentId).recentSpeedChallenges;
    return results.sublist(results.length > 10 ? results.length - 10 : 0);
  }

  int totalCompletedTopics(String studentId) {
    return _ensure(studentId)
        .topicProgress
        .values
        .where((t) => t.totalAttempts > 0)
        .length;
  }
}
