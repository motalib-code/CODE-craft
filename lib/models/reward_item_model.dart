enum RewardCategory { swag, digital, career, lifestyle }

class RewardItem {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int pointsPrice;
  final double? moneyPrice; // Optional if item can be bought with money
  final RewardCategory category;
  final bool isAvailable;
  final String? imageUrl;

  const RewardItem({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.pointsPrice,
    this.moneyPrice,
    required this.category,
    this.isAvailable = true,
    this.imageUrl,
  });

  factory RewardItem.fromMap(Map<String, dynamic> map, String id) {
    return RewardItem(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      emoji: map['emoji'] ?? '🎁',
      pointsPrice: map['pointsPrice'] ?? 0,
      moneyPrice: map['moneyPrice']?.toDouble(),
      category: RewardCategory.values.firstWhere(
        (e) => e.toString().split('.').last == map['category'],
        orElse: () => RewardCategory.swag,
      ),
      isAvailable: map['isAvailable'] ?? true,
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'emoji': emoji,
    'pointsPrice': pointsPrice,
    'moneyPrice': moneyPrice,
    'category': category.toString().split('.').last,
    'isAvailable': isAvailable,
    'imageUrl': imageUrl,
  };
}
