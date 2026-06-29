class AppMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String recipientId;
  final String recipientName;
  final String subject;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  AppMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    required this.recipientName,
    required this.subject,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory AppMessage.fromMap(Map<String, dynamic> map) {
    final sender = map['sender'] as Map<String, dynamic>?;
    final recipient = map['recipient'] as Map<String, dynamic>?;
    return AppMessage(
      id: map['id'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      senderName: sender?['name'] as String? ?? 'Unknown',
      recipientId: map['recipientId'] as String? ?? '',
      recipientName: recipient?['name'] as String? ?? 'Unknown',
      subject: map['subject'] as String? ?? '',
      body: map['body'] as String? ?? '',
      isRead: map['readAt'] != null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
