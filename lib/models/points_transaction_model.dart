enum TransactionType { earned, spent }

class PointsTransaction {
  final String id;
  final String userId;
  final int amount;
  final String description;
  final TransactionType type;
  final DateTime timestamp;
  final String? relatedId; // e.g., project ID or reward ID

  const PointsTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.type,
    required this.timestamp,
    this.relatedId,
  });

  factory PointsTransaction.fromMap(Map<String, dynamic> map, String id) {
    return PointsTransaction(
      id: id,
      userId: map['userId'] ?? '',
      amount: map['amount'] ?? 0,
      description: map['description'] ?? '',
      type: map['type'] == 'earned' ? TransactionType.earned : TransactionType.spent,
      timestamp: map['timestamp'] != null 
        ? (map['timestamp'] as dynamic).toDate() 
        : DateTime.now(),
      relatedId: map['relatedId'],
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'amount': amount,
    'description': description,
    'type': type == TransactionType.earned ? 'earned' : 'spent',
    'timestamp': timestamp,
    'relatedId': relatedId,
  };
}
