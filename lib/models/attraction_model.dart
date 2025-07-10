// lib/models/attraction_model.dart
class AttractionModel {
  final int id;
  final String name;
  final String location;
  final String description;
  final String imagePath;
  final double rating;
  final double price;
  final List<String> activities;
  final double latitude;
  final double longitude;
  final String category;
  final bool isPopular;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttractionModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.price,
    required this.activities,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.isPopular = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttractionModel.fromJson(Map<String, dynamic> json) {
    return AttractionModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      imagePath: json['image_path'],
      rating: json['rating'].toDouble(),
      price: json['price'].toDouble(),
      activities: List<String>.from(json['activities'] ?? []),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      category: json['category'],
      isPopular: json['is_popular'] ?? false,
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
      'activities': activities,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'is_popular': isPopular,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AttractionModel copyWith({
    int? id,
    String? name,
    String? location,
    String? description,
    String? imagePath,
    double? rating,
    double? price,
    List<String>? activities,
    double? latitude,
    double? longitude,
    String? category,
    bool? isPopular,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttractionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      activities: activities ?? this.activities,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      isPopular: isPopular ?? this.isPopular,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
