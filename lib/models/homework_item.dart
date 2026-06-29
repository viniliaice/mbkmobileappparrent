class HomeworkItem {
  final String id;
  final String studentId;
  final String studentName;
  final String className;
  final String subject;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String status;
  final String? teacherId;

  HomeworkItem({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.className,
    required this.subject,
    required this.title,
    this.description,
    required this.dueDate,
    required this.status,
    this.teacherId,
  });

  bool get isOverdue => dueDate.isBefore(DateTime.now()) && status != 'completed';

  bool get isCompleted => status == 'completed';

  factory HomeworkItem.fromMap(Map<String, dynamic> map) {
    final student = map['student'] as Map<String, dynamic>?;
    return HomeworkItem(
      id: map['id'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      studentName: student?['name'] as String? ?? 'Unknown',
      className: map['className'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'] as String)
          : DateTime.now(),
      status: map['status'] as String? ?? 'pending',
      teacherId: map['teacherId'] as String?,
    );
  }
}
