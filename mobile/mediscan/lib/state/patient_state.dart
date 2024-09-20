import 'package:flutter/material.dart';
import 'package:mediscan/models/login_response.dart';
import 'package:mediscan/services/auth_service.dart';
import '../models/patient.dart';
import '../services/api_service.dart';

class PatientState extends ChangeNotifier {
  final List<Patient> _patients = [];
  final AuthService _authService = AuthService();
  late final ApiService _apiService;

  PatientState() {
    _apiService = ApiService(_authService); // Initialize ApiService here
  }

  List<Patient> get patients => _patients;

  Future<void> fetchPatients(String token) async {
    final fetchedPatients = await _apiService.fetchPatients();
    _patients.clear();
    _patients.addAll(fetchedPatients);
    notifyListeners();
  }

  Future<void> addPatient(Patient patient) async {
    final isSuccess = await _apiService.registerPatient(patient);
    if (isSuccess) {
      _patients.add(patient);
      notifyListeners();
    }
  }

  Patient? getPatientById(String id) {
    for (var patient in _patients) {
      if (patient.id == id) {
        return patient;
      }
    }
    return null;
  }

  void removePatient(String id) {
    _patients.removeWhere((patient) => patient.id == id);
    notifyListeners();
  }

  Future<LoginResponse?> loginDoctor(String username, String password) async {
    return await _authService.login(username, password);
  }
}
