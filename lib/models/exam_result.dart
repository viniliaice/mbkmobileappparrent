class ExamResult {
  final String id;
  final String studentId;
  final String subject;
  final int score;
  final int total;
  final String examType;
  final String month;
  final String status;
  final String? teacherId;
  final String? parentId;
  final DateTime date;

  ExamResult({
    required this.id,
    required this.studentId,
    required this.subject,
    required this.score,
    required this.total,
    required this.examType,
    required this.month,
    required this.status,
    this.teacherId,
    this.parentId,
    required this.date,
  });

  double get percentage => total > 0 ? (score / total) * 100 : 0;

  String get grade {
    final p = percentage;
    if (p >= 90) return 'A+';
    if (p >= 80) return 'A';
    if (p >= 70) return 'B+';
    if (p >= 60) return 'B';
    if (p >= 50) return 'C';
    if (p >= 40) return 'D';
    return 'F';
  }

  factory ExamResult.fromMap(Map<String, dynamic> map, String id) {
    return ExamResult(
      id: id,
      studentId: map['studentId'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      score: (map['score'] as num?)?.toInt() ?? 0,
      total: (map['total'] as num?)?.toInt() ?? 0,
      examType: map['examType'] as String? ?? '',
      month: map['month'] as String? ?? '',
      status: map['status'] as String? ?? '',
      teacherId: map['teacherId'] as String?,
      parentId: map['parentId'] as String?,
      date: map['date'] != null
          ? DateTime.parse(map['date'] as String)
          : DateTime.now(),
    );
  }
}
