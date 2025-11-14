class BudgetEntity {
  final String id;
  final String category;
  final double limit;
  final DateTime month;

  BudgetEntity({
    required this.id,
    required this.category,
    required this.limit,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'limit': limit,
      'month': month.toIso8601String(),
    };
  }

  factory BudgetEntity.fromJson(Map<String, dynamic> json) {
    return BudgetEntity(
      id: json['id'] as String,
      category: json['category'] as String,
      limit: (json['limit'] as num).toDouble(),
      month: DateTime.parse(json['month'] as String),
    );
  }

  BudgetEntity copyWith({
    String? id,
    String? category,
    double? limit,
    DateTime? month,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      month: month ?? this.month,
    );
  }
}
