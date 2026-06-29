import 'package:flutter/material.dart';
import '../models/attendance_record.dart';
import '../services/supabase_service.dart';

class AttendanceProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();

  List<AttendanceRecord> _records = [];
  Map<String, int> _summary = {'present': 0, 'absent': 0, 'late': 0};
  bool _loading = false;
  String? _error;

  List<AttendanceRecord> get records => _records;
  Map<String, int> get summary => _summary;
  bool get loading => _loading;
  String? get error => _error;

  double get monthlyPercentage {
    final total = _summary.values.fold(0, (a, b) => a + b);
    if (total == 0) return 0;
    return (_summary['present']! / total) * 100;
  }

  AttendanceRecord? get todayRecord {
    final today = DateTime.now();
    return _records.cast<AttendanceRecord?>().firstWhere(
      (r) =>
          r!.date.year == today.year &&
          r.date.month == today.month &&
          r.date.day == today.day,
      orElse: () => null,
    );
  }

  Future<void> loadAttendance(List<String> studentIds) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _supabase.getAttendanceByStudentIds(studentIds);
      _records = data.map((e) => AttendanceRecord.fromMap(e)).toList();
      if (studentIds.length == 1) {
        _summary = await _supabase.getAttendanceSummary(studentIds.first);
      }
    } catch (e) {
      _error = 'Failed to load attendance.';
    }

    _loading = false;
    notifyListeners();
  }
}
