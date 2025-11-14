class TransactionEntity {
  final String id;
  final String type;
  final String category;
  final double amount;
  final DateTime date;
  final String description;

  TransactionEntity({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory TransactionEntity.fromMap(Map<dynamic, dynamic> map) {
    return TransactionEntity(
      id: map['id'] as String,
      type: map['type'] as String,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String,
    );
  }
}
