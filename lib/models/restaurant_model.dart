import 'menu_item_model.dart';

class Restaurant {
  final String id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? description;
  final String? coverImage;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final String? ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MenuItem>? menuItems;
  final List<RestaurantImage>? images;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.description,
    this.coverImage,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isActive = true,
    this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.menuItems,
    this.images,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      coverImage: json['cover_image'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      ownerId: json['owner_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      menuItems: json['menu_items'] != null
          ? (json['menu_items'] as List)
              .map((item) => MenuItem.fromJson(item))
              .toList()
          : null,
      images: json['restaurant_images'] != null
          ? (json['restaurant_images'] as List)
              .map((image) => RestaurantImage.fromJson(image))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'description': description,
      'cover_image': coverImage,
      'rating': rating,
      'total_reviews': totalReviews,
      'is_active': isActive,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Restaurant copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? description,
    String? coverImage,
    double? rating,
    int? totalReviews,
    bool? isActive,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MenuItem>? menuItems,
    List<RestaurantImage>? images,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isActive: isActive ?? this.isActive,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      menuItems: menuItems ?? this.menuItems,
      images: images ?? this.images,
    );
  }
}



class RestaurantImage {
  final String id;
  final String restaurantId;
  final String imageUrl;
  final String? altText;
  final int displayOrder;
  final DateTime createdAt;

  RestaurantImage({
    required this.id,
    required this.restaurantId,
    required this.imageUrl,
    this.altText,
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory RestaurantImage.fromJson(Map<String, dynamic> json) {
    return RestaurantImage(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      imageUrl: json['image_url'] as String,
      altText: json['alt_text'] as String?,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'image_url': imageUrl,
      'alt_text': altText,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }
}