import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/exam_result.dart';
import '../models/subject_summary.dart';
import '../services/supabase_service.dart';

class StudentProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  List<Student> _children = [];
  List<ExamResult> _allExams = [];
  List<String> _availableMonths = [];
  Map<String, String> _teacherComments = {};
  bool _loadingChildren = false;
  bool _loadingExams = false;
  String? _error;

  List<Student> get children => _children;
  List<ExamResult> get allExams => _allExams;
  List<String> get availableMonths => _availableMonths;
  Map<String, String> get teacherComments => _teacherComments;
  bool get loadingChildren => _loadingChildren;
  bool get loadingExams => _loadingExams;
  String? get error => _error;

  List<ExamResult> get examsForCurrentStudent => _allExams;

  Future<void> loadChildren(String parentId) async {
    _loadingChildren = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _supabaseService.getChildrenByParentId(parentId);
      _children = data
          .map((e) => Student.fromMap(e, e['id'] as String? ?? ''))
          .toList();
    } catch (e) {
      _error = 'Failed to load children.';
    }

    _loadingChildren = false;
    notifyListeners();
  }

  Future<void> loadStudentData(String studentId) async {
    _loadingExams = true;
    _error = null;
    notifyListeners();

    try {
      final results =
          await _supabaseService.getExamResults(studentId);
      _allExams = results
          .map((e) => ExamResult.fromMap(e, e['id'] as String? ?? ''))
          .toList();
      _availableMonths = await _supabaseService.getAvailableMonths(studentId);
      _teacherComments =
          await _supabaseService.getTeacherComments(studentId);
    } catch (e) {
      _error = 'Failed to load results: $e';
    }

    _loadingExams = false;
    notifyListeners();
  }

  List<SubjectSummary> getMonthlySummary(String month) {
    final monthExams = _allExams
        .where((e) => e.month == month)
        .toList();
    final summaries = SubjectSummary.fromMonthlyExams(monthExams);
    return summaries;
  }

  List<SubjectSummary> getMidtermSummary() {
    final midtermExams = _allExams
        .where((e) => e.examType == 'Midterm' || e.examType == 'CA')
        .toList();
    if (midtermExams.isEmpty) return [];
    final summaries = SubjectSummary.fromMidtermExams(midtermExams);
    return summaries;
  }

  List<SubjectSummary> getFinalSummary() {
    final finalExams = _allExams
        .where((e) => e.examType == 'Final' || e.examType == 'CA')
        .toList();
    if (finalExams.isEmpty) return [];
    final summaries = SubjectSummary.fromFinalExams(finalExams);
    return summaries;
  }

  void clearAll() {
    _allExams = [];
    _availableMonths = [];
    _teacherComments = {};
    notifyListeners();
  }
}
