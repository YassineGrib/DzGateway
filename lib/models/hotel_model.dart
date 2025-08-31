class Hotel {
  final String id;
  final String name;
  final String? phone;
  final String? address;
  final String? city;
  final String? wilaya;
  final String? description;
  final String? coverImage;
  final int? starRating;
  final String? priceRange;
  final double rating;
  final int totalReviews;
  final String? checkInTime;
  final String? checkOutTime;
  final bool isActive;
  final String? ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RoomType>? roomTypes;
  final List<HotelAmenity>? amenities;
  final List<HotelImage>? images;
  final List<HotelPolicy>? policies;

  const Hotel({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.city,
    this.wilaya,
    this.description,
    this.coverImage,
    this.starRating,
    this.priceRange,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.checkInTime,
    this.checkOutTime,
    this.isActive = true,
    this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.roomTypes,
    this.amenities,
    this.images,
    this.policies,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      wilaya: json['wilaya'] as String?,
      description: json['description'] as String?,
      coverImage: json['cover_image'] as String?,
      starRating: json['star_rating'] as int?,
      priceRange: json['price_range'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      ownerId: json['owner_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      roomTypes: json['room_types'] != null
          ? (json['room_types'] as List)
              .map((item) => RoomType.fromJson(item))
              .toList()
          : null,
      amenities: json['amenities'] != null
          ? (json['amenities'] as List)
              .map((item) => HotelAmenity.fromJson(item))
              .toList()
          : null,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((item) => HotelImage.fromJson(item))
              .toList()
          : null,
      policies: json['policies'] != null
          ? (json['policies'] as List)
              .map((item) => HotelPolicy.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'wilaya': wilaya,
      'description': description,
      'cover_image': coverImage,
      'star_rating': starRating,
      'price_range': priceRange,
      'rating': rating,
      'total_reviews': totalReviews,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'is_active': isActive,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'room_types': roomTypes?.map((item) => item.toJson()).toList(),
      'amenities': amenities?.map((item) => item.toJson()).toList(),
      'images': images?.map((item) => item.toJson()).toList(),
      'policies': policies?.map((item) => item.toJson()).toList(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'wilaya': wilaya,
      'description': description,
      'cover_image': coverImage,
      'star_rating': starRating,
      'price_range': priceRange,
      'rating': rating,
      'total_reviews': totalReviews,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'is_active': isActive,
      'owner_id': ownerId,
    };
  }

  Hotel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? city,
    String? wilaya,
    String? description,
    String? coverImage,
    int? starRating,
    String? priceRange,
    double? rating,
    int? totalReviews,
    String? checkInTime,
    String? checkOutTime,
    bool? isActive,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<RoomType>? roomTypes,
    List<HotelAmenity>? amenities,
    List<HotelImage>? images,
    List<HotelPolicy>? policies,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      wilaya: wilaya ?? this.wilaya,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      starRating: starRating ?? this.starRating,
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      isActive: isActive ?? this.isActive,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      roomTypes: roomTypes ?? this.roomTypes,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      policies: policies ?? this.policies,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hotel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Hotel(id: $id, name: $name, city: $city, wilaya: $wilaya, rating: $rating)';
  }

  // Helper methods
  String get displayStars {
    if (starRating == null) return '';
    return '★' * starRating!;
  }

  String get formattedRating {
    return rating.toStringAsFixed(1);
  }

  bool get hasCoverImage => coverImage != null && coverImage!.isNotEmpty;

  String get displayLocation {
    if (city != null && wilaya != null) {
      return '$city، $wilaya';
    } else if (wilaya != null) {
      return wilaya!;
    } else if (city != null) {
      return city!;
    }
    return 'غير محدد';
  }

  String get displayPriceRange {
    return priceRange ?? 'السعر غير محدد';
  }
}

class RoomType {
  final String id;
  final String hotelId;
  final String name;
  final String? description;
  final int maxOccupancy;
  final String? bedType;
  final double? roomSizeSqm;
  final double pricePerNight;
  final int totalRooms;
  final List<String>? amenities;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RoomType({
    required this.id,
    required this.hotelId,
    required this.name,
    this.description,
    required this.maxOccupancy,
    this.bedType,
    this.roomSizeSqm,
    required this.pricePerNight,
    this.totalRooms = 1,
    this.amenities,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['id'] as String,
      hotelId: json['hotel_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      maxOccupancy: json['max_occupancy'] as int,
      bedType: json['bed_type'] as String?,
      roomSizeSqm: (json['room_size_sqm'] as num?)?.toDouble(),
      pricePerNight: (json['price_per_night'] as num).toDouble(),
      totalRooms: json['total_rooms'] as int? ?? 1,
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'] as List)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

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

  String get formattedPrice {
    return '${pricePerNight.toStringAsFixed(0)} دج/ليلة';
  }

  String get displayRoomSize {
    if (roomSizeSqm != null) {
      return '${roomSizeSqm!.toStringAsFixed(0)} م²';
    }
    return '';
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

  const HotelAmenity({
    required this.id,
    required this.hotelId,
    required this.amenityName,
    this.amenityType,
    this.isFree = true,
    this.additionalCost,
    required this.createdAt,
  });

  factory HotelAmenity.fromJson(Map<String, dynamic> json) {
    return HotelAmenity(
      id: json['id'] as String,
      hotelId: json['hotel_id'] as String,
      amenityName: json['amenity_name'] as String,
      amenityType: json['amenity_type'] as String?,
      isFree: json['is_free'] as bool? ?? true,
      additionalCost: (json['additional_cost'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

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

  String get displayCost {
    if (isFree) return 'مجاني';
    if (additionalCost != null) {
      return '${additionalCost!.toStringAsFixed(0)} دج';
    }
    return 'مدفوع';
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

  const HotelImage({
    required this.id,
    required this.hotelId,
    this.roomTypeId,
    required this.imageUrl,
    this.altText,
    this.imageType = 'general',
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory HotelImage.fromJson(Map<String, dynamic> json) {
    return HotelImage(
      id: json['id'] as String,
      hotelId: json['hotel_id'] as String,
      roomTypeId: json['room_type_id'] as String?,
      imageUrl: json['image_url'] as String,
      altText: json['alt_text'] as String?,
      imageType: json['image_type'] as String? ?? 'general',
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
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

  const HotelPolicy({
    required this.id,
    required this.hotelId,
    required this.policyType,
    this.policyTitle,
    required this.policyDescription,
    this.isActive = true,
    required this.createdAt,
  });

  factory HotelPolicy.fromJson(Map<String, dynamic> json) {
    return HotelPolicy(
      id: json['id'] as String,
      hotelId: json['hotel_id'] as String,
      policyType: json['policy_type'] as String,
      policyTitle: json['policy_title'] as String?,
      policyDescription: json['policy_description'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
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