enum FavoriteType {
  restaurant,
  hotel,
}

class Favorite {
  final String id;
  final String userId;
  final FavoriteType itemType;
  final String itemId;
  final DateTime createdAt;

  const Favorite({
    required this.id,
    required this.userId,
    required this.itemType,
    required this.itemId,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      itemType: FavoriteType.values.firstWhere(
        (type) => type.name == json['entity_type'] as String,
      ),
      itemId: json['entity_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'entity_type': itemType.name,
      'entity_id': itemId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'entity_type': itemType.name,
      'entity_id': itemId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favorite &&
        other.id == id &&
        other.userId == userId &&
        other.itemType == itemType &&
        other.itemId == itemId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ itemType.hashCode ^ itemId.hashCode;
  }

  @override
  String toString() {
    return 'Favorite(id: $id, userId: $userId, itemType: $itemType, itemId: $itemId, createdAt: $createdAt)';
  }
}