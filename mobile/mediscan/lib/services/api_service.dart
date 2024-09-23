import 'dart:convert';
import 'dart:async'; // For Timeout
import 'package:http/http.dart' as http;
import '../models/patient.dart';
import 'auth_service.dart';

class ApiService {
  static const baseUrl = 'http://192.168.166.155:5000/api';
  final AuthService _authService;

  // Inject AuthService into ApiService
  ApiService(this._authService);

  // Register a patient with error handling and timeout
  Future<bool> registerPatient(Patient patient) async {
    try {
      final token = _authService.getToken();
      final url = Uri.parse('$baseUrl/patients');

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
        return true;
      } else {
        throw Exception(
            'Failed to register patient. Status Code: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Error registering patient: $e');
    }
  }

  // Fetch all patients with error handling and timeout
  Future<List<Patient>> fetchPatients() async {
    try {
      final token = _authService.getToken();
      final url = Uri.parse('$baseUrl/patients');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((patient) => Patient.fromJson(patient)).toList();
      } else {
        throw Exception(
            'Failed to load patients. Status Code: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Error fetching patients: $e');
    }
  }
}
