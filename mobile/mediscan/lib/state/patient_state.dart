import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mediscan/services/auth_service.dart';
import '../models/patient.dart';
import '../services/api_service.dart';

class PatientState extends ChangeNotifier {
  final List<Patient> _patients = [];
  final AuthService _authService = AuthService();
  late final ApiService _apiService;
  bool _isLoading = false;
  String? _error;

  PatientState() {
    _apiService = ApiService(_authService);
  }

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPatients(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedPatients = await _apiService
          .fetchPatients()
          .timeout(const Duration(seconds: 10));
      _patients.clear();
      _patients.addAll(fetchedPatients);
    } catch (e) {
      _error = e is TimeoutException
          ? 'Request timed out'
          : e.toString(); // Capture error message
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPatient(Patient patient) async {
    _error = null;
    try {
      final isSuccess = await _apiService
          .registerPatient(patient)
          .timeout(const Duration(seconds: 10));
      if (isSuccess) {
        _patients.add(patient);
        notifyListeners();
      }
    } catch (e) {
      _error = e is TimeoutException ? 'Request timed out' : e.toString();
      notifyListeners();
    }
  }

  Patient? getPatientById(String id) {
    return _patients.firstWhere(
      (patient) => patient.id == id,
      orElse: () => Patient(
          id: '',
          name: '',
          age: 0,
          diagnosis: '',
          imageUrl: ''), // Return a default Patient
    );
  }

  void removePatient(String id) {
    _patients.removeWhere((patient) => patient.id == id);
    notifyListeners();
  }
}
