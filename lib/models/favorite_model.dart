class Favorite {
  final String id;
  final String userId;
  final String restaurantId;
  final DateTime createdAt;

  const Favorite({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      restaurantId: json['restaurant_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_id': restaurantId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'restaurant_id': restaurantId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favorite &&
        other.id == id &&
        other.userId == userId &&
        other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ restaurantId.hashCode;
  }

  @override
  String toString() {
    return 'Favorite(id: $id, userId: $userId, restaurantId: $restaurantId, createdAt: $createdAt)';
  }
}