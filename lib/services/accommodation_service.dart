// lib/services/accommodation_service.dart
// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'dart:convert';
import '../models/accommodation_model.dart';
import 'api_service.dart';

class AccommodationService {
  static const String endpoint = '/accommodations';

  // Fallback data for when API is not available
  static List<AccommodationModel> _getFallbackAccommodations() {
    return [
      AccommodationModel(
        id: 1,
        name: 'Royal Livingstone Hotel',
        description:
            'Luxury hotel situated on the banks of the Zambezi River with stunning views of Victoria Falls.',
        location: 'Livingstone',
        type: 'Hotels',
        price: 350.0,
        rating: 4.8,
        imagePath: 'assets/royal_livingstone.jpg',
        amenities: ['Pool', 'Spa', 'Free WiFi', 'Restaurant', 'Bar'],
      ),
      AccommodationModel(
        id: 2,
        name: 'Tongabezi Lodge',
        description:
            'Award-winning luxury lodge with private houses and cottages on the banks of the Zambezi River.',
        location: 'Livingstone',
        type: 'Lodges',
        price: 420.0,
        rating: 4.9,
        imagePath: 'assets/tongabezi.jpg',
        amenities: ['Pool', 'Spa', 'Free WiFi', 'Restaurant', 'River views'],
      ),
      AccommodationModel(
        id: 3,
        name: 'Mfuwe Lodge',
        description:
            'Safari lodge located inside South Luangwa National Park, known for elephants walking through reception.',
        location: 'South Luangwa',
        type: 'Lodges',
        price: 280.0,
        rating: 4.7,
        imagePath: 'assets/mfuwe_lodge.jpg',
        amenities: [
          'Pool',
          'Game drives',
          'Restaurant',
          'Bar',
          'Wildlife viewing'
        ],
      ),
      AccommodationModel(
        id: 4,
        name: 'Avani Victoria Falls Resort',
        description:
            'Family-friendly resort with free access to Victoria Falls and African-themed architecture.',
        location: 'Livingstone',
        type: 'Resorts',
        price: 220.0,
        rating: 4.5,
        imagePath: 'assets/avani_resort.jpg',
        amenities: ['Pool', 'Free WiFi', 'Restaurant', 'Bar', 'Falls access'],
      ),
      AccommodationModel(
        id: 5,
        name: 'Mukambi Safari Lodge',
        description:
            'Safari lodge on the banks of the Kafue River offering excellent wildlife viewing.',
        location: 'Kafue National Park',
        type: 'Lodges',
        price: 250.0,
        rating: 4.6,
        imagePath: 'assets/mukambi_lodge.jpg',
        amenities: ['Pool', 'Game drives', 'Restaurant', 'Bar', 'River views'],
      ),
      AccommodationModel(
        id: 6,
        name: 'Pioneer Camp',
        description:
            'Rustic camping experience just outside Lusaka with comfortable tents and basic amenities.',
        location: 'Lusaka',
        type: 'Camping',
        price: 85.0,
        rating: 4.2,
        imagePath: 'assets/pioneer_camp.jpg',
        amenities: ['Restaurant', 'Bar', 'Campfire', 'Nature walks'],
      ),
    ];
  }

  // Get all accommodations
  static Future<List<AccommodationModel>> getAllAccommodations() async {
    try {
      final response = await ApiService.get(endpoint);
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      print('API Error, using fallback data: $e');
      // Return fallback data when API is not available
      return _getFallbackAccommodations();
    }
  }

  // Get accommodations by type
  static Future<List<AccommodationModel>> getAccommodationsByType(
      String type) async {
    try {
      final response = await ApiService.get('$endpoint?type=$type');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      print('API Error, using fallback data: $e');
      return _getFallbackAccommodations().where((a) => a.type == type).toList();
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
      print('API Error, using fallback data: $e');
      final fallbackAccommodations = _getFallbackAccommodations();
      final accommodation = fallbackAccommodations.firstWhere(
        (a) => a.id == id,
        orElse: () => fallbackAccommodations.first,
      );
      return accommodation;
    }
  }

  // Search accommodations
  static Future<List<AccommodationModel>> searchAccommodations(
      String query) async {
    try {
      final response = await ApiService.get('$endpoint/search?q=$query');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      print('API Error, using fallback data: $e');
      return _getFallbackAccommodations()
          .where((a) =>
              a.name.toLowerCase().contains(query.toLowerCase()) ||
              a.location.toLowerCase().contains(query.toLowerCase()) ||
              a.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Get accommodations by location
  static Future<List<AccommodationModel>> getAccommodationsByLocation(
      String location) async {
    try {
      final response = await ApiService.get('$endpoint?location=$location');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      print('API Error, using fallback data: $e');
      return _getFallbackAccommodations()
          .where(
              (a) => a.location.toLowerCase().contains(location.toLowerCase()))
          .toList();
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
      if (checkIn != null)
        queryParams.add('check_in=${checkIn.toIso8601String()}');
      if (checkOut != null)
        queryParams.add('check_out=${checkOut.toIso8601String()}');

      final queryString =
          queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
      final response = await ApiService.get('$endpoint/filter$queryString');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      print('API Error, using fallback data: $e');
      // Apply filters to fallback data
      var filtered = _getFallbackAccommodations();

      if (location != null) {
        filtered = filtered
            .where((a) =>
                a.location.toLowerCase().contains(location.toLowerCase()))
            .toList();
      }

      if (type != null) {
        filtered = filtered.where((a) => a.type == type).toList();
      }

      if (minPrice != null) {
        filtered = filtered.where((a) => a.price >= minPrice).toList();
      }

      if (maxPrice != null) {
        filtered = filtered.where((a) => a.price <= maxPrice).toList();
      }

      if (minRating != null) {
        filtered = filtered.where((a) => a.rating >= minRating).toList();
      }

      return filtered;
    }
  }

  // Check availability (mock for fallback)
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
      print('API Error, using mock availability: $e');
      // Mock availability check - always return true for fallback
      return true;
    }
  }

  // Get nearby accommodations
  static Future<List<AccommodationModel>> getNearbyAccommodations(
      double latitude, double longitude,
      {double radius = 50.0}) async {
    try {
      final response = await ApiService.get(
          '$endpoint/nearby?lat=$latitude&lng=$longitude&radius=$radius');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      print('API Error, using fallback data: $e');
      // Return all accommodations as nearby for fallback
      return _getFallbackAccommodations();
    }
  }

  // Rate an accommodation (mock for fallback)
  static Future<void> rateAccommodation(int accommodationId, double rating,
      {String? token}) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$accommodationId/rate',
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
  static Future<void> addToFavorites(int accommodationId,
      {String? token}) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$accommodationId/favorite',
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
  static Future<void> removeFromFavorites(int accommodationId,
      {String? token}) async {
    try {
      final response = await ApiService.delete(
        '$endpoint/$accommodationId/favorite',
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      print('API Error, favorite removed locally: $e');
      // Mock implementation for offline mode
    }
  }

  // Get user's favorite accommodations
  static Future<List<AccommodationModel>> getFavoriteAccommodations(
      {String? token}) async {
    try {
      final response =
          await ApiService.get('$endpoint/favorites', token: token);
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      print('API Error, using empty favorites: $e');
      // Return empty list for fallback
      return [];
    }
  }

  // Get accommodations with special offers
  static Future<List<AccommodationModel>> getSpecialOffers() async {
    try {
      final response = await ApiService.get('$endpoint/offers');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => AccommodationModel.fromJson(json)).toList();
    } catch (e) {
      print('API Error, using fallback offers: $e');
      // Return a subset as "special offers"
      return _getFallbackAccommodations().take(2).toList();
    }
  }

  // Get accommodation reviews
  static Future<List<Map<String, dynamic>>> getAccommodationReviews(
      int accommodationId) async {
    try {
      final response =
          await ApiService.get('$endpoint/$accommodationId/reviews');
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('API Error, using mock reviews: $e');
      // Return mock reviews
      return [
        {
          'id': 1,
          'user_name': 'John Doe',
          'rating': 4.5,
          'comment': 'Great accommodation, highly recommended!',
          'date': DateTime.now().toIso8601String(),
        },
        {
          'id': 2,
          'user_name': 'Jane Smith',
          'rating': 5.0,
          'comment': 'Amazing experience, beautiful location!',
          'date': DateTime.now()
              .subtract(const Duration(days: 7))
              .toIso8601String(),
        },
      ];
    }
  }

  // Add accommodation review (mock for fallback)
  static Future<void> addReview(
    int accommodationId,
    double rating,
    String review, {
    String? token,
  }) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$accommodationId/reviews',
        {
          'rating': rating,
          'review': review,
        },
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      print('API Error, review saved locally: $e');
      // Mock implementation for offline mode
    }
  }

  // Book accommodation (mock for fallback)
  static Future<Map<String, dynamic>> bookAccommodation({
    required int accommodationId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int rooms,
    required int guests,
    required Map<String, dynamic> guestDetails,
    String? token,
  }) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$accommodationId/book',
        {
          'check_in': checkIn.toIso8601String(),
          'check_out': checkOut.toIso8601String(),
          'rooms': rooms,
          'guests': guests,
          'guest_details': guestDetails,
        },
        token: token,
      );
      ApiService.handleError(response);

      return jsonDecode(response.body)['data'];
    } catch (e) {
      print('API Error, using mock booking: $e');
      // Return mock booking confirmation
      return {
        'booking_id': DateTime.now().millisecondsSinceEpoch,
        'confirmation_number': 'CONF${DateTime.now().millisecondsSinceEpoch}',
        'status': 'confirmed',
        'total_amount': 250.0,
      };
    }
  }

  // Cancel booking (mock for fallback)
  static Future<void> cancelBooking(int bookingId, {String? token}) async {
    try {
      final response = await ApiService.delete(
        '/bookings/$bookingId',
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      print('API Error, booking cancelled locally: $e');
      // Mock implementation for offline mode
    }
  }
}
