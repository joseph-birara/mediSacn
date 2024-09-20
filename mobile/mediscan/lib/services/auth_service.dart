import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_response.dart';

class AuthService {
  // Backend API endpoint for login
  final String apiUrl =
      'https://your-backend-url.com/api'; // Replace with your actual API URL

  // Log in the doctor and get a token
  Future<LoginResponse?> login(String username, String password) async {
    final url = Uri.parse('$apiUrl/auth/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(json);

      // Store the token using shared preferences for secure local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginResponse.token);

      return loginResponse;
    } else {
      // Handle errors (e.g., invalid credentials)
      return null;
    }
  }

  // Check if the user is already logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  // Log out the doctor and remove the token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Retrieve the token from shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Helper method to add the token to API requests
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
