class QuestEntity {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final bool isCompleted;

  QuestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.isCompleted,
  });

  QuestEntity copyWith({
    String? id,
    String? title,
    String? description,
    int? xpReward,
    bool? isCompleted,
  }) {
    return QuestEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
