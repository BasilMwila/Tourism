// lib/services/api_service.dart - FIXED VERSION
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // UPDATED: Multiple URL options based on your environment
  static const String _localIP = 'http://192.168.43.165:8080/api';
  static const String _emulatorURL = 'http://10.0.2.2:8080/api';
  static const String _localhostURL = 'http://127.0.0.1:8080/api';

  // Try multiple URLs in order of preference
  static const List<String> _possibleBaseUrls = [
    _localIP, // Your current IP
    _emulatorURL, // Android emulator
    _localhostURL, // Localhost fallback
  ];

  static String? _workingBaseUrl;

  // Get the working base URL or find one that works
  static Future<String> get baseUrl async {
    if (_workingBaseUrl != null) {
      return _workingBaseUrl!;
    }

    // Test each URL to find one that works
    for (final url in _possibleBaseUrls) {
      try {
        print('🔍 Testing connection to: $url');
        final response = await http
            .get(Uri.parse('${url.replaceAll('/api', '')}/health'))
            .timeout(const Duration(seconds: 3));

        if (response.statusCode == 200) {
          print('✅ Successfully connected to: $url');
          _workingBaseUrl = url;
          return url;
        }
      } catch (e) {
        print('❌ Failed to connect to: $url - $e');
        continue;
      }
    }

    // If no URL works, use the first one and let it fail gracefully
    print('⚠️  No working URLs found, using fallback');
    _workingBaseUrl = _possibleBaseUrls.first;
    return _workingBaseUrl!;
  }

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

  // GET request helper with improved error handling
  static Future<http.Response> get(String endpoint, {String? token}) async {
    try {
      final url = await baseUrl;
      final fullUrl = '$url$endpoint';
      print('🌐 Making GET request to: $fullUrl');

      final response = await http
          .get(
            Uri.parse(fullUrl),
            headers: token != null ? authHeaders(token) : headers,
          )
          .timeout(const Duration(seconds: 15)); // Increased timeout

      print('📡 Response status: ${response.statusCode}');
      if (response.body.isNotEmpty) {
        print(
            '📄 Response body preview: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
      }

      return response;
    } catch (e) {
      print('❌ GET Network error: $e');
      // Reset working URL on network error to retry next time
      _workingBaseUrl = null;
      throw Exception('Network error: $e');
    }
  }

  // POST request helper with improved error handling
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      final url = await baseUrl;
      final fullUrl = '$url$endpoint';
      print('🌐 Making POST request to: $fullUrl');
      print('📤 Request data: $data');

      final response = await http
          .post(
            Uri.parse(fullUrl),
            headers: token != null ? authHeaders(token) : headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 15)); // Increased timeout

      print('📡 Response status: ${response.statusCode}');
      if (response.body.isNotEmpty) {
        print(
            '📄 Response body preview: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
      }

      return response;
    } catch (e) {
      print('❌ POST Network error: $e');
      // Reset working URL on network error to retry next time
      _workingBaseUrl = null;
      throw Exception('Network error: $e');
    }
  }

  // PUT request helper
  static Future<http.Response> put(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      final url = await baseUrl;
      final fullUrl = '$url$endpoint';
      print('🌐 Making PUT request to: $fullUrl');

      final response = await http
          .put(
            Uri.parse(fullUrl),
            headers: token != null ? authHeaders(token) : headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 15));

      print('📡 Response status: ${response.statusCode}');

      return response;
    } catch (e) {
      print('❌ PUT Network error: $e');
      _workingBaseUrl = null;
      throw Exception('Network error: $e');
    }
  }

  // DELETE request helper
  static Future<http.Response> delete(String endpoint, {String? token}) async {
    try {
      final url = await baseUrl;
      final fullUrl = '$url$endpoint';
      print('🌐 Making DELETE request to: $fullUrl');

      final response = await http
          .delete(
            Uri.parse(fullUrl),
            headers: token != null ? authHeaders(token) : headers,
          )
          .timeout(const Duration(seconds: 15));

      print('📡 Response status: ${response.statusCode}');

      return response;
    } catch (e) {
      print('❌ DELETE Network error: $e');
      _workingBaseUrl = null;
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

  // Test connectivity to server
  static Future<bool> testConnection() async {
    try {
      final url = await baseUrl;
      final healthUrl = url.replaceAll('/api', '/health');
      final response = await http
          .get(Uri.parse(healthUrl))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }

  // Get current server info
  static Future<Map<String, dynamic>> getServerInfo() async {
    try {
      final url = await baseUrl;
      return {
        'baseUrl': url,
        'isConnected': await testConnection(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'baseUrl': 'Unknown',
        'isConnected': false,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  static searchAttractions(String query) {}

  static getAttractions() {}
}
