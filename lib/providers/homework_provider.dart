import 'package:flutter/material.dart';
import '../models/homework_item.dart';
import '../services/supabase_service.dart';

class HomeworkProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();

  List<HomeworkItem> _items = [];
  bool _loading = false;
  String? _error;

  List<HomeworkItem> get items => _items;
  bool get loading => _loading;
  String? get error => _error;

  List<HomeworkItem> get overdueItems => _items.where((h) => h.isOverdue).toList();

  List<HomeworkItem> get pendingItems => _items.where((h) => !h.isCompleted).toList();

  Map<String, List<HomeworkItem>> get groupedByStudent {
    final map = <String, List<HomeworkItem>>{};
    for (final item in _items) {
      map.putIfAbsent(item.studentName, () => []).add(item);
    }
    return map;
  }

  int get overdueCount => overdueItems.length;

  Future<void> loadHomework(List<String> studentIds) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _supabase.getHomeworkByStudentIds(studentIds);
      _items = data.map((e) => HomeworkItem.fromMap(e)).toList();
    } catch (e) {
      _error = 'Failed to load homework.';
    }

    _loading = false;
    notifyListeners();
  }
}
