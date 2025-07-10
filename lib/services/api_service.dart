// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://your-backend-url.com/api'; // Replace with your actual backend URL

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
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: token != null ? authHeaders(token) : headers,
    );
    return response;
  }

  // POST request helper
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: token != null ? authHeaders(token) : headers,
      body: jsonEncode(data),
    );
    return response;
  }

  // PUT request helper
  static Future<http.Response> put(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: token != null ? authHeaders(token) : headers,
      body: jsonEncode(data),
    );
    return response;
  }

  // DELETE request helper
  static Future<http.Response> delete(String endpoint, {String? token}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: token != null ? authHeaders(token) : headers,
    );
    return response;
  }

  // Error handling
  static void handleError(http.Response response) {
    if (response.statusCode >= 400) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'An error occurred');
    }
  }
}
