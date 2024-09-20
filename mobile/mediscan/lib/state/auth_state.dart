import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  String _doctorId = '';

  String get doctorId => _doctorId;

  void login(String id) {
    _doctorId = id;
    notifyListeners();
  }

  void logout() {
    _doctorId = '';
    notifyListeners();
  }
}
