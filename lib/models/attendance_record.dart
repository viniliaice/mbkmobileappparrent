class AttendanceRecord {
  final String id;
  final String studentId;
  final String className;
  final DateTime date;
  final String status;
  final String? teacherId;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.className,
    required this.date,
    required this.status,
    this.teacherId,
  });

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      className: map['className'] as String? ?? '',
      date: map['date'] != null
          ? DateTime.parse(map['date'] as String)
          : DateTime.now(),
      status: map['status'] as String? ?? '',
      teacherId: map['teacherId'] as String?,
    );
  }
}
