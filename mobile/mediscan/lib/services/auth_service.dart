import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer'; // For logging

class AuthService {
  final apiUrl = 'http://192.168.166.155:5000/api';
  // Replace with your actual API URL

  Future<String?> login(String email, String password) async {
    final url = Uri.parse('$apiUrl/doctors/login');
    print('Attempting login with URL: $url');
    print('email: $email, Password: $password');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('Parsed JSON: $json');

        final String? token = json['token'];

        // Store the token using shared preferences for secure local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token!);

        print('Token stored successfully');
        return token;
      } else {
        // Handle errors (e.g., invalid credentials)
        print('Login failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.containsKey('token');
    log('Checking if logged in: $isLoggedIn');
    return isLoggedIn;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    log('Logged out and token removed from local storage.');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    log('Retrieved token: $token');
    return token;
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    log('Setting headers with token.');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
