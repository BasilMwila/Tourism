// lib/services/api_service.dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // UPDATED: Use 10.0.2.2 for Android emulator to reach localhost on host machine
  static const String baseUrl = 'http://192.168.1.184:8080/api';

  // Alternative URLs for different environments:
  // For iOS simulator: 'http://127.0.0.1:8080/api'
  // For physical device: 'http://YOUR_COMPUTER_IP:8080/api' (e.g., 'http://192.168.1.100:8080/api')
  // For web/desktop: 'http://localhost:8080/api'

  // Headers for API requests
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Authentication headers
  static Map<String, String> authHeaders(String token) => {
        ...headers,
        'Authorization': 'Bearer $token',
      };

  // GET request helper
  static Future<http.Response> get(String endpoint, {String? token}) async {
    try {
      print('🌐 Making GET request to: $baseUrl$endpoint');

      final response = await http
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: token != null ? authHeaders(token) : headers,
          )
          .timeout(const Duration(seconds: 10));

      print('📡 Response status: ${response.statusCode}');
      print(
          '📄 Response body preview: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');

      return response;
    } catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: $e');
    }
  }

  // POST request helper
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      print('🌐 Making POST request to: $baseUrl$endpoint');
      print('📤 Request data: $data');

      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: token != null ? authHeaders(token) : headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      print('📡 Response status: ${response.statusCode}');
      print(
          '📄 Response body preview: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');

      return response;
    } catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: $e');
    }
  }

  // PUT request helper
  static Future<http.Response> put(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      print('🌐 Making PUT request to: $baseUrl$endpoint');

      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: token != null ? authHeaders(token) : headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      print('📡 Response status: ${response.statusCode}');

      return response;
    } catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: $e');
    }
  }

  // DELETE request helper
  static Future<http.Response> delete(String endpoint, {String? token}) async {
    try {
      print('🌐 Making DELETE request to: $baseUrl$endpoint');

      final response = await http
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: token != null ? authHeaders(token) : headers,
          )
          .timeout(const Duration(seconds: 10));

      print('📡 Response status: ${response.statusCode}');

      return response;
    } catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: $e');
    }
  }

  // Error handling
  static void handleError(http.Response response) {
    if (response.statusCode >= 400) {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'An error occurred');
      } catch (e) {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    }
  }
}
