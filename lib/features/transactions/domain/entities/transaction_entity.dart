class TransactionEntity {
  final String id;
  final String type;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final String? walletId;

  TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    this.walletId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
      'walletId': walletId,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }

  factory TransactionEntity.fromJson(Map<String, dynamic> json) {
    return TransactionEntity(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      walletId: json['walletId'] as String?,
    );
  }

  factory TransactionEntity.fromMap(Map<dynamic, dynamic> map) {
    return TransactionEntity(
      id: map['id'] as String,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      description: map['description'] as String? ?? '',
      date: DateTime.parse(map['date'] as String),
      walletId: map['walletId'] as String?,
    );
  }

  TransactionEntity copyWith({
    String? id,
    String? type,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    String? walletId,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      walletId: walletId ?? this.walletId,
    );
  }
}
