// lib/models/accommodation_model.dart
class AccommodationModel {
  final int id;
  final String name;
  final String location;
  final String description;
  final String imagePath;
  final double rating;
  final double price;
  final List<String> amenities;
  final String type;
  final double latitude;
  final double longitude;
  final int totalRooms;
  final int availableRooms;
  final bool isAvailable;
  final List<String> gallery;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccommodationModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.price,
    required this.amenities,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.totalRooms,
    required this.availableRooms,
    this.isAvailable = true,
    required this.gallery,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccommodationModel.fromJson(Map<String, dynamic> json) {
    return AccommodationModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      imagePath: json['image_path'],
      rating: json['rating'].toDouble(),
      price: json['price'].toDouble(),
      amenities: List<String>.from(json['amenities'] ?? []),
      type: json['type'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      totalRooms: json['total_rooms'],
      availableRooms: json['available_rooms'],
      isAvailable: json['is_available'] ?? true,
      gallery: List<String>.from(json['gallery'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'image_path': imagePath,
      'rating': rating,
      'price': price,
      'amenities': amenities,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'total_rooms': totalRooms,
      'available_rooms': availableRooms,
      'is_available': isAvailable,
      'gallery': gallery,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AccommodationModel copyWith({
    int? id,
    String? name,
    String? location,
    String? description,
    String? imagePath,
    double? rating,
    double? price,
    List<String>? amenities,
    String? type,
    double? latitude,
    double? longitude,
    int? totalRooms,
    int? availableRooms,
    bool? isAvailable,
    List<String>? gallery,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccommodationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      amenities: amenities ?? this.amenities,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalRooms: totalRooms ?? this.totalRooms,
      availableRooms: availableRooms ?? this.availableRooms,
      isAvailable: isAvailable ?? this.isAvailable,
      gallery: gallery ?? this.gallery,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
