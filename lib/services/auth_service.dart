// lib/services/auth_service.dart - FIXED RESPONSE PARSING
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  static const String endpoint = '/auth';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Register user - FIXED PARSING
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await ApiService.post('$endpoint/register', {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      });

      print('🔍 Raw response body: ${response.body}');
      ApiService.handleError(response);

      final responseData = jsonDecode(response.body);
      print('🔍 Parsed response data: $responseData');

      // Handle the response structure from your backend
      Map<String, dynamic> data;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          // Response format: {"success": true, "data": {"user": {...}, "token": "..."}}
          data = responseData['data'] as Map<String, dynamic>;
        } else {
          // Response format: {"success": true, "user": {...}, "token": "..."}
          data = responseData;
        }
      } else {
        throw Exception('Invalid response format');
      }

      print('🔍 Final data structure: $data');

      // Extract user and token
      final userData = data['user'] as Map<String, dynamic>?;
      final token = data['token'] as String?;

      if (userData == null) {
        throw Exception('User data not found in response');
      }

      if (token == null) {
        throw Exception('Token not found in response');
      }

      // Save token and user data
      await _saveToken(token);

      // Create UserModel from the response
      final user = UserModel.fromJson(userData);
      await _saveUser(user);

      print('✅ Registration successful for user: ${user.email}');

      return {
        'success': true,
        'user': userData,
        'token': token,
      };
    } catch (e) {
      print('❌ Registration error: $e');
      throw Exception('Failed to register: $e');
    }
  }

  // Login user - FIXED PARSING
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('$endpoint/login', {
        'email': email,
        'password': password,
      });

      print('🔍 Raw response body: ${response.body}');
      ApiService.handleError(response);

      final responseData = jsonDecode(response.body);
      print('🔍 Parsed response data: $responseData');

      // Handle the response structure from your backend
      Map<String, dynamic> data;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          // Response format: {"success": true, "data": {"user": {...}, "token": "..."}}
          data = responseData['data'] as Map<String, dynamic>;
        } else {
          // Response format: {"success": true, "user": {...}, "token": "..."}
          data = responseData;
        }
      } else {
        throw Exception('Invalid response format');
      }

      print('🔍 Final data structure: $data');

      // Extract user and token
      final userData = data['user'] as Map<String, dynamic>?;
      final token = data['token'] as String?;

      if (userData == null) {
        throw Exception('User data not found in response');
      }

      if (token == null) {
        throw Exception('Token not found in response');
      }

      // Save token and user data
      await _saveToken(token);

      // Create UserModel from the response
      final user = UserModel.fromJson(userData);
      await _saveUser(user);

      print('✅ Login successful for user: ${user.email}');

      return {
        'success': true,
        'user': userData,
        'token': token,
      };
    } catch (e) {
      print('❌ Login error: $e');
      throw Exception('Failed to login: $e');
    }
  }

  // Logout user
  static Future<void> logout() async {
    try {
      final token = await getToken();
      if (token != null) {
        await ApiService.post('$endpoint/logout', {}, token: token);
      }
    } catch (e) {
      // Continue with local logout even if API call fails
      print('⚠️  Logout API call failed, continuing with local logout: $e');
    } finally {
      await _removeToken();
      await _removeUser();
    }
  }

  // Forgot password
  static Future<void> forgotPassword(String email) async {
    try {
      final response = await ApiService.post('$endpoint/forgot-password', {
        'email': email,
      });
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // Reset password
  static Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('$endpoint/reset-password', {
        'email': email,
        'token': token,
        'password': password,
      });
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  // Change password
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    String? token,
  }) async {
    try {
      final authToken = token ?? await getToken();
      final response = await ApiService.post(
        '$endpoint/change-password',
        {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        token: authToken,
      );
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  // Get current user - FIXED PARSING
  static Future<UserModel?> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final response = await ApiService.get('$endpoint/user', token: token);
      ApiService.handleError(response);

      final responseData = jsonDecode(response.body);

      // Handle the response structure
      Map<String, dynamic> userData;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          userData = responseData['data'] as Map<String, dynamic>;
        } else {
          userData = responseData;
        }
      } else {
        throw Exception('Invalid user response format');
      }

      final user = UserModel.fromJson(userData);
      await _saveUser(user);
      return user;
    } catch (e) {
      print('⚠️  Failed to get current user from API, using cached: $e');
      return await _getSavedUser();
    }
  }

  // Update profile - FIXED PARSING
  static Future<UserModel> updateProfile({
    String? name,
    String? phone,
    DateTime? dateOfBirth,
    String? nationality,
    String? preferences,
    String? token,
  }) async {
    try {
      final authToken = token ?? await getToken();
      final updateData = <String, dynamic>{};

      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (dateOfBirth != null)
        updateData['date_of_birth'] = dateOfBirth.toIso8601String();
      if (nationality != null) updateData['nationality'] = nationality;
      if (preferences != null) updateData['preferences'] = preferences;

      final response = await ApiService.put(
        '$endpoint/profile',
        updateData,
        token: authToken,
      );
      ApiService.handleError(response);

      final responseData = jsonDecode(response.body);

      // Handle the response structure
      Map<String, dynamic> userData;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          userData = responseData['data'] as Map<String, dynamic>;
        } else {
          userData = responseData;
        }
      } else {
        throw Exception('Invalid profile update response format');
      }

      final user = UserModel.fromJson(userData);
      await _saveUser(user);
      return user;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Verify email
  static Future<void> verifyEmail(String token) async {
    try {
      final response = await ApiService.post('$endpoint/verify-email', {
        'token': token,
      });
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to verify email: $e');
    }
  }

  // Resend verification email
  static Future<void> resendVerificationEmail({String? token}) async {
    try {
      final authToken = token ?? await getToken();
      final response = await ApiService.post(
        '$endpoint/resend-verification',
        {},
        token: authToken,
      );
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to resend verification email: $e');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Private methods for token and user management
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    print('🔐 Token saved successfully');
  }

  static Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    print('🔐 Token removed');
  }

  static Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
    print('👤 User data saved: ${user.email}');
  }

  static Future<UserModel?> _getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(userKey);
      if (userJson != null) {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      }
    } catch (e) {
      print('⚠️  Error getting saved user: $e');
    }
    return null;
  }

  static Future<void> _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
    print('👤 User data removed');
  }
}
