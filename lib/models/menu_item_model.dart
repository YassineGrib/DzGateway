class MenuItem {
  final String id;
  final String restaurantId;
  final String name;
  final String? description;
  final double price;
  final String? category;
  final String? image;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    this.description,
    required this.price,
    this.category,
    this.image,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String?,
      image: json['image'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
      'is_available': isAvailable,
    };
  }

  MenuItem copyWith({
    String? id,
    String? restaurantId,
    String? name,
    String? description,
    double? price,
    String? category,
    String? image,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItem &&
        other.id == id &&
        other.restaurantId == restaurantId &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.category == category &&
        other.image == image &&
        other.isAvailable == isAvailable &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      restaurantId,
      name,
      description,
      price,
      category,
      image,
      isAvailable,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'MenuItem(id: $id, restaurantId: $restaurantId, name: $name, description: $description, price: $price, category: $category, image: $image, isAvailable: $isAvailable, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // Helper method to format price
  String get formattedPrice {
    return '${price.toStringAsFixed(2)} دج';
  }

  // Helper method to check if item has image
  bool get hasImage => image != null && image!.isNotEmpty;

  // Helper method to get display category
  String get displayCategory => category ?? 'غير محدد';
}