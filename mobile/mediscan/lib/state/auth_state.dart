import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthState extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  String _doctorId = '';

  String? get token => _token;
  String get doctorId => _doctorId;

  AuthState() {
    loadToken(); // Load token when the state is initialized
  }

  Future<void> loadToken() async {
    _token = await _authService.getToken();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final token = await _authService.login(email, password);
      if (token != null) {
        _token = token; // Store the token
        _doctorId = email; // Assuming email is used as doctor ID
        notifyListeners();
        return true; // Login successful
      } else {
        print('Login failed: Invalid credentials');
      }
    } catch (e) {
      print('Login error: $e');
    }
    return false; // Login failed
  }

  void logout() {
    _token = null;
    _doctorId = '';
    _authService.logout(); // Clear the token from shared preferences
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    _token =
        await _authService.getToken(); // Get the token from SharedPreferences
    if (_token != null && _token!.isNotEmpty) {
      return true;
    }
    return false;
  }
}
