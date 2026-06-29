class Announcement {
  final String id;
  final String className;
  final String message;
  final String createdBy;
  final DateTime createdAt;

  Announcement({
    required this.id,
    required this.className,
    required this.message,
    required this.createdBy,
    required this.createdAt,
  });

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'] as String? ?? '',
      className: map['className'] as String? ?? '',
      message: map['message'] as String? ?? '',
      createdBy: map['createdBy'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
