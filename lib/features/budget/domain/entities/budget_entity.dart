class BudgetEntity {
  final String id;
  final String category;
  final double limit;
  final double spent;

  BudgetEntity({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
  });

  double get percentage => limit > 0 ? (spent / limit) * 100 : 0;
  double get remaining => limit - spent;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'limit': limit,
      'spent': spent,
    };
  }

  factory BudgetEntity.fromMap(Map<dynamic, dynamic> map) {
    return BudgetEntity(
      id: map['id'] as String,
      category: map['category'] as String,
      limit: (map['limit'] as num).toDouble(),
      spent: (map['spent'] as num).toDouble(),
    );
  }
}
