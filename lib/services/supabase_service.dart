import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      publishableKey: AppConstants.supabaseAnonKey,
      realtimeClientOptions: const RealtimeClientOptions(
        eventsPerSecond: 10,
      ),
    );
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final data = await client.from('users').select('id,name,email,role,password').eq('email', email).maybeSingle();
    return data;
  }

  Future<List<Map<String, dynamic>>> getChildrenByParentId(String parentId) async {
    final data = await client.from('students').select('id,name,className,parentId').eq('parentId', parentId);
    return data;
  }

  static const int _examDefaultStart = 0;
  static const int _examDefaultEnd = 399;
  static const int _msgDefaultStart = 0;
  static const int _msgDefaultEnd = 29;
  static const int _annDefaultStart = 0;
  static const int _annDefaultEnd = 29;

  Future<List<Map<String, dynamic>>> getExamResults(
    String studentId, {
    int rangeStart = _examDefaultStart,
    int rangeEnd = _examDefaultEnd,
  }) async {
    final data = await client
        .from('exams')
        .select('id,studentId,subject,score,total,examType,month,status,parentId,date,teacherId')
        .eq('studentId', studentId)
        .order('date', ascending: false)
        .range(rangeStart, rangeEnd);
    return data;
  }

  /// Returns the distinct months for [studentId].
  ///
  /// Kept for backwards compatibility / debugging. Prefer deriving
  /// months client-side from the results of [getExamResults] (one less round-trip).
  @Deprecated('Derive months client-side from getExamResults() results.')
  Future<List<String>> getAvailableMonths(String studentId) async {
    final data = await client.from('exams').select('month').eq('studentId', studentId).order('month', ascending: true);
    final months = (data as List<dynamic>)
        .map((e) => (e as Map<String, dynamic>)['month'] as String? ?? '')
        .where((m) => m.isNotEmpty)
        .toSet()
        .toList();
    return months;
  }

  Future<Map<String, String>> getTeacherComments(String studentId) async {
    final data = await client.from('report_comments').select('subject,teacherComment').eq('studentId', studentId);
    final comments = <String, String>{};
    for (final row in (data as List<dynamic>)) {
      final map = row as Map<String, dynamic>;
      final subject = map['subject'] as String?;
      final comment = map['teacherComment'] as String?;
      if (subject != null && comment != null) {
        comments[subject] = comment;
      }
    }
    return comments;
  }

  Future<List<Map<String, dynamic>>> getAnnouncements(
    List<String> classNames, {
    int rangeStart = _annDefaultStart,
    int rangeEnd = _annDefaultEnd,
  }) async {
    final data = await client
        .from('announcements')
        .select('id,className,message,createdBy,createdAt')
        .inFilter('className', classNames)
        .order('createdAt', ascending: false)
        .range(rangeStart, rangeEnd);
    return data;
  }

  Future<List<Map<String, dynamic>>> getMessages(
    String userId, {
    bool inbox = true,
    int rangeStart = _msgDefaultStart,
    int rangeEnd = _msgDefaultEnd,
  }) async {
    final column = inbox ? 'recipientId' : 'senderId';
    final data = await client
        .from('messages')
        .select('id,senderId,recipientId,subject,body,readAt,createdAt,sender:users!senderId(name),recipient:users!recipientId(name)')
        .eq(column, userId)
        .order('createdAt', ascending: false)
        .range(rangeStart, rangeEnd);
    return data;
  }

  Future<void> markMessageRead(String messageId) async {
    await client.from('messages').update({'readAt': DateTime.now().toIso8601String()}).eq('id', messageId);
  }

  Future<void> sendMessage(Map<String, dynamic> data) async {
    await client.from('messages').insert(data);
  }

  Future<List<Map<String, dynamic>>> getAttendanceByStudentIds(List<String> studentIds, {int limit = 60}) async {
    final data = await client
        .from('attendance')
        .select('id,studentId,className,date,status,teacherId')
        .inFilter('studentId', studentIds)
        .order('date', ascending: false)
        .limit(limit);
    return data;
  }

  Future<Map<String, int>> getAttendanceSummary(String studentId) async {
    final data = await client
        .from('attendance')
        .select('status')
        .eq('studentId', studentId);
    int present = 0, absent = 0, late = 0;
    for (final row in (data as List<dynamic>)) {
      final s = (row as Map<String, dynamic>)['status'] as String? ?? '';
      if (s == 'present') { present++; }
      else if (s == 'absent') { absent++; }
      else if (s == 'late') { late++; }
    }
    return {'present': present, 'absent': absent, 'late': late};
  }

  Future<List<Map<String, dynamic>>> getHomeworkByStudentIds(List<String> studentIds, {int limit = 50}) async {
    final data = await client
        .from('homework')
        .select('id,studentId,className,subject,title,description,dueDate,status,teacherId,student:students!studentId(name)')
        .inFilter('studentId', studentIds)
        .order('dueDate', ascending: false)
        .limit(limit);
    return data;
  }

  Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    final data = await client.from('users').select('id,name').eq('role', role);
    return data;
  }

  Future<Map<String, dynamic>?> getMessageById(String messageId) async {
    final data = await client
        .from('messages')
        .select('id,senderId,recipientId,subject,body,readAt,createdAt,sender:users!senderId(name),recipient:users!recipientId(name)')
        .eq('id', messageId)
        .maybeSingle();
    return data;
  }

  Future<String?> getSenderName(String senderId) async {
    final data = await client.from('users').select('name').eq('id', senderId).maybeSingle();
    return data?['name'] as String?;
  }

  /// Bulk-resolves sender names for a list of user ids.
  ///
  /// Used to seed [MessageProvider]'s sender-name cache without
  /// incurring one round-trip per id (N+1 avoidance on the realtime path).
  Future<Map<String, String>> getSenderNamesByIds(List<String> ids) async {
    if (ids.isEmpty) return {};
    final data = await client
        .from('users')
        .select('id,name')
        .inFilter('id', ids);
    final map = <String, String>{};
    for (final row in (data as List<dynamic>)) {
      final entry = row as Map<String, dynamic>;
      final id = entry['id'] as String?;
      final name = entry['name'] as String?;
      if (id != null && name != null) map[id] = name;
    }
    return map;
  }
}
