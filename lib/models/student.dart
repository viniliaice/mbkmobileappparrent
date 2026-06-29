class Student {
  final String id;
  final String name;
  final String className;
  final String parentId;

  Student({
    required this.id,
    required this.name,
    required this.className,
    required this.parentId,
  });

  factory Student.fromMap(Map<String, dynamic> map, String id) {
    return Student(
      id: id,
      name: map['name'] as String? ?? '',
      className: map['className'] as String? ?? '',
      parentId: map['parentId'] as String? ?? '',
    );
  }
}
