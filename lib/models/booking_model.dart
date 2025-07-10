// lib/models/booking_model.dart
enum BookingStatus { pending, confirmed, cancelled, completed }

enum BookingType { attraction, accommodation }

class BookingModel {
  final int id;
  final int userId;
  final int itemId; // attraction or accommodation id
  final BookingType type;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int adultCount;
  final int childCount;
  final double totalPrice;
  final BookingStatus status;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String? specialRequests;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.type,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adultCount,
    required this.childCount,
    required this.totalPrice,
    required this.status,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    this.specialRequests,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      userId: json['user_id'],
      itemId: json['item_id'],
      type: BookingType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      checkInDate: DateTime.parse(json['check_in_date']),
      checkOutDate: DateTime.parse(json['check_out_date']),
      adultCount: json['adult_count'],
      childCount: json['child_count'],
      totalPrice: json['total_price'].toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      customerName: json['customer_name'],
      customerEmail: json['customer_email'],
      customerPhone: json['customer_phone'],
      specialRequests: json['special_requests'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'item_id': itemId,
      'type': type.toString().split('.').last,
      'check_in_date': checkInDate.toIso8601String(),
      'check_out_date': checkOutDate.toIso8601String(),
      'adult_count': adultCount,
      'child_count': childCount,
      'total_price': totalPrice,
      'status': status.toString().split('.').last,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'special_requests': specialRequests,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  int get totalDays => checkOutDate.difference(checkInDate).inDays;

  BookingModel copyWith({
    int? id,
    int? userId,
    int? itemId,
    BookingType? type,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? adultCount,
    int? childCount,
    double? totalPrice,
    BookingStatus? status,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? specialRequests,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      adultCount: adultCount ?? this.adultCount,
      childCount: childCount ?? this.childCount,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      specialRequests: specialRequests ?? this.specialRequests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
