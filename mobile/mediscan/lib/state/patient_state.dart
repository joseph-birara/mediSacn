import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/api_service.dart';

class PatientState extends ChangeNotifier {
  final List<Patient> _patients = [];
  final ApiService _apiService = ApiService();

  List<Patient> get patients => _patients;

  Future<void> fetchPatients(String token) async {
    final fetchedPatients = await _apiService.fetchPatients(token);
    _patients.clear();
    _patients.addAll(fetchedPatients);
    notifyListeners();
  }

  Future<void> addPatient(Patient patient, String token) async {
    final isSuccess = await _apiService.registerPatient(patient, token);
    if (isSuccess) {
      _patients.add(patient);
      notifyListeners();
    }
  }

  // Manually finding the patient to avoid the type conflict with firstWhere
  Patient? getPatientById(String id) {
    for (var patient in _patients) {
      if (patient.id == id) {
        return patient;
      }
    }
    return null; // Return null if no patient is found
  }

  void removePatient(String id) {
    _patients.removeWhere((patient) => patient.id == id);
    notifyListeners();
  }

  Future<String?> loginDoctor(String username, String password) async {
    return await _apiService.loginDoctor(username, password);
  }
}
