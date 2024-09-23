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

  /// Fetch patients from API with error handling and logging
  Future<void> fetchPatients() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    print('Fetching patients...');

    try {
      final fetchedPatients = await _apiService
          .fetchPatients()
          .timeout(const Duration(seconds: 10));
      _patients.clear();
      _patients.addAll(fetchedPatients);
      print(
          'Successfully fetched patients: ${_patients.length} patients loaded.');
    } on TimeoutException {
      _error = 'Request timed out. Please check your connection and try again.';
      print('Error: Request to fetch patients timed out.');
    } catch (e) {
      _error = 'Failed to fetch patients: ${e.toString()}';
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new patient with error handling and logging
  Future<void> addPatient(Patient patient) async {
    _error = null;
    print('Adding new patient: ${patient.name}');

    try {
      final isSuccess = await _apiService
          .registerPatient(patient)
          .timeout(const Duration(seconds: 15));
      if (isSuccess) {
        _patients.add(patient);
        print('Successfully added patient: ${patient.name}');
        notifyListeners();
      } else {
        print('Failed to add patient: API returned an error.');
      }
    } on TimeoutException {
      _error = 'Request timed out while adding patient. Please try again.';
      print('Error: Request to add patient timed out.');
    } catch (e) {
      _error = 'Failed to add patient: ${e.toString()}';
      print('Error: $e');
    }
  }

  /// Get patient by ID with logging
  Patient? getPatientById(String id) {
    print('Fetching patient with ID: $id');
    return _patients.firstWhere(
      (patient) => patient.id == id,
      orElse: () {
        print('Patient not found, returning default.');
        return Patient(id: '', name: '', age: 0, diagnosis: '', imageUrl: '');
      },
    );
  }

  /// Remove a patient by ID with logging
  void removePatient(String id) {
    print('Removing patient with ID: $id');
    _patients.removeWhere((patient) => patient.id == id);
    notifyListeners();
  }
}
