// lib/services/booking_service.dart
import 'dart:convert';
import '../models/booking_model.dart';
import 'api_service.dart';

class BookingService {
  static const String endpoint = '/bookings';

  // Create a new booking
  static Future<BookingModel> createBooking({
    required int itemId,
    required BookingType type,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int adultCount,
    required int childCount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String? specialRequests,
    String? token,
  }) async {
    try {
      final bookingData = {
        'item_id': itemId,
        'type': type.toString().split('.').last,
        'check_in_date': checkInDate.toIso8601String(),
        'check_out_date': checkOutDate.toIso8601String(),
        'adult_count': adultCount,
        'child_count': childCount,
        'customer_name': customerName,
        'customer_email': customerEmail,
        'customer_phone': customerPhone,
        if (specialRequests != null) 'special_requests': specialRequests,
      };

      final response =
          await ApiService.post(endpoint, bookingData, token: token);
      ApiService.handleError(response);

      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return BookingModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  // Get all user bookings
  static Future<List<BookingModel>> getUserBookings({String? token}) async {
    try {
      final response = await ApiService.get('$endpoint/user', token: token);
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch user bookings: $e');
    }
  }

  // Get booking by ID
  static Future<BookingModel> getBookingById(int id, {String? token}) async {
    try {
      final response = await ApiService.get('$endpoint/$id', token: token);
      ApiService.handleError(response);

      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return BookingModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch booking: $e');
    }
  }

  // Update booking status
  static Future<BookingModel> updateBookingStatus(
      int bookingId, BookingStatus status,
      {String? token}) async {
    try {
      final response = await ApiService.put(
        '$endpoint/$bookingId/status',
        {'status': status.toString().split('.').last},
        token: token,
      );
      ApiService.handleError(response);

      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return BookingModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  // Cancel booking
  static Future<BookingModel> cancelBooking(int bookingId,
      {String? token}) async {
    try {
      final response = await ApiService.put(
        '$endpoint/$bookingId/cancel',
        {},
        token: token,
      );
      ApiService.handleError(response);

      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return BookingModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  // Get bookings by status
  static Future<List<BookingModel>> getBookingsByStatus(BookingStatus status,
      {String? token}) async {
    try {
      final statusString = status.toString().split('.').last;
      final response = await ApiService.get(
          '$endpoint/user?status=$statusString',
          token: token);
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings by status: $e');
    }
  }

  // Get upcoming bookings
  static Future<List<BookingModel>> getUpcomingBookings({String? token}) async {
    try {
      final response =
          await ApiService.get('$endpoint/user/upcoming', token: token);
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming bookings: $e');
    }
  }

  // Get past bookings
  static Future<List<BookingModel>> getPastBookings({String? token}) async {
    try {
      final response =
          await ApiService.get('$endpoint/user/past', token: token);
      ApiService.handleError(response);

      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch past bookings: $e');
    }
  }

  // Calculate booking price
  static Future<double> calculatePrice({
    required int itemId,
    required BookingType type,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int adultCount,
    required int childCount,
  }) async {
    try {
      final response = await ApiService.post(
        '$endpoint/calculate-price',
        {
          'item_id': itemId,
          'type': type.toString().split('.').last,
          'check_in_date': checkInDate.toIso8601String(),
          'check_out_date': checkOutDate.toIso8601String(),
          'adult_count': adultCount,
          'child_count': childCount,
        },
      );
      ApiService.handleError(response);

      final data = jsonDecode(response.body);
      return data['total_price'].toDouble();
    } catch (e) {
      throw Exception('Failed to calculate price: $e');
    }
  }

  // Send booking confirmation email
  static Future<void> sendConfirmationEmail(int bookingId,
      {String? token}) async {
    try {
      final response = await ApiService.post(
        '$endpoint/$bookingId/send-confirmation',
        {},
        token: token,
      );
      ApiService.handleError(response);
    } catch (e) {
      throw Exception('Failed to send confirmation email: $e');
    }
  }
}
