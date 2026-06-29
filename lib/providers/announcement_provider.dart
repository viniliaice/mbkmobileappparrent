import 'package:flutter/material.dart';
import '../models/announcement.dart';
import '../services/supabase_service.dart';

class AnnouncementProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();

  List<Announcement> _announcements = [];
  bool _loading = false;
  String? _error;

  List<Announcement> get announcements => _announcements;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadAnnouncements(List<String> classNames) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _supabase.getAnnouncements(classNames);
      _announcements = data.map((e) => Announcement.fromMap(e)).toList();
    } catch (e) {
      _error = 'Failed to load announcements.';
    }

    _loading = false;
    notifyListeners();
  }
}
