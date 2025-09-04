class Hotel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String? city;
  final String wilaya;
  final String? postalCode;
  final String phone;
  final String? email;
  final String? website;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final String? imageUrl;
  final int? starRating;
  final double? priceRangeMin;
  final double? priceRangeMax;
  final String ownerId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    this.city,
    required this.wilaya,
    this.postalCode,
    required this.phone,
    this.email,
    this.website,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    this.imageUrl,
    this.starRating,
    this.priceRangeMin,
    this.priceRangeMax,
    required this.ownerId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'],
      wilaya: json['wilaya'] ?? '',
      postalCode: json['postal_code'],
      phone: json['phone'] ?? '',
      email: json['email'],
      website: json['website'],
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['total_reviews'] ?? 0,
      imageUrl: json['cover_image'],
      starRating: json['star_rating'],
      priceRangeMin: json['price_range_min']?.toDouble(),
      priceRangeMax: json['price_range_max']?.toDouble(),
      ownerId: json['owner_id'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'wilaya': wilaya,
      'postal_code': postalCode,
      'phone': phone,
      'email': email,
      'website': website,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'total_reviews': reviewCount,
      'cover_image': imageUrl,
      'star_rating': starRating,
      'price_range_min': priceRangeMin,
      'price_range_max': priceRangeMax,
      'owner_id': ownerId,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get formattedRating => rating.toStringAsFixed(1);
  int get totalReviews => reviewCount;
  String get displayLocation => '$address, $wilaya';
  String get displayStars => starRating != null ? '★' * starRating! : '';
  bool get hasCoverImage => imageUrl != null && imageUrl!.isNotEmpty;
  String? get coverImage => imageUrl;

  String get displayPriceRange => 'من 5000 دج - 15000 دج';
}

class RoomType {
  final String id;
  final String hotelId;
  final String name;
  final String description;
  final int maxOccupancy;
  final String bedType;
  final double roomSizeSqm;
  final double pricePerNight;
  final int totalRooms;
  final List<String> amenities;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoomType({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.description,
    required this.maxOccupancy,
    required this.bedType,
    required this.roomSizeSqm,
    required this.pricePerNight,
    required this.totalRooms,
    required this.amenities,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['id'] ?? '',
      hotelId: json['hotel_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      maxOccupancy: json['max_occupancy'] ?? 1,
      bedType: json['bed_type'] ?? '',
      roomSizeSqm: (json['room_size_sqm'] ?? 0.0).toDouble(),
      pricePerNight: (json['price_per_night'] ?? 0.0).toDouble(),
      totalRooms: json['total_rooms'] ?? 1,
      amenities: List<String>.from(json['amenities'] ?? []),
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get formattedPrice => '${pricePerNight.toStringAsFixed(0)} دج/ليلة';
  String get displayRoomSize => '${roomSizeSqm.toStringAsFixed(0)} م²';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'name': name,
      'description': description,
      'max_occupancy': maxOccupancy,
      'bed_type': bedType,
      'room_size_sqm': roomSizeSqm,
      'price_per_night': pricePerNight,
      'total_rooms': totalRooms,
      'amenities': amenities,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class HotelAmenity {
  final String id;
  final String hotelId;
  final String amenityName;
  final String? amenityType;
  final bool isFree;
  final double? additionalCost;
  final DateTime createdAt;

  HotelAmenity({
    required this.id,
    required this.hotelId,
    required this.amenityName,
    this.amenityType,
    required this.isFree,
    this.additionalCost,
    required this.createdAt,
  });

  factory HotelAmenity.fromJson(Map<String, dynamic> json) {
    return HotelAmenity(
      id: json['id'] ?? '',
      hotelId: json['hotel_id'] ?? '',
      amenityName: json['amenity_name'] ?? '',
      amenityType: json['amenity_type'],
      isFree: json['is_free'] ?? true,
      additionalCost: json['additional_cost']?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get displayCost => isFree ? 'مجاني' : (additionalCost != null ? '${additionalCost!.toStringAsFixed(0)} دج' : 'غير محدد');

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'amenity_name': amenityName,
      'amenity_type': amenityType,
      'is_free': isFree,
      'additional_cost': additionalCost,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class HotelImage {
  final String id;
  final String hotelId;
  final String? roomTypeId;
  final String imageUrl;
  final String? altText;
  final String imageType;
  final int displayOrder;
  final DateTime createdAt;

  HotelImage({
    required this.id,
    required this.hotelId,
    this.roomTypeId,
    required this.imageUrl,
    this.altText,
    required this.imageType,
    required this.displayOrder,
    required this.createdAt,
  });

  factory HotelImage.fromJson(Map<String, dynamic> json) {
    return HotelImage(
      id: json['id'] ?? '',
      hotelId: json['hotel_id'] ?? '',
      roomTypeId: json['room_type_id'],
      imageUrl: json['image_url'] ?? '',
      altText: json['alt_text'],
      imageType: json['image_type'] ?? 'general',
      displayOrder: json['display_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'room_type_id': roomTypeId,
      'image_url': imageUrl,
      'alt_text': altText,
      'image_type': imageType,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class HotelPolicy {
  final String id;
  final String hotelId;
  final String policyType;
  final String? policyTitle;
  final String policyDescription;
  final bool isActive;
  final DateTime createdAt;

  HotelPolicy({
    required this.id,
    required this.hotelId,
    required this.policyType,
    this.policyTitle,
    required this.policyDescription,
    required this.isActive,
    required this.createdAt,
  });

  factory HotelPolicy.fromJson(Map<String, dynamic> json) {
    return HotelPolicy(
      id: json['id'] ?? '',
      hotelId: json['hotel_id'] ?? '',
      policyType: json['policy_type'] ?? '',
      policyTitle: json['policy_title'],
      policyDescription: json['policy_description'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'policy_type': policyType,
      'policy_title': policyTitle,
      'policy_description': policyDescription,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}