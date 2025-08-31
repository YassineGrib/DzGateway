class TransportCompany {
  final String id;
  final String name;
  final String? phone;
  final String? transportType; // 'public' or 'private'
  final String? description;
  final String? coverImage;
  final String? priceRange;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final String? ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TransportRoute>? routes;
  final List<TransportCompanyImage>? images;

  TransportCompany({
    required this.id,
    required this.name,
    this.phone,
    this.transportType,
    this.description,
    this.coverImage,
    this.priceRange,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isActive = true,
    this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.routes,
    this.images,
  });

  factory TransportCompany.fromJson(Map<String, dynamic> json) {
    return TransportCompany(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      transportType: json['transport_type'] as String?,
      description: json['description'] as String?,
      coverImage: json['cover_image'] as String?,
      priceRange: json['price_range'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      ownerId: json['owner_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      routes: json['routes'] != null
          ? (json['routes'] as List)
              .map((route) => TransportRoute.fromJson(route))
              .toList()
          : null,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((image) => TransportCompanyImage.fromJson(image))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'transport_type': transportType,
      'description': description,
      'cover_image': coverImage,
      'price_range': priceRange,
      'rating': rating,
      'total_reviews': totalReviews,
      'is_active': isActive,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (routes != null) 'routes': routes!.map((route) => route.toJson()).toList(),
      if (images != null) 'images': images!.map((image) => image.toJson()).toList(),
    };
  }

  TransportCompany copyWith({
    String? id,
    String? name,
    String? phone,
    String? transportType,
    String? description,
    String? coverImage,
    String? priceRange,
    double? rating,
    int? totalReviews,
    bool? isActive,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TransportRoute>? routes,
    List<TransportCompanyImage>? images,
  }) {
    return TransportCompany(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      transportType: transportType ?? this.transportType,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isActive: isActive ?? this.isActive,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      routes: routes ?? this.routes,
      images: images ?? this.images,
    );
  }
}

class TransportRoute {
  final String id;
  final String companyId;
  final String routeName;
  final String origin;
  final String destination;
  final double? distanceKm;
  final int? estimatedDurationMinutes;
  final double? price;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TransportSchedule>? schedules;

  TransportRoute({
    required this.id,
    required this.companyId,
    required this.routeName,
    required this.origin,
    required this.destination,
    this.distanceKm,
    this.estimatedDurationMinutes,
    this.price,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.schedules,
  });

  factory TransportRoute.fromJson(Map<String, dynamic> json) {
    return TransportRoute(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      routeName: json['route_name'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      estimatedDurationMinutes: json['estimated_duration_minutes'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      schedules: json['schedules'] != null
          ? (json['schedules'] as List)
              .map((schedule) => TransportSchedule.fromJson(schedule))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'route_name': routeName,
      'origin': origin,
      'destination': destination,
      'distance_km': distanceKm,
      'estimated_duration_minutes': estimatedDurationMinutes,
      'price': price,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (schedules != null) 'schedules': schedules!.map((schedule) => schedule.toJson()).toList(),
    };
  }
}

class TransportSchedule {
  final String id;
  final String routeId;
  final String departureTime; // TIME format as string
  final String? arrivalTime;
  final List<int> daysOfWeek; // 1=Monday, 7=Sunday
  final bool isActive;
  final DateTime createdAt;

  TransportSchedule({
    required this.id,
    required this.routeId,
    required this.departureTime,
    this.arrivalTime,
    this.daysOfWeek = const [1, 2, 3, 4, 5, 6, 7],
    this.isActive = true,
    required this.createdAt,
  });

  factory TransportSchedule.fromJson(Map<String, dynamic> json) {
    return TransportSchedule(
      id: json['id'] as String,
      routeId: json['route_id'] as String,
      departureTime: json['departure_time'] as String,
      arrivalTime: json['arrival_time'] as String?,
      daysOfWeek: json['days_of_week'] != null
          ? List<int>.from(json['days_of_week'])
          : [1, 2, 3, 4, 5, 6, 7],
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'route_id': routeId,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'days_of_week': daysOfWeek,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TransportCompanyImage {
  final String id;
  final String companyId;
  final String imageUrl;
  final String? altText;
  final int displayOrder;
  final DateTime createdAt;

  TransportCompanyImage({
    required this.id,
    required this.companyId,
    required this.imageUrl,
    this.altText,
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory TransportCompanyImage.fromJson(Map<String, dynamic> json) {
    return TransportCompanyImage(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      imageUrl: json['image_url'] as String,
      altText: json['alt_text'] as String?,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'image_url': imageUrl,
      'alt_text': altText,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// Enum for transport types
enum TransportType {
  public,
  private;

  String get value {
    switch (this) {
      case TransportType.public:
        return 'public';
      case TransportType.private:
        return 'private';
    }
  }

  static TransportType? fromString(String? value) {
    switch (value) {
      case 'public':
        return TransportType.public;
      case 'private':
        return TransportType.private;
      default:
        return null;
    }
  }

  String get displayName {
    switch (this) {
      case TransportType.public:
        return 'عام';
      case TransportType.private:
        return 'خاص';
    }
  }
}