import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'supabase_service.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final SupabaseService _supabaseService = SupabaseService();

  static const String _userKey = 'logged_in_user';

  Future<void> _saveUser(AppUser user) async {
    final data = jsonEncode({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'role': user.role,
    });
    await _secureStorage.write(key: _userKey, value: data);
  }

  Future<AppUser?> getSavedUser() async {
    final json = await _secureStorage.read(key: _userKey);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return AppUser.fromMap(map, map['id'] as String);
    } catch (_) {
      await _clearUser();
      return null;
    }
  }

  Future<void> _clearUser() async {
    await _secureStorage.delete(key: _userKey);
  }

  Future<AppUser> login(String email, String password) async {
    final profile = await _supabaseService.getUserByEmail(email);

    if (profile == null) {
      throw AuthException('User not found with this email.');
    }

    final storedPassword = profile['password'] as String? ?? '';
    if (storedPassword != password) {
      throw AuthException('Invalid password.');
    }

    final role = profile['role'] as String? ?? '';
    if (role != 'parent') {
      throw AuthException('Access denied. Only parents can use this app.');
    }

    final user = AppUser.fromMap(profile, profile['id'] as String);
    await _saveUser(user);
    return user;
  }

  Future<AppUser?> tryAutoLogin() async {
    return await getSavedUser();
  }

  Future<void> logout() async {
    await _clearUser();
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
