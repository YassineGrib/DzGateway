class TouristArea {
  final String id;
  final String name;
  final String? description;
  final String? address;
  final String? city;
  final String? wilaya;
  final double? latitude;
  final double? longitude;
  final String? areaType;
  final String? coverImage;
  final double? entryFee;
  final String? openingHours;
  final String? bestVisitSeason;
  final String? difficultyLevel;
  final String? estimatedVisitDuration;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TouristAreaFeature>? features;
  final List<TouristAreaImage>? images;
  final List<TouristAreaTip>? tips;

  const TouristArea({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.city,
    this.wilaya,
    this.latitude,
    this.longitude,
    this.areaType,
    this.coverImage,
    this.entryFee,
    this.openingHours,
    this.bestVisitSeason,
    this.difficultyLevel,
    this.estimatedVisitDuration,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.features,
    this.images,
    this.tips,
  });

  factory TouristArea.fromJson(Map<String, dynamic> json) {
    return TouristArea(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      wilaya: json['wilaya'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      areaType: json['area_type'] as String?,
      coverImage: json['cover_image'] as String?,
      entryFee: json['entry_fee'] != null ? (json['entry_fee'] as num).toDouble() : null,
      openingHours: json['opening_hours'] as String?,
      bestVisitSeason: json['best_visit_season'] as String?,
      difficultyLevel: json['difficulty_level'] as String?,
      estimatedVisitDuration: json['estimated_visit_duration'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      features: json['tourist_area_features'] != null
          ? (json['tourist_area_features'] as List)
              .map((feature) => TouristAreaFeature.fromJson(feature))
              .toList()
          : null,
      images: json['tourist_area_images'] != null
          ? (json['tourist_area_images'] as List)
              .map((image) => TouristAreaImage.fromJson(image))
              .toList()
          : null,
      tips: json['tourist_area_tips'] != null
          ? (json['tourist_area_tips'] as List)
              .map((tip) => TouristAreaTip.fromJson(tip))
              .toList()
          : null,
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
      'latitude': latitude,
      'longitude': longitude,
      'area_type': areaType,
      'cover_image': coverImage,
      'entry_fee': entryFee,
      'opening_hours': openingHours,
      'best_visit_season': bestVisitSeason,
      'difficulty_level': difficultyLevel,
      'estimated_visit_duration': estimatedVisitDuration,
      'rating': rating,
      'total_reviews': totalReviews,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TouristArea copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? city,
    String? wilaya,
    double? latitude,
    double? longitude,
    String? areaType,
    String? coverImage,
    double? entryFee,
    String? openingHours,
    String? bestVisitSeason,
    String? difficultyLevel,
    String? estimatedVisitDuration,
    double? rating,
    int? totalReviews,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TouristAreaFeature>? features,
    List<TouristAreaImage>? images,
    List<TouristAreaTip>? tips,
  }) {
    return TouristArea(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      wilaya: wilaya ?? this.wilaya,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      areaType: areaType ?? this.areaType,
      coverImage: coverImage ?? this.coverImage,
      entryFee: entryFee ?? this.entryFee,
      openingHours: openingHours ?? this.openingHours,
      bestVisitSeason: bestVisitSeason ?? this.bestVisitSeason,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      estimatedVisitDuration: estimatedVisitDuration ?? this.estimatedVisitDuration,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      features: features ?? this.features,
      images: images ?? this.images,
      tips: tips ?? this.tips,
    );
  }
}

class TouristAreaFeature {
  final String id;
  final String areaId;
  final String featureName;
  final String? featureType;
  final bool isAvailable;
  final double? additionalCost;
  final String? description;
  final DateTime createdAt;

  const TouristAreaFeature({
    required this.id,
    required this.areaId,
    required this.featureName,
    this.featureType,
    this.isAvailable = true,
    this.additionalCost,
    this.description,
    required this.createdAt,
  });

  factory TouristAreaFeature.fromJson(Map<String, dynamic> json) {
    return TouristAreaFeature(
      id: json['id'] as String,
      areaId: json['area_id'] as String,
      featureName: json['feature_name'] as String,
      featureType: json['feature_type'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
      additionalCost: json['additional_cost'] != null ? (json['additional_cost'] as num).toDouble() : null,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'area_id': areaId,
      'feature_name': featureName,
      'feature_type': featureType,
      'is_available': isAvailable,
      'additional_cost': additionalCost,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TouristAreaImage {
  final String id;
  final String areaId;
  final String imageUrl;
  final String? altText;
  final String imageType;
  final int displayOrder;
  final DateTime createdAt;

  const TouristAreaImage({
    required this.id,
    required this.areaId,
    required this.imageUrl,
    this.altText,
    this.imageType = 'general',
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory TouristAreaImage.fromJson(Map<String, dynamic> json) {
    return TouristAreaImage(
      id: json['id'] as String,
      areaId: json['area_id'] as String,
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
      'area_id': areaId,
      'image_url': imageUrl,
      'alt_text': altText,
      'image_type': imageType,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TouristAreaTip {
  final String id;
  final String areaId;
  final String? tipTitle;
  final String tipContent;
  final String? tipType;
  final bool isActive;
  final DateTime createdAt;

  const TouristAreaTip({
    required this.id,
    required this.areaId,
    this.tipTitle,
    required this.tipContent,
    this.tipType,
    this.isActive = true,
    required this.createdAt,
  });

  factory TouristAreaTip.fromJson(Map<String, dynamic> json) {
    return TouristAreaTip(
      id: json['id'] as String,
      areaId: json['area_id'] as String,
      tipTitle: json['tip_title'] as String?,
      tipContent: json['tip_content'] as String,
      tipType: json['tip_type'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'area_id': areaId,
      'tip_title': tipTitle,
      'tip_content': tipContent,
      'tip_type': tipType,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TouristAreaReview {
  final String id;
  final String areaId;
  final String userId;
  final int rating;
  final String? reviewText;
  final DateTime? visitDate;
  final bool isVerified;
  final int helpfulCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TouristAreaReview({
    required this.id,
    required this.areaId,
    required this.userId,
    required this.rating,
    this.reviewText,
    this.visitDate,
    this.isVerified = false,
    this.helpfulCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TouristAreaReview.fromJson(Map<String, dynamic> json) {
    return TouristAreaReview(
      id: json['id'] as String,
      areaId: json['area_id'] as String,
      userId: json['user_id'] as String,
      rating: json['rating'] as int,
      reviewText: json['review_text'] as String?,
      visitDate: json['visit_date'] != null ? DateTime.parse(json['visit_date'] as String) : null,
      isVerified: json['is_verified'] as bool? ?? false,
      helpfulCount: json['helpful_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'area_id': areaId,
      'user_id': userId,
      'rating': rating,
      'review_text': reviewText,
      'visit_date': visitDate?.toIso8601String(),
      'is_verified': isVerified,
      'helpful_count': helpfulCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}