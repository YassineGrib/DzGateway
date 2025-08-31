class DeliveryCompany {
  final String id;
  final String name;
  final String? phone;
  final String? description;
  final String? coverImage;
  final String? deliveryTime;
  final String? priceRange;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final String? ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<DeliveryCoverageArea>? coverageAreas;
  final List<DeliveryPaymentMethod>? paymentMethods;
  final List<DeliveryCompanyImage>? images;

  DeliveryCompany({
    required this.id,
    required this.name,
    this.phone,
    this.description,
    this.coverImage,
    this.deliveryTime,
    this.priceRange,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isActive = true,
    this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.coverageAreas,
    this.paymentMethods,
    this.images,
  });

  factory DeliveryCompany.fromJson(Map<String, dynamic> json) {
    return DeliveryCompany(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      description: json['description'],
      coverImage: json['cover_image'],
      deliveryTime: json['delivery_time'],
      priceRange: json['price_range'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      isActive: json['is_active'] ?? true,
      ownerId: json['owner_id'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      coverageAreas: json['coverage_areas'] != null
          ? (json['coverage_areas'] as List)
              .map((area) => DeliveryCoverageArea.fromJson(area))
              .toList()
          : null,
      paymentMethods: json['payment_methods'] != null
          ? (json['payment_methods'] as List)
              .map((method) => DeliveryPaymentMethod.fromJson(method))
              .toList()
          : null,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((image) => DeliveryCompanyImage.fromJson(image))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'description': description,
      'cover_image': coverImage,
      'delivery_time': deliveryTime,
      'price_range': priceRange,
      'rating': rating,
      'total_reviews': totalReviews,
      'is_active': isActive,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class DeliveryCoverageArea {
  final String id;
  final String companyId;
  final String areaName;
  final String? city;
  final String? wilaya;
  final String? postalCode;
  final double? deliveryFee;
  final bool isActive;
  final DateTime createdAt;

  DeliveryCoverageArea({
    required this.id,
    required this.companyId,
    required this.areaName,
    this.city,
    this.wilaya,
    this.postalCode,
    this.deliveryFee,
    this.isActive = true,
    required this.createdAt,
  });

  factory DeliveryCoverageArea.fromJson(Map<String, dynamic> json) {
    return DeliveryCoverageArea(
      id: json['id'] ?? '',
      companyId: json['company_id'] ?? '',
      areaName: json['area_name'] ?? '',
      city: json['city'],
      wilaya: json['wilaya'],
      postalCode: json['postal_code'],
      deliveryFee: json['delivery_fee']?.toDouble(),
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'area_name': areaName,
      'city': city,
      'wilaya': wilaya,
      'postal_code': postalCode,
      'delivery_fee': deliveryFee,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class DeliveryPaymentMethod {
  final String id;
  final String companyId;
  final String methodName;
  final String? methodType;
  final bool isActive;
  final DateTime createdAt;

  DeliveryPaymentMethod({
    required this.id,
    required this.companyId,
    required this.methodName,
    this.methodType,
    this.isActive = true,
    required this.createdAt,
  });

  factory DeliveryPaymentMethod.fromJson(Map<String, dynamic> json) {
    return DeliveryPaymentMethod(
      id: json['id'] ?? '',
      companyId: json['company_id'] ?? '',
      methodName: json['method_name'] ?? '',
      methodType: json['method_type'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'method_name': methodName,
      'method_type': methodType,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class DeliveryCompanyImage {
  final String id;
  final String companyId;
  final String imageUrl;
  final String? altText;
  final int displayOrder;
  final DateTime createdAt;

  DeliveryCompanyImage({
    required this.id,
    required this.companyId,
    required this.imageUrl,
    this.altText,
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory DeliveryCompanyImage.fromJson(Map<String, dynamic> json) {
    return DeliveryCompanyImage(
      id: json['id'] ?? '',
      companyId: json['company_id'] ?? '',
      imageUrl: json['image_url'] ?? '',
      altText: json['alt_text'],
      displayOrder: json['display_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
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