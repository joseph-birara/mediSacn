import 'package:flutter/material.dart';

class DoctorProfile {
  final String name;
  final String specialization;

  DoctorProfile({required this.name, required this.specialization});
}

class ProfileState extends ChangeNotifier {
  DoctorProfile? _profile;

  DoctorProfile? get profile => _profile;

  void setProfile(DoctorProfile profile) {
    _profile = profile;
    notifyListeners();
  }

  void updateProfile(String name, String specialization) {
    if (_profile != null) {
      _profile = DoctorProfile(name: name, specialization: specialization);
      notifyListeners();
    }
  }
}
