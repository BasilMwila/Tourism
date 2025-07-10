// lib/models/accommodation_model.dart
class AccommodationModel {
  final int id;
  final String name;
  final String description;
  final String location;
  final String type;
  final double price;
  final double rating;
  final String imagePath;
  final List<String> amenities;
  final List<String> images;
  final Map<String, dynamic>? coordinates;
  final bool isAvailable;
  final bool isFavorite;
  final int reviewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AccommodationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.type,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.amenities,
    this.images = const [],
    this.coordinates,
    this.isAvailable = true,
    this.isFavorite = false,
    this.reviewCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory AccommodationModel.fromJson(Map<String, dynamic> json) {
    return AccommodationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      imagePath: json['image_path'] ?? json['imagePath'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      coordinates: json['coordinates'],
      isAvailable: json['is_available'] ?? json['isAvailable'] ?? true,
      isFavorite: json['is_favorite'] ?? json['isFavorite'] ?? false,
      reviewCount: json['review_count'] ?? json['reviewCount'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'type': type,
      'price': price,
      'rating': rating,
      'image_path': imagePath,
      'amenities': amenities,
      'images': images,
      'coordinates': coordinates,
      'is_available': isAvailable,
      'is_favorite': isFavorite,
      'review_count': reviewCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AccommodationModel copyWith({
    int? id,
    String? name,
    String? description,
    String? location,
    String? type,
    double? price,
    double? rating,
    String? imagePath,
    List<String>? amenities,
    List<String>? images,
    Map<String, dynamic>? coordinates,
    bool? isAvailable,
    bool? isFavorite,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccommodationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      type: type ?? this.type,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      imagePath: imagePath ?? this.imagePath,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      coordinates: coordinates ?? this.coordinates,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite ?? this.isFavorite,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'AccommodationModel(id: $id, name: $name, location: $location, type: $type, price: $price, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccommodationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
