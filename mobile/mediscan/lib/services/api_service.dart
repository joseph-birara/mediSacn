import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient.dart'; // Assuming Patient model is in models folder
import 'auth_service.dart'; // Import AuthService

class ApiService {
  static const baseUrl = 'https://your-backend-url.com/api';
  final AuthService _authService;

  // Inject AuthService into ApiService
  ApiService(this._authService);

  // Register a patient
  Future<bool> registerPatient(Patient patient) async {
    final token = _authService.getToken();

    final url = Uri.parse('$baseUrl/patients');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': patient.name,
        'age': patient.age,
        'diagnosis': patient.diagnosis,
        'imageUrl': patient.imageUrl, // Assuming imageUrl is already uploaded
      }),
    );
    return response.statusCode == 201;
  }

  // Fetch all patients
  Future<List<Patient>> fetchPatients() async {
    final token = _authService.getToken();

    final url = Uri.parse('$baseUrl/patients');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((patient) => Patient.fromJson(patient)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }
}
