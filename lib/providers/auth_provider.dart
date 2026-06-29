import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.uninitialized;
  AppUser? _user;
  String? _error;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  String? get error => _error;

  Future<void> tryAutoLogin() async {
    final savedUser = await _authService.tryAutoLogin();
    if (savedUser != null) {
      _user = savedUser;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      _user = user;
      _status = AuthStatus.authenticated;
    } on AuthException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _error = 'Login failed. Check your credentials.';
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
