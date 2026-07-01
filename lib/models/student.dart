class Student {
  final String id;
  final String name;
  final String className;
  final String parentId;
  final int grade;

  Student({
    required this.id,
    required this.name,
    required this.className,
    required this.parentId,
    this.grade = 1,
  });

  factory Student.fromMap(Map<String, dynamic> map, String id) {
    return Student(
      id: id,
      name: map['name'] as String? ?? '',
      className: map['className'] as String? ?? '',
      parentId: map['parentId'] as String? ?? '',
      grade: (map['grade'] as int?) ?? 1,
    );
  }
}
