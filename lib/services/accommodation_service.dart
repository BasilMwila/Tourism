// lib/services/accommodation_service.dart
import 'dart:convert';
import '../models/accommodation_model.dart';
import 'api_service.dart';

class AccommodationService {
  static const String endpoint = '/accommodations';

  // Get all accommodations
  static Future<List<AccommodationModel>> getAllAccommodations() async {
    try {
      final response = await ApiService.get(endpoint);
      ApiService.handleError(response);
      
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to filter accommodations: $e');
    }
  }

  // Check availability
  static Future<bool> checkAvailability(
    int accommodationId,
    DateTime checkIn,
    DateTime checkOut,
    int rooms,
  ) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$accommodationId/availability',
        {
          'check_in': checkIn.toIso8601String(),
          'check_out': checkOut.toIso8601String(),
          'rooms': rooms,
        },
      );
      ApiService.handleError(response);
      
      final data = jsonDecode(response.body);
      return data['available'] ?? false;
    } catch (e) {
      throw Exception('Failed to check availability: $e');
    }
  }

  // Get nearby accommodations
  static Future<List<AccommodationModel>> getNearbyAccommodations(
    double latitude, 
    double longitude, 
    {double radius = 50.0}
  ) async {
    try {
      final response = await ApiService.get(
        '$endpoint/nearby?lat=$latitude&lng=$longitude&radius=$radius'
      );
      ApiService.handleError(response);
      
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch nearby accommodations: $e');
    }
  }

  // Rate an accommodation
  static Future<void> rateAccommodation(int accommodationId, double rating, {String? token}) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$accommodationId/rate',
        {'rating': rating},
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to rate accommodation: $e');
    }
  }

  // Add to favorites
  static Future<void> addToFavorites(int accommodationId, {String? token}) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$accommodationId/favorite',
        {},
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  // Remove from favorites
  static Future<void> removeFromFavorites(int accommodationId, {String? token}) async {
    try {
      final response = await ApiService.delete(
        '$endpoint/$accommodationId/favorite',
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }
} (e) {
      throw Exception('Failed to fetch accommodations: $e');
    }
  }

  // Get accommodations by type
  static Future<List<AccommodationModel>> getAccommodationsByType(String type) async {
    try {
      final response = await ApiService.get('$endpoint?type=$type');
      ApiService.handleError(response);
      
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch accommodations by type: $e');
    }
  }

  // Get accommodation by ID
  static Future<AccommodationModel> getAccommodationById(int id) async {
    try {
      final response = await ApiService.get('$endpoint/$id');
      ApiService.handleError(response);
      
      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return AccommodationModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch accommodation: $e');
    }
  }

  // Search accommodations
  static Future<List<AccommodationModel>> searchAccommodations(String query) async {
    try {
      final response = await ApiService.get('$endpoint/search?q=$query');
      ApiService.handleError(response);
      
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search accommodations: $e');
    }
  }

  // Get accommodations by location
  static Future<List<AccommodationModel>> getAccommodationsByLocation(String location) async {
    try {
      final response = await ApiService.get('$endpoint?location=$location');
      ApiService.handleError(response);
      
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch accommodations by location: $e');
    }
  }

  // Filter accommodations
  static Future<List<AccommodationModel>> filterAccommodations({
    String? location,
    String? type,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? amenities,
    DateTime? checkIn,
    DateTime? checkOut,
  }) async {
    try {
      final queryParams = <String>[];
      
      if (location != null) queryParams.add('location=$location');
      if (type != null) queryParams.add('type=$type');
      if (minPrice != null) queryParams.add('min_price=$minPrice');
      if (maxPrice != null) queryParams.add('max_price=$maxPrice');
      if (minRating != null) queryParams.add('min_rating=$minRating');
      if (amenities != null && amenities.isNotEmpty) {
        queryParams.add('amenities=${amenities.join(',')}');
      }
      if (checkIn != null) queryParams.add('check_in=${checkIn.toIso8601String()}');
      if (checkOut != null) queryParams.add('check_out=${checkOut.toIso8601String()}');
      
      final queryString = queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
      final response = await ApiService.get('$endpoint/filter$queryString');
      ApiService.handleError(response);
      
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to filter accommodations: $e');
    }}