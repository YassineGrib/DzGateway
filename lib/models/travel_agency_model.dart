class TravelAgency {
  final String id;
  final String name;
  final String? phone;
  final String? description;
  final String? coverImage;
  final String? priceRange;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final String? ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TravelOffer>? offers;
  final List<Destination>? destinations;
  final List<TravelAgencyImage>? images;

  TravelAgency({
    required this.id,
    required this.name,
    this.phone,
    this.description,
    this.coverImage,
    this.priceRange,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isActive = true,
    this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.offers,
    this.destinations,
    this.images,
  });

  factory TravelAgency.fromJson(Map<String, dynamic> json) {
    return TravelAgency(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      coverImage: json['cover_image'] as String?,
      priceRange: json['price_range'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      ownerId: json['owner_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      offers: json['travel_offers'] != null
          ? (json['travel_offers'] as List)
              .map((offer) => TravelOffer.fromJson(offer))
              .toList()
          : null,
      destinations: json['destinations'] != null
          ? (json['destinations'] as List)
              .map((dest) => Destination.fromJson(dest))
              .toList()
          : null,
      images: json['travel_agency_images'] != null
          ? (json['travel_agency_images'] as List)
              .map((image) => TravelAgencyImage.fromJson(image))
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
      'price_range': priceRange,
      'rating': rating,
      'total_reviews': totalReviews,
      'is_active': isActive,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TravelAgency copyWith({
    String? id,
    String? name,
    String? phone,
    String? description,
    String? coverImage,
    String? priceRange,
    double? rating,
    int? totalReviews,
    bool? isActive,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TravelOffer>? offers,
    List<Destination>? destinations,
    List<TravelAgencyImage>? images,
  }) {
    return TravelAgency(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isActive: isActive ?? this.isActive,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      offers: offers ?? this.offers,
      destinations: destinations ?? this.destinations,
      images: images ?? this.images,
    );
  }

  String get formattedRating => rating.toStringAsFixed(1);
  String get displayPriceRange => priceRange ?? 'غير محدد';
  bool get hasCoverImage => coverImage != null && coverImage!.isNotEmpty;
  int get availableOffersCount => offers?.where((offer) => offer.isAvailable).length ?? 0;
  int get destinationsCount => destinations?.length ?? 0;
}

class TravelOffer {
  final String id;
  final String agencyId;
  final String title;
  final String? description;
  final double? price;
  final int? durationDays;
  final String? offerType;
  final String? image;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  TravelOffer({
    required this.id,
    required this.agencyId,
    required this.title,
    this.description,
    this.price,
    this.durationDays,
    this.offerType,
    this.image,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TravelOffer.fromJson(Map<String, dynamic> json) {
    return TravelOffer(
      id: json['id'] as String,
      agencyId: json['agency_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      durationDays: json['duration_days'] as int?,
      offerType: json['offer_type'] as String?,
      image: json['image'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agency_id': agencyId,
      'title': title,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'offer_type': offerType,
      'image': image,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get formattedPrice => price != null ? '${price!.toStringAsFixed(0)} دج' : 'السعر عند الاستفسار';
  String get formattedDuration => durationDays != null ? '$durationDays أيام' : 'غير محدد';
  String get displayOfferType => offerType ?? 'رحلة';
}

class Destination {
  final String id;
  final String agencyId;
  final String name;
  final String? country;
  final String? city;
  final String destinationType; // 'domestic' or 'international'
  final String? description;
  final String? image;
  final DateTime createdAt;

  Destination({
    required this.id,
    required this.agencyId,
    required this.name,
    this.country,
    this.city,
    required this.destinationType,
    this.description,
    this.image,
    required this.createdAt,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      agencyId: json['agency_id'] as String,
      name: json['name'] as String,
      country: json['country'] as String?,
      city: json['city'] as String?,
      destinationType: json['destination_type'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agency_id': agencyId,
      'name': name,
      'country': country,
      'city': city,
      'destination_type': destinationType,
      'description': description,
      'image': image,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get displayLocation {
    if (city != null && country != null) {
      return '$city, $country';
    } else if (country != null) {
      return country!;
    } else {
      return name;
    }
  }

  String get displayType => destinationType == 'domestic' ? 'داخلية' : 'خارجية';
  bool get isDomestic => destinationType == 'domestic';
  bool get isInternational => destinationType == 'international';
}

class TravelAgencyImage {
  final String id;
  final String agencyId;
  final String imageUrl;
  final String? altText;
  final int displayOrder;
  final DateTime createdAt;

  TravelAgencyImage({
    required this.id,
    required this.agencyId,
    required this.imageUrl,
    this.altText,
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory TravelAgencyImage.fromJson(Map<String, dynamic> json) {
    return TravelAgencyImage(
      id: json['id'] as String,
      agencyId: json['agency_id'] as String,
      imageUrl: json['image_url'] as String,
      altText: json['alt_text'] as String?,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agency_id': agencyId,
      'image_url': imageUrl,
      'alt_text': altText,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }
}