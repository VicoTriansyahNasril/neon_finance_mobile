class BadgeEntity {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isUnlocked;

  BadgeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });

  BadgeEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    bool? isUnlocked,
  }) {
    return BadgeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
