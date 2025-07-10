// lib/services/attraction_service.dart
import 'dart:convert';
import '../models/attraction_model.dart';
import 'api_service.dart';

class AttractionService {
  static const String endpoint = '/attractions';

  // Get all attractions
  static Future<List<AttractionModel>> getAllAttractions() async {
    try {
      final response = await ApiService.get(endpoint);
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AttractionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch attractions: $e');
    }
  }

  // Get attractions by category
  static Future<List<AttractionModel>> getAttractionsByCategory(
      String category) async {
    try {
      final response = await ApiService.get('$endpoint?category=$category');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AttractionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch attractions by category: $e');
    }
  }

  // Get popular attractions
  static Future<List<AttractionModel>> getPopularAttractions() async {
    try {
      final response = await ApiService.get('$endpoint/popular');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AttractionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch popular attractions: $e');
    }
  }

  // Get attraction by ID
  static Future<AttractionModel> getAttractionById(int id) async {
    try {
      final response = await ApiService.get('$endpoint/$id');
      ApiService.handleError(response);

      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return AttractionModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch attraction: $e');
    }
  }

  // Search attractions
  static Future<List<AttractionModel>> searchAttractions(String query) async {
    try {
      final response = await ApiService.get('$endpoint/search?q=$query');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AttractionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search attractions: $e');
    }
  }

  // Get attractions by location
  static Future<List<AttractionModel>> getAttractionsByLocation(
      String location) async {
    try {
      final response = await ApiService.get('$endpoint?location=$location');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AttractionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch attractions by location: $e');
    }
  }

  // Get nearby attractions
  static Future<List<AttractionModel>> getNearbyAttractions(
      double latitude, double longitude,
      {double radius = 50.0}) async {
    try {
      final response = await ApiService.get(
          '$endpoint/nearby?lat=$latitude&lng=$longitude&radius=$radius');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AttractionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch nearby attractions: $e');
    }
  }

  // Rate an attraction
  static Future<void> rateAttraction(int attractionId, double rating,
      {String? token}) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$attractionId/rate',
        {'rating': rating},
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to rate attraction: $e');
    }
  }

  // Add to favorites
  static Future<void> addToFavorites(int attractionId, {String? token}) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$attractionId/favorite',
        {},
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  // Remove from favorites
  static Future<void> removeFromFavorites(int attractionId,
      {String? token}) async {
    try {
      final response = await ApiService.delete(
        '$endpoint/$attractionId/favorite',
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }
}
