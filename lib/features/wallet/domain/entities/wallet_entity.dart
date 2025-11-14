class WalletEntity {
  final String id;
  final String name;
  final String type;
  final double balance;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'balance': balance,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory WalletEntity.fromJson(Map<String, dynamic> json) {
    return WalletEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      balance: (json['balance'] as num).toDouble(),
      icon: json['icon'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  WalletEntity copyWith({
    String? id,
    String? name,
    String? type,
    double? balance,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
