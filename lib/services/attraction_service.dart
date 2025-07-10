// lib/services/attraction_service.dart
// ignore_for_file: avoid_print

import 'dart:convert';
import '../models/attraction_model.dart';
import 'api_service.dart';

class AttractionService {
  static const String endpoint = '/attractions';

  // Fallback data for when API is not available
  static List<AttractionModel> _getFallbackAttractions() {
    return [
      AttractionModel(
        id: 1,
        name: 'Victoria Falls',
        location: 'Livingstone',
        description:
            'One of the Seven Natural Wonders of the World, locally known as "Mosi-oa-Tunya" (The Smoke That Thunders).',
        imagePath: 'assets/victoria_falls.jpg',
        rating: 4.9,
        price: 20.0,
        activities: ['Viewing', 'Photography', 'Helicopter Tours'],
        latitude: -17.9243,
        longitude: 25.8572,
        category: 'Natural Wonder',
        isPopular: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      AttractionModel(
        id: 2,
        name: 'South Luangwa National Park',
        location: 'Eastern Province',
        description:
            'Known for its abundant wildlife and walking safaris. Home to over 400 bird species and 60 different animal species.',
        imagePath: 'assets/south_luangwa.jpg',
        rating: 4.8,
        price: 25.0,
        activities: ['Game Drives', 'Walking Safaris', 'Bird Watching'],
        latitude: -13.0864,
        longitude: 31.8656,
        category: 'National Park',
        isPopular: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      AttractionModel(
        id: 3,
        name: 'Lower Zambezi National Park',
        location: 'Southern Province',
        description:
            'Offers exceptional game viewing along the Zambezi River with canoeing and fishing experiences.',
        imagePath: 'assets/lower_zambezi.jpg',
        rating: 4.7,
        price: 25.0,
        activities: ['Game Drives', 'Canoeing', 'Fishing'],
        latitude: -15.75,
        longitude: 29.25,
        category: 'National Park',
        isPopular: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      AttractionModel(
        id: 4,
        name: 'Kafue National Park',
        location: 'Central Zambia',
        description:
            'Zambia\'s oldest and largest national park with diverse landscapes and wildlife.',
        imagePath: 'assets/kafue_park.jpg',
        rating: 4.6,
        price: 20.0,
        activities: ['Game Drives', 'Bush Walks', 'Boat Trips'],
        latitude: -15.5,
        longitude: 26.0,
        category: 'National Park',
        isPopular: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      AttractionModel(
        id: 5,
        name: 'Livingstone Museum',
        location: 'Livingstone',
        description:
            'Zambia\'s largest and oldest museum, featuring exhibits on David Livingstone and local culture.',
        imagePath: 'assets/livingstone_museum.jpg',
        rating: 4.3,
        price: 5.0,
        activities: [
          'Museum Tours',
          'Cultural Exhibits',
          'Historical Learning'
        ],
        latitude: -17.8419,
        longitude: 25.8564,
        category: 'Museum',
        isPopular: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // Get all attractions
  static Future<List<AttractionModel>> getAllAttractions() async {
    try {
      final response = await ApiService.get(endpoint);
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AttractionModel.fromJson(json)).toList();
    } catch (e) {
      print('API Error, using fallback data: $e');
      // Return fallback data when API is not available
      return _getFallbackAttractions();
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
      print('API Error, using fallback data: $e');
      return _getFallbackAttractions()
          .where((a) => a.category == category)
          .toList();
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
      print('API Error, using fallback data: $e');
      return _getFallbackAttractions().where((a) => a.isPopular).toList();
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
      print('API Error, using fallback data: $e');
      final fallbackAttractions = _getFallbackAttractions();
      final attraction = fallbackAttractions.firstWhere(
        (a) => a.id == id,
        orElse: () => fallbackAttractions.first,
      );
      return attraction;
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
      print('API Error, using fallback data: $e');
      return _getFallbackAttractions()
          .where((a) =>
              a.name.toLowerCase().contains(query.toLowerCase()) ||
              a.location.toLowerCase().contains(query.toLowerCase()) ||
              a.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
      print('API Error, using fallback data: $e');
      return _getFallbackAttractions()
          .where(
              (a) => a.location.toLowerCase().contains(location.toLowerCase()))
          .toList();
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
      print('API Error, using fallback data: $e');
      // Return all attractions as nearby for fallback
      return _getFallbackAttractions();
    }
  }

  // Rate an attraction (mock for fallback)
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
      print('API Error, rating saved locally: $e');
      // Mock implementation for offline mode
    }
  }

  // Add to favorites (mock for fallback)
  static Future<void> addToFavorites(int attractionId, {String? token}) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$attractionId/favorite',
        {},
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      print('API Error, favorite saved locally: $e');
      // Mock implementation for offline mode
    }
  }

  // Remove from favorites (mock for fallback)
  static Future<void> removeFromFavorites(int attractionId,
      {String? token}) async {
    try {
      final response = await ApiService.delete(
        '$endpoint/$attractionId/favorite',
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      print('API Error, favorite removed locally: $e');
      // Mock implementation for offline mode
    }
  }
}
