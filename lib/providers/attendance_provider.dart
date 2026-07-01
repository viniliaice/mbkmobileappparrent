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
      final dataFuture = _supabase.getAttendanceByStudentIds(studentIds);
      if (studentIds.length == 1) {
        final summaryFuture = _supabase.getAttendanceSummary(studentIds.first);
        final both = await Future.wait([dataFuture, summaryFuture]);
        _records = (both[0] as List<Map<String, dynamic>>)
            .map((e) => AttendanceRecord.fromMap(e))
            .toList();
        _summary = both[1] as Map<String, int>;
      } else {
        final data = await dataFuture;
        _records = data.map((e) => AttendanceRecord.fromMap(e)).toList();
      }
    } catch (e) {
      _error = 'Failed to load attendance.';
    }

    _loading = false;
    notifyListeners();
  }
}
