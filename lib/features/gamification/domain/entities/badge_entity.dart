class BadgeEntity {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  BadgeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory BadgeEntity.fromMap(Map<dynamic, dynamic> map) {
    return BadgeEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      iconName: map['iconName'] as String,
      isUnlocked: map['isUnlocked'] as bool? ?? false,
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.parse(map['unlockedAt'] as String)
          : null,
    );
  }
}
