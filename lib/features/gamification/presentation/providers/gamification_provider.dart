import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/badge_entity.dart';
import '../../domain/entities/quest_entity.dart';

final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier();
});

class GamificationState {
  final List<BadgeEntity> badges;
  final List<QuestEntity> dailyQuests;
  final int level;
  final int xp;
  final int xpToNextLevel;
  final bool isLoading;

  GamificationState({
    this.badges = const [],
    this.dailyQuests = const [],
    this.level = 1,
    this.xp = 0,
    this.xpToNextLevel = 100,
    this.isLoading = false,
  });

  GamificationState copyWith({
    List<BadgeEntity>? badges,
    List<QuestEntity>? dailyQuests,
    int? level,
    int? xp,
    int? xpToNextLevel,
    bool? isLoading,
  }) {
    return GamificationState(
      badges: badges ?? this.badges,
      dailyQuests: dailyQuests ?? this.dailyQuests,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GamificationNotifier extends StateNotifier<GamificationState> {
  GamificationNotifier() : super(GamificationState()) {
    loadGamification();
  }

  final _uuid = const Uuid();

  Future<void> loadGamification() async {
    state = state.copyWith(isLoading: true);

    final box = Hive.box('gamification');

    final xp = box.get('xp', defaultValue: 0) as int;
    final level = (xp / 100).floor() + 1;
    final xpToNextLevel = (level * 100) - xp;

    final badges = _loadBadges(box);
    final quests = _loadQuests(box);

    state = state.copyWith(
      badges: badges,
      dailyQuests: quests,
      level: level,
      xp: xp,
      xpToNextLevel: xpToNextLevel,
      isLoading: false,
    );
  }

  List<BadgeEntity> _loadBadges(Box box) {
    final List<BadgeEntity> badges = [];
    final badgesData = box.get('badges', defaultValue: <dynamic>[]) as List;

    for (var data in badgesData) {
      if (data is Map) {
        badges.add(BadgeEntity.fromMap(data));
      }
    }

    if (badges.isEmpty) {
      badges.addAll(_initializeBadges());
      box.put('badges', badges.map((b) => b.toMap()).toList());
    }

    return badges;
  }

  List<QuestEntity> _loadQuests(Box box) {
    final List<QuestEntity> quests = [];
    final questsData = box.get('quests', defaultValue: <dynamic>[]) as List;

    for (var data in questsData) {
      if (data is Map) {
        quests.add(QuestEntity.fromMap(data));
      }
    }

    if (quests.isEmpty || _shouldResetQuests(box)) {
      quests.clear();
      quests.addAll(_generateDailyQuests());
      box.put('quests', quests.map((q) => q.toMap()).toList());
      box.put('lastQuestReset', DateTime.now().toIso8601String());
    }

    return quests;
  }

  bool _shouldResetQuests(Box box) {
    final lastReset = box.get('lastQuestReset') as String?;
    if (lastReset == null) return true;

    final lastResetDate = DateTime.parse(lastReset);
    final now = DateTime.now();

    return now.day != lastResetDate.day ||
        now.month != lastResetDate.month ||
        now.year != lastResetDate.year;
  }

  List<BadgeEntity> _initializeBadges() {
    return [
      BadgeEntity(
        id: _uuid.v4(),
        name: 'First Step',
        description: 'Add your first transaction',
        iconName: 'star',
      ),
      BadgeEntity(
        id: _uuid.v4(),
        name: 'Budget Master',
        description: 'Create your first budget',
        iconName: 'trending_up',
      ),
      BadgeEntity(
        id: _uuid.v4(),
        name: 'Goal Setter',
        description: 'Create your first goal',
        iconName: 'flag',
      ),
      BadgeEntity(
        id: _uuid.v4(),
        name: 'Consistent Tracker',
        description: 'Add transactions for 7 consecutive days',
        iconName: 'calendar_today',
      ),
      BadgeEntity(
        id: _uuid.v4(),
        name: 'Money Saver',
        description: 'Save more than you spend in a month',
        iconName: 'savings',
      ),
    ];
  }

  List<QuestEntity> _generateDailyQuests() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final endOfDay =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 0, 0);

    return [
      QuestEntity(
        id: _uuid.v4(),
        title: 'Track Your Spending',
        description: 'Add 3 transactions today',
        targetCount: 3,
        xpReward: 20,
        expiresAt: endOfDay,
      ),
      QuestEntity(
        id: _uuid.v4(),
        title: 'Budget Check',
        description: 'Review your budget progress',
        targetCount: 1,
        xpReward: 15,
        expiresAt: endOfDay,
      ),
      QuestEntity(
        id: _uuid.v4(),
        title: 'Goal Progress',
        description: 'Add progress to a goal',
        targetCount: 1,
        xpReward: 25,
        expiresAt: endOfDay,
      ),
    ];
  }

  Future<void> completeQuest(String questId) async {
    final box = Hive.box('gamification');
    final questsData = box.get('quests', defaultValue: <dynamic>[]) as List;

    for (var i = 0; i < questsData.length; i++) {
      final data = questsData[i] as Map;
      if (data['id'] == questId) {
        final quest = QuestEntity.fromMap(data);
        final updatedQuest = QuestEntity(
          id: quest.id,
          title: quest.title,
          description: quest.description,
          targetCount: quest.targetCount,
          currentCount: quest.targetCount,
          xpReward: quest.xpReward,
          expiresAt: quest.expiresAt,
          isCompleted: true,
        );
        questsData[i] = updatedQuest.toMap();

        final currentXp = box.get('xp', defaultValue: 0) as int;
        await box.put('xp', currentXp + quest.xpReward);
        break;
      }
    }

    await box.put('quests', questsData);
    await loadGamification();
  }

  Future<void> unlockBadge(String badgeId) async {
    final box = Hive.box('gamification');
    final badgesData = box.get('badges', defaultValue: <dynamic>[]) as List;

    for (var i = 0; i < badgesData.length; i++) {
      final data = badgesData[i] as Map;
      if (data['id'] == badgeId) {
        final badge = BadgeEntity.fromMap(data);
        final updatedBadge = BadgeEntity(
          id: badge.id,
          name: badge.name,
          description: badge.description,
          iconName: badge.iconName,
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
        badgesData[i] = updatedBadge.toMap();
        break;
      }
    }

    await box.put('badges', badgesData);
    await loadGamification();
  }
}
