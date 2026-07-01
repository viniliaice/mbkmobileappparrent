import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message.dart';
import '../services/supabase_service.dart';

class MessageProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();

  List<AppMessage> _inboxMessages = [];
  List<AppMessage> _sentMessages = [];
  bool _loadingInbox = false;
  bool _loadingSent = false;
  bool _sending = false;
  bool _hasMoreInbox = true;
  String? _error;

  Set<String> _inboxIds = {};

  final Map<String, String> _senderNameCache = {};

  final StreamController<AppMessage> _newMessageController =
      StreamController<AppMessage>.broadcast();

  RealtimeChannel? _channel;

  Stream<AppMessage> get newMessages => _newMessageController.stream;

  List<AppMessage> get inbox => _inboxMessages;
  List<AppMessage> get sent => _sentMessages;
  bool get loadingInbox => _loadingInbox;
  bool get loadingSent => _loadingSent;
  bool get sending => _sending;
  bool get hasMoreInbox => _hasMoreInbox;
  String? get error => _error;

  int get unreadCount => _inboxMessages.where((m) => !m.isRead).length;

  Future<void> loadInbox(
    String userId, {
    int rangeStart = 0,
    int rangeEnd = 29,
  }) async {
    _loadingInbox = true;
    notifyListeners();

    try {
      final data = await _supabase.getMessages(
        userId,
        inbox: true,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );
      final fetched = data.map((e) => AppMessage.fromMap(e)).toList();
      if (rangeStart == 0) {
        _inboxMessages = fetched;
        _inboxIds = fetched.map((m) => m.id).toSet();
        _preloadSenderNames(fetched);
      } else {
        for (final m in fetched) {
          if (_inboxIds.add(m.id)) {
            _inboxMessages.add(m);
          }
        }
        _preloadSenderNames(fetched);
      }
      _hasMoreInbox = fetched.length == (rangeEnd - rangeStart + 1);
      _error = null;
    } catch (e) {
      _error = 'Failed to load inbox.';
    }

    _loadingInbox = false;
    notifyListeners();
  }

  Future<void> loadMoreInbox(String userId) async {
    if (_loadingInbox || !_hasMoreInbox) return;
    final nextStart = _inboxMessages.length;
    final nextEnd = nextStart + 29;
    await loadInbox(userId, rangeStart: nextStart, rangeEnd: nextEnd);
  }

  Future<void> loadSent(
    String userId, {
    int rangeStart = 0,
    int rangeEnd = 29,
  }) async {
    _loadingSent = true;
    notifyListeners();

    try {
      final data = await _supabase.getMessages(
        userId,
        inbox: false,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );
      _sentMessages = data.map((e) => AppMessage.fromMap(e)).toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load sent messages.';
    }

    _loadingSent = false;
    notifyListeners();
  }

  Future<void> markRead(String messageId) async {
    final idx = _inboxMessages.indexWhere((m) => m.id == messageId);
    if (idx != -1 && !_inboxMessages[idx].isRead) {
      _inboxMessages[idx] = _inboxMessages[idx].copyWith(isRead: true);
      notifyListeners();
    }

    try {
      await _supabase.markMessageRead(messageId);
    } catch (_) {
      if (idx != -1) {
        _inboxMessages[idx] = _inboxMessages[idx].copyWith(isRead: false);
        notifyListeners();
      }
    }
  }

  Future<bool> sendMessage(
    String senderId,
    String recipientId,
    String subject,
    String body,
  ) async {
    _sending = true;
    _error = null;
    notifyListeners();

    try {
      final safeSuffix = senderId.length >= 6
          ? senderId.substring(0, 6)
          : senderId.padRight(6, '0').substring(0, 6);
      await _supabase.sendMessage({
        'id': 'message-${DateTime.now().microsecondsSinceEpoch}-$safeSuffix',
        'senderId': senderId,
        'recipientId': recipientId,
        'subject': subject,
        'body': body,
        'createdAt': DateTime.now().toIso8601String(),
      });
      _sending = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to send message.';
      _sending = false;
      notifyListeners();
      return false;
    }
  }

  void subscribeToRealtime(String userId) {
    if (_channel != null) return;

    _channel = _supabase.client.channel('messages-$userId');
    _channel!.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'recipientId',
        value: userId,
      ),
      callback: (payload) {
        final newRecord = payload.newRecord;
        if (newRecord.isEmpty) return;
        _onRealtimeMessage(newRecord);
      },
    ).subscribe();
  }

  void unsubscribeFromRealtime() {
    _channel?.unsubscribe();
    _channel = null;
  }

  void _preloadSenderNames(List<AppMessage> messages) {
    final missing = <String>{};
    for (final m in messages) {
      if (m.senderId.isEmpty) continue;
      if (!_senderNameCache.containsKey(m.senderId)) {
        missing.add(m.senderId);
      } else if (_senderNameCache[m.senderId] != m.senderName) {
        _senderNameCache[m.senderId] = m.senderName;
      }
    }
    if (missing.isEmpty) return;
    unawaited(_seedSenderNames(missing.toList()));
  }

  Future<void> _seedSenderNames(List<String> ids) async {
    try {
      final names = await _supabase.getSenderNamesByIds(ids);
      for (final entry in names.entries) {
        _senderNameCache[entry.key] = entry.value;
      }
    } catch (_) {}
  }

  Future<String> _resolveSenderName(String senderId) async {
    if (senderId.isEmpty) return 'Unknown';
    final cached = _senderNameCache[senderId];
    if (cached != null) return cached;
    try {
      final name = await _supabase.getSenderName(senderId);
      _senderNameCache[senderId] = name ?? 'Unknown';
      return _senderNameCache[senderId]!;
    } catch (_) {
      return 'Unknown';
    }
  }

  Future<void> _onRealtimeMessage(Map<String, dynamic> newRecord) async {
    final messageId = newRecord['id'] as String? ?? '';
    if (messageId.isEmpty) return;
    final senderId = newRecord['senderId'] as String? ?? '';
    final senderName = await _resolveSenderName(senderId);

    final newMessage = AppMessage(
      id: messageId,
      senderId: senderId,
      senderName: senderName,
      recipientId: newRecord['recipientId'] as String? ?? '',
      recipientName: 'Me',
      subject: newRecord['subject'] as String? ?? '',
      body: newRecord['body'] as String? ?? '',
      isRead: newRecord['readAt'] != null,
      createdAt: newRecord['createdAt'] != null
          ? DateTime.parse(newRecord['createdAt'] as String)
          : DateTime.now(),
    );

    if (_inboxIds.contains(newMessage.id)) return;
    _inboxIds.add(newMessage.id);
    _inboxMessages.insert(0, newMessage);
    notifyListeners();
    _newMessageController.add(newMessage);
  }

  @override
  void dispose() {
    unsubscribeFromRealtime();
    _newMessageController.close();
    super.dispose();
  }
}
