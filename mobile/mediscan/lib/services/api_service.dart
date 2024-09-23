import 'dart:convert';
import 'dart:async'; // For Timeout
import 'package:http/http.dart' as http;
import '../models/patient.dart';
import 'auth_service.dart';

class ApiService {
  static const baseUrl = 'http://192.168.130.155:5000/api';
  final AuthService _authService;

  // Inject AuthService into ApiService
  ApiService(this._authService);

  // Register a patient with error handling, timeout, and logging
  Future<bool> registerPatient(Patient patient) async {
    try {
      final token = await _authService.getToken(); // Await the token
      final url = Uri.parse('$baseUrl/patients');
      print('Registering patient: ${patient.name}');
      print('sending to : $url');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'name': patient.name,
              'age': patient.age,
              'diagnosis': patient.diagnosis,
              'imageUrl': patient.imageUrl,
            }),
          )
          .timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

      if (response.statusCode == 201) {
        print('Successfully registered patient: ${patient.name}');
        return true;
      } else {
        print(
            'Failed to register patient. Status Code: ${response.statusCode}');
        throw Exception(
            'Failed to register patient. Status Code: ${response.statusCode}');
      }
    } on TimeoutException {
      print(
          'Error: Request timed out while registering patient: ${patient.name}');
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      print('Error registering patient: $e');
      throw Exception('Error registering patient: $e');
    }
  }

  // Fetch all patients with error handling, timeout, and logging
  Future<List<Patient>> fetchPatients() async {
    try {
      final token = await _authService.getToken(); // Await the token
      final url = Uri.parse('$baseUrl/patients');
      print('Fetching patients from API...');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Successfully fetched ${data.length} patients.');
        return data.map((patient) => Patient.fromJson(patient)).toList();
      } else {
        print('Failed to fetch patients. Status Code: ${response.statusCode}');
        throw Exception(
            'Failed to load patients. Status Code: ${response.statusCode}');
      }
    } on TimeoutException {
      print('Error: Request timed out while fetching patients.');
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      print('Error fetching patients: $e');
      throw Exception('Error fetching patients: $e');
    }
  }
}
