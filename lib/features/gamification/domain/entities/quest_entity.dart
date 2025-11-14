class QuestEntity {
  final String id;
  final String title;
  final String description;
  final int targetCount;
  final int currentCount;
  final int xpReward;
  final DateTime expiresAt;
  final bool isCompleted;

  QuestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCount,
    this.currentCount = 0,
    required this.xpReward,
    required this.expiresAt,
    this.isCompleted = false,
  });

  double get progress =>
      targetCount > 0 ? (currentCount / targetCount) * 100 : 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'xpReward': xpReward,
      'expiresAt': expiresAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory QuestEntity.fromMap(Map<dynamic, dynamic> map) {
    return QuestEntity(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      targetCount: map['targetCount'] as int,
      currentCount: map['currentCount'] as int? ?? 0,
      xpReward: map['xpReward'] as int,
      expiresAt: DateTime.parse(map['expiresAt'] as String),
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }
}
