class LessonProgress {
  final String lessonId;
  final bool completed;
  final int xpEarned;
  final int totalAttempts;
  final int correctCount;
  final int totalActivities;
  final DateTime? lastAttemptedAt;
  final DateTime? completedAt;

  const LessonProgress({
    required this.lessonId,
    this.completed = false,
    this.xpEarned = 0,
    this.totalAttempts = 0,
    this.correctCount = 0,
    this.totalActivities = 0,
    this.lastAttemptedAt,
    this.completedAt,
  });

  LessonProgress copyWith({
    bool? completed,
    int? xpEarned,
    int? totalAttempts,
    int? correctCount,
    int? totalActivities,
    DateTime? lastAttemptedAt,
    DateTime? completedAt,
  }) {
    return LessonProgress(
      lessonId: lessonId,
      completed: completed ?? this.completed,
      xpEarned: xpEarned ?? this.xpEarned,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      correctCount: correctCount ?? this.correctCount,
      totalActivities: totalActivities ?? this.totalActivities,
      lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'lessonId': lessonId,
        'completed': completed,
        'xpEarned': xpEarned,
        'totalAttempts': totalAttempts,
        'correctCount': correctCount,
        'totalActivities': totalActivities,
        'lastAttemptedAt': lastAttemptedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory LessonProgress.fromJson(Map<String, dynamic> json) => LessonProgress(
        lessonId: json['lessonId'] as String,
        completed: json['completed'] as bool? ?? false,
        xpEarned: json['xpEarned'] as int? ?? 0,
        totalAttempts: json['totalAttempts'] as int? ?? 0,
        correctCount: json['correctCount'] as int? ?? 0,
        totalActivities: json['totalActivities'] as int? ?? 0,
        lastAttemptedAt: json['lastAttemptedAt'] != null
            ? DateTime.tryParse(json['lastAttemptedAt'] as String)
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.tryParse(json['completedAt'] as String)
            : null,
      );
}
