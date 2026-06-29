import 'exam_result.dart';

class SubjectSummary {
  final String subject;
  final double caScore;
  final double caTotal;
  final double examScore;
  final double examTotal;
  final String? teacherComment;
  final int? position;

  SubjectSummary({
    required this.subject,
    this.caScore = 0,
    this.caTotal = 0,
    this.examScore = 0,
    this.examTotal = 0,
    this.teacherComment,
    this.position,
  });

  double get caPercent => caTotal > 0 ? (caScore / caTotal) * 100 : 0;
  double get examPercent => examTotal > 0 ? (examScore / examTotal) * 100 : 0;
  double get combinedPercent => (caPercent * 0.5) + (examPercent * 0.5);
  double get weightedTotal => combinedPercent;
  double get overallAverage => combinedPercent;

  String get grade {
    final p = combinedPercent;
    if (p >= 90) return 'A+';
    if (p >= 80) return 'A';
    if (p >= 70) return 'B+';
    if (p >= 60) return 'B';
    if (p >= 50) return 'C';
    if (p >= 40) return 'D';
    return 'F';
  }

  static List<SubjectSummary> fromMonthlyExams(List<ExamResult> exams) {
    final grouped = <String, List<ExamResult>>{};
    for (final e in exams) {
      grouped.putIfAbsent(e.subject, () => []).add(e);
    }
    return grouped.entries.map((entry) {
      final subject = entry.key;
      final list = entry.value;
      double caScore = 0, caTotal = 0;
      double examScore = 0, examTotal = 0;
      for (final e in list) {
        if (e.examType == 'Homework' ||
            e.examType == 'Classwork' ||
            e.examType == 'CA' ||
            e.examType == 'Attendance') {
          caScore += e.score;
          caTotal += e.total;
        } else {
          examScore += e.score;
          examTotal += e.total;
        }
      }
      return SubjectSummary(
        subject: subject,
        caScore: caScore,
        caTotal: caTotal,
        examScore: examScore,
        examTotal: examTotal,
      );
    }).toList()
      ..sort((a, b) => a.subject.compareTo(b.subject));
  }

  static List<SubjectSummary> fromMidtermExams(List<ExamResult> exams) {
    final grouped = <String, List<ExamResult>>{};
    for (final e in exams) {
      grouped.putIfAbsent(e.subject, () => []).add(e);
    }
    return grouped.entries.map((entry) {
      final subject = entry.key;
      final list = entry.value;
      double caScore = 0, caTotal = 0;
      double examScore = 0, examTotal = 0;
      for (final e in list) {
        if (e.examType == 'CA') {
          caScore += e.score;
          caTotal += e.total;
        } else {
          examScore += e.score;
          examTotal += e.total;
        }
      }
      final caPct = caTotal > 0 ? (caScore / caTotal) * 100 : 0;
      final examPct = examTotal > 0 ? (examScore / examTotal) * 100 : 0;
      return SubjectSummary(
        subject: subject,
        caScore: caPct * 0.5,
        caTotal: 50,
        examScore: examPct * 0.5,
        examTotal: 50,
      );
    }).toList()
      ..sort((a, b) => a.subject.compareTo(b.subject));
  }

  static List<SubjectSummary> fromFinalExams(List<ExamResult> exams) {
    final grouped = <String, List<ExamResult>>{};
    for (final e in exams) {
      grouped.putIfAbsent(e.subject, () => []).add(e);
    }
    return grouped.entries.map((entry) {
      final subject = entry.key;
      final list = entry.value;
      double caScore = 0, caTotal = 0;
      double examScore = 0, examTotal = 0;
      for (final e in list) {
        if (e.examType == 'CA') {
          caScore += e.score;
          caTotal += e.total;
        } else {
          examScore += e.score;
          examTotal += e.total;
        }
      }
      final caPct = caTotal > 0 ? (caScore / caTotal) * 100 : 0;
      final examPct = examTotal > 0 ? (examScore / examTotal) * 100 : 0;
      return SubjectSummary(
        subject: subject,
        caScore: caPct * 0.5,
        caTotal: 50,
        examScore: examPct * 0.5,
        examTotal: 50,
      );
    }).toList()
      ..sort((a, b) => a.subject.compareTo(b.subject));
  }
}
