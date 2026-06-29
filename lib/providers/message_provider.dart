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
  String? _error;

  RealtimeChannel? _channel;

  void Function(AppMessage message)? onNewMessage;

  List<AppMessage> get inbox => _inboxMessages;
  List<AppMessage> get sent => _sentMessages;
  bool get loadingInbox => _loadingInbox;
  bool get loadingSent => _loadingSent;
  bool get sending => _sending;
  String? get error => _error;

  int get unreadCount => _inboxMessages.where((m) => !m.isRead).length;

  Future<void> loadInbox(String userId) async {
    _loadingInbox = true;
    notifyListeners();

    try {
      final data = await _supabase.getMessages(userId, inbox: true);
      _inboxMessages = data.map((e) => AppMessage.fromMap(e)).toList();
    } catch (e) {
      _error = 'Failed to load inbox.';
    }

    _loadingInbox = false;
    notifyListeners();
  }

  Future<void> loadSent(String userId) async {
    _loadingSent = true;
    notifyListeners();

    try {
      final data = await _supabase.getMessages(userId, inbox: false);
      _sentMessages = data.map((e) => AppMessage.fromMap(e)).toList();
    } catch (e) {
      _error = 'Failed to load sent messages.';
    }

    _loadingSent = false;
    notifyListeners();
  }

  Future<void> markRead(String messageId) async {
    try {
      await _supabase.markMessageRead(messageId);
      final idx = _inboxMessages.indexWhere((m) => m.id == messageId);
      if (idx != -1) {
        _inboxMessages[idx] = AppMessage(
          id: _inboxMessages[idx].id,
          senderId: _inboxMessages[idx].senderId,
          senderName: _inboxMessages[idx].senderName,
          recipientId: _inboxMessages[idx].recipientId,
          recipientName: _inboxMessages[idx].recipientName,
          subject: _inboxMessages[idx].subject,
          body: _inboxMessages[idx].body,
          isRead: true,
          createdAt: _inboxMessages[idx].createdAt,
        );
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<bool> sendMessage(String senderId, String recipientId, String subject, String body) async {
    _sending = true;
    _error = null;
    notifyListeners();

    try {
      await _supabase.sendMessage({
        'id': 'message-${DateTime.now().millisecondsSinceEpoch}-${senderId.substring(0, 6)}',
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

    debugPrint('subscribeToRealtime: userId=$userId');

    _channel = _supabase.client.channel('messages-$userId');
    _channel!.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        debugPrint('Realtime INSERT received: ${payload.newRecord}');
        final newRecord = payload.newRecord;
        if (newRecord.isEmpty) return;
        _onRealtimeMessage(newRecord);
      },
    ).subscribe((status, [error]) {
      debugPrint('Realtime subscribe status: $status error: $error');
    });
  }

  void unsubscribeFromRealtime() {
    _channel?.unsubscribe();
    _channel = null;
  }

  Future<void> _onRealtimeMessage(Map<String, dynamic> newRecord) async {
    final senderName = await _supabase.getSenderName(newRecord['senderId'] as String? ?? '');
    final newMessage = AppMessage(
      id: newRecord['id'] as String? ?? '',
      senderId: newRecord['senderId'] as String? ?? '',
      senderName: senderName ?? 'Unknown',
      recipientId: newRecord['recipientId'] as String? ?? '',
      recipientName: 'Me',
      subject: newRecord['subject'] as String? ?? '',
      body: newRecord['body'] as String? ?? '',
      isRead: newRecord['readAt'] != null,
      createdAt: newRecord['createdAt'] != null
          ? DateTime.parse(newRecord['createdAt'] as String)
          : DateTime.now(),
    );

    final exists = _inboxMessages.any((m) => m.id == newMessage.id);
    if (!exists) {
      _inboxMessages.insert(0, newMessage);
      notifyListeners();
      onNewMessage?.call(newMessage);
    }
  }

  @override
  void dispose() {
    unsubscribeFromRealtime();
    super.dispose();
  }
}
