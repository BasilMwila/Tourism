// lib/services/auth_service.dart
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  static const String endpoint = '/auth';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Register user
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
      ApiService.handleError(response);

      final data = jsonDecode(response.body);

      // Save token and user data
      if (data['token'] != null) {
        await _saveToken(data['token']);
        await _saveUser(UserModel.fromJson(data['user']));
      }

      return data;
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('$endpoint/login', {
        'email': email,
        'password': password,
      });
      ApiService.handleError(response);

      final data = jsonDecode(response.body);

      // Save token and user data
      if (data['token'] != null) {
        await _saveToken(data['token']);
        await _saveUser(UserModel.fromJson(data['user']));
      }

      return data;
    } catch (e) {
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

  // Get current user
  static Future<UserModel?> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final response = await ApiService.get('$endpoint/user', token: token);
      ApiService.handleError(response);

      final data = jsonDecode(response.body)['data'];
      final user = UserModel.fromJson(data);
      await _saveUser(user);
      return user;
    } catch (e) {
      return await _getSavedUser();
    }
  }

  // Update profile
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

      final data = jsonDecode(response.body)['data'];
      final user = UserModel.fromJson(data);
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
  }

  static Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  static Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> _getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }
}
