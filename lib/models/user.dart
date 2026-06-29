class AppUser {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? photoUrl;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.photoUrl,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      email: map['email'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: map['role'] as String? ?? '',
      photoUrl: map['photo_url'] as String?,
    );
  }

  bool get isParent => role == 'parent';
}
