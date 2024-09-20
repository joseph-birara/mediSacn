import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/login_response.dart';

class AuthState extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  String _doctorId = '';

  String? get token => _token;
  String get doctorId => _doctorId;

  Future<bool> login(String username, String password) async {
    final loginResponse = await _authService.login(username, password);
    if (loginResponse != null) {
      _token = loginResponse.token; // Store the token
      _doctorId = username; // Assuming username is used as doctor ID
      notifyListeners();
      return true; // Login successful
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
    return await _authService.isLoggedIn();
  }
}
