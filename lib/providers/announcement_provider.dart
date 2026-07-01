import 'package:flutter/material.dart';
import '../models/announcement.dart';
import '../services/supabase_service.dart';

class AnnouncementProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();

  List<Announcement> _announcements = [];
  bool _loading = false;
  bool _hasMore = true;
  String? _error;
  List<String>? _lastClassNames;

  List<Announcement> get announcements => _announcements;
  bool get loading => _loading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> loadAnnouncements(List<String> classNames) async {
    _loading = true;
    _error = null;
    _lastClassNames = classNames;
    notifyListeners();

    try {
      final data = await _supabase.getAnnouncements(
        classNames,
        rangeStart: 0,
        rangeEnd: 29,
      );
      _announcements = data.map((e) => Announcement.fromMap(e)).toList();
      _hasMore = data.length == 30;
    } catch (e) {
      _error = 'Failed to load announcements.';
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_loading || !_hasMore || _lastClassNames == null) return;
    _loading = true;
    notifyListeners();

    try {
      final start = _announcements.length;
      final end = start + 29;
      final data = await _supabase.getAnnouncements(
        _lastClassNames!,
        rangeStart: start,
        rangeEnd: end,
      );
      _announcements.addAll(data.map((e) => Announcement.fromMap(e)));
      _hasMore = data.length == 30;
    } catch (e) {
      _error = 'Failed to load more announcements.';
    }

    _loading = false;
    notifyListeners();
  }
}
