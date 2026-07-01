import 'math_question.dart';

class TopicProgress {
  final String topicId;
  final int starsEarned;
  final int bestScore;
  final double accuracy;
  final int timeSpentSeconds;
  final bool completed;
  final List<String> completedLessonIds;
  final int xpEarned;
  final int totalAttempts;
  final int correctAttempts;

  const TopicProgress({
    required this.topicId,
    this.starsEarned = 0,
    this.bestScore = 0,
    this.accuracy = 0,
    this.timeSpentSeconds = 0,
    this.completed = false,
    this.completedLessonIds = const [],
    this.xpEarned = 0,
    this.totalAttempts = 0,
    this.correctAttempts = 0,
  });

  TopicProgress copyWith({
    int? starsEarned,
    int? bestScore,
    double? accuracy,
    int? timeSpentSeconds,
    bool? completed,
    List<String>? completedLessonIds,
    int? xpEarned,
    int? totalAttempts,
    int? correctAttempts,
  }) {
    return TopicProgress(
      topicId: topicId,
      starsEarned: starsEarned ?? this.starsEarned,
      bestScore: bestScore ?? this.bestScore,
      accuracy: accuracy ?? this.accuracy,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      completed: completed ?? this.completed,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      xpEarned: xpEarned ?? this.xpEarned,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      correctAttempts: correctAttempts ?? this.correctAttempts,
    );
  }

  Map<String, dynamic> toJson() => {
        'topicId': topicId,
        'starsEarned': starsEarned,
        'bestScore': bestScore,
        'accuracy': accuracy,
        'timeSpentSeconds': timeSpentSeconds,
        'completed': completed,
        'completedLessonIds': completedLessonIds,
        'xpEarned': xpEarned,
        'totalAttempts': totalAttempts,
        'correctAttempts': correctAttempts,
      };

  factory TopicProgress.fromJson(Map<String, dynamic> json) => TopicProgress(
        topicId: json['topicId'] as String,
        starsEarned: json['starsEarned'] as int? ?? 0,
        bestScore: json['bestScore'] as int? ?? 0,
        accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0,
        timeSpentSeconds: json['timeSpentSeconds'] as int? ?? 0,
        completed: json['completed'] as bool? ?? false,
        completedLessonIds:
            (json['completedLessonIds'] as List?)?.cast<String>() ?? [],
        xpEarned: json['xpEarned'] as int? ?? 0,
        totalAttempts: json['totalAttempts'] as int? ?? 0,
        correctAttempts: json['correctAttempts'] as int? ?? 0,
      );
}

class SpeedChallengeResult {
  final int grade;
  final int durationSeconds;
  final int questionsAnswered;
  final int correctAnswers;
  final int finalScore;
  final int personalBest;
  final double accuracy;
  final DateTime date;
  final int xpEarned;

  const SpeedChallengeResult({
    required this.grade,
    required this.durationSeconds,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.finalScore,
    required this.personalBest,
    required this.accuracy,
    required this.date,
    required this.xpEarned,
  });

  Map<String, dynamic> toJson() => {
        'grade': grade,
        'durationSeconds': durationSeconds,
        'questionsAnswered': questionsAnswered,
        'correctAnswers': correctAnswers,
        'finalScore': finalScore,
        'personalBest': personalBest,
        'accuracy': accuracy,
        'date': date.toIso8601String(),
        'xpEarned': xpEarned,
      };

  factory SpeedChallengeResult.fromJson(Map<String, dynamic> json) =>
      SpeedChallengeResult(
        grade: json['grade'] as int,
        durationSeconds: json['durationSeconds'] as int,
        questionsAnswered: json['questionsAnswered'] as int,
        correctAnswers: json['correctAnswers'] as int,
        finalScore: json['finalScore'] as int,
        personalBest: json['personalBest'] as int,
        accuracy: (json['accuracy'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        xpEarned: json['xpEarned'] as int,
      );
}

class StudentMathProgress {
  final String studentId;
  final Map<String, TopicProgress> topicProgress;
  final int totalXp;
  final int dailyStreak;
  final DateTime? lastPlayedDate;
  final List<SpeedChallengeResult> recentSpeedChallenges;
  final int weeklyActiveMinutes;

  const StudentMathProgress({
    required this.studentId,
    this.topicProgress = const {},
    this.totalXp = 0,
    this.dailyStreak = 0,
    this.lastPlayedDate,
    this.recentSpeedChallenges = const [],
    this.weeklyActiveMinutes = 0,
  });

  StudentMathProgress copyWith({
    String? studentId,
    Map<String, TopicProgress>? topicProgress,
    int? totalXp,
    int? dailyStreak,
    DateTime? lastPlayedDate,
    List<SpeedChallengeResult>? recentSpeedChallenges,
    int? weeklyActiveMinutes,
  }) {
    return StudentMathProgress(
      studentId: studentId ?? this.studentId,
      topicProgress: topicProgress ?? this.topicProgress,
      totalXp: totalXp ?? this.totalXp,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      recentSpeedChallenges:
          recentSpeedChallenges ?? this.recentSpeedChallenges,
      weeklyActiveMinutes: weeklyActiveMinutes ?? this.weeklyActiveMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'topicProgress': topicProgress
            .map((k, v) => MapEntry(k, v.toJson())),
        'totalXp': totalXp,
        'dailyStreak': dailyStreak,
        'lastPlayedDate': lastPlayedDate?.toIso8601String(),
        'recentSpeedChallenges':
            recentSpeedChallenges.map((r) => r.toJson()).toList(),
        'weeklyActiveMinutes': weeklyActiveMinutes,
      };

  factory StudentMathProgress.fromJson(Map<String, dynamic> json) =>
      StudentMathProgress(
        studentId: json['studentId'] as String,
        topicProgress: (json['topicProgress'] as Map<String, dynamic>?)
                ?.map((k, v) =>
                    MapEntry(k, TopicProgress.fromJson(v as Map<String, dynamic>))) ??
            {},
        totalXp: json['totalXp'] as int? ?? 0,
        dailyStreak: json['dailyStreak'] as int? ?? 0,
        lastPlayedDate: json['lastPlayedDate'] != null
            ? DateTime.parse(json['lastPlayedDate'] as String)
            : null,
        recentSpeedChallenges:
            (json['recentSpeedChallenges'] as List?)
                    ?.map((r) => SpeedChallengeResult.fromJson(r as Map<String, dynamic>))
                    .toList() ??
                [],
        weeklyActiveMinutes: json['weeklyActiveMinutes'] as int? ?? 0,
      );
}

Map<MathTopic, String> topicTitles = {
  MathTopic.counting: 'Counting',
  MathTopic.numberRecognition: 'Number Recognition',
  MathTopic.addition: 'Addition',
  MathTopic.subtraction: 'Subtraction',
  MathTopic.multiplication: 'Multiplication',
  MathTopic.division: 'Division',
  MathTopic.fractions: 'Fractions',
  MathTopic.decimals: 'Decimals',
  MathTopic.time: 'Time',
  MathTopic.money: 'Money',
  MathTopic.measurement: 'Measurement',
  MathTopic.geometry: 'Geometry',
  MathTopic.patterns: 'Patterns',
  MathTopic.wordProblems: 'Word Problems',
  MathTopic.placeValue: 'Place Value',
};

Map<MathTopic, String> topicDescriptions = {
  MathTopic.counting: 'Learn to count objects and understand numbers',
  MathTopic.numberRecognition: 'Identify and name numbers',
  MathTopic.addition: 'Add numbers together',
  MathTopic.subtraction: 'Subtract numbers',
  MathTopic.multiplication: 'Multiply numbers',
  MathTopic.division: 'Divide numbers',
  MathTopic.fractions: 'Understand and work with fractions',
  MathTopic.decimals: 'Work with decimal numbers',
  MathTopic.time: 'Tell time and solve time problems',
  MathTopic.money: 'Count money and make change',
  MathTopic.measurement: 'Measure length, weight, and capacity',
  MathTopic.geometry: 'Explore shapes, area, and perimeter',
  MathTopic.patterns: 'Recognize and create patterns',
  MathTopic.wordProblems: 'Solve real-world math problems',
  MathTopic.placeValue: 'Understand ones, tens, hundreds, and more',
};

String difficultyLabel(Difficulty d) {
  switch (d) {
    case Difficulty.easy: return 'Easy';
    case Difficulty.medium: return 'Medium';
    case Difficulty.hard: return 'Hard';
  }
}
