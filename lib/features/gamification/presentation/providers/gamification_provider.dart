import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/badge_entity.dart';
import '../../domain/entities/quest_entity.dart';

final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, GamificationState>(
  (ref) => GamificationNotifier(),
);

class GamificationState {
  final int xp;
  final int level;
  final List<BadgeEntity> badges;
  final List<QuestEntity> quests;

  GamificationState({
    required this.xp,
    required this.level,
    required this.badges,
    required this.quests,
  });

  GamificationState copyWith({
    int? xp,
    int? level,
    List<BadgeEntity>? badges,
    List<QuestEntity>? quests,
  }) {
    return GamificationState(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      quests: quests ?? this.quests,
    );
  }
}

class GamificationNotifier extends StateNotifier<GamificationState> {
  final _box = Hive.box('gamification');

  GamificationNotifier()
      : super(GamificationState(
          xp: 0,
          level: 1,
          badges: [],
          quests: [],
        )) {
    _loadData();
  }

  void _loadData() {
    final xp = _box.get('xp', defaultValue: 0) as int;
    final level = _box.get('level', defaultValue: 1) as int;

    state = state.copyWith(
      xp: xp,
      level: level,
      badges: _getDefaultBadges(),
      quests: _getDefaultQuests(),
    );
  }

  Future<void> earnXP(int amount) async {
    final newXP = state.xp + amount;
    final newLevel = _calculateLevel(newXP);

    await _box.put('xp', newXP);
    await _box.put('level', newLevel);

    state = state.copyWith(
      xp: newXP,
      level: newLevel,
    );

    _checkBadges();
    _checkQuests();
  }

  int _calculateLevel(int xp) {
    return (xp / 100).floor() + 1;
  }

  void _checkBadges() {
    final updatedBadges = state.badges.map((badge) {
      if (!badge.isUnlocked) {
        if (badge.id == 'first_transaction' && state.xp >= 10) {
          return badge.copyWith(isUnlocked: true);
        } else if (badge.id == 'spending_master' && state.xp >= 100) {
          return badge.copyWith(isUnlocked: true);
        } else if (badge.id == 'budget_keeper' && state.xp >= 500) {
          return badge.copyWith(isUnlocked: true);
        }
      }
      return badge;
    }).toList();

    state = state.copyWith(badges: updatedBadges);
  }

  void _checkQuests() {
    final updatedQuests = state.quests.map((quest) {
      if (!quest.isCompleted && state.xp >= quest.xpReward) {
        return quest.copyWith(isCompleted: true);
      }
      return quest;
    }).toList();

    state = state.copyWith(quests: updatedQuests);
  }

  List<BadgeEntity> _getDefaultBadges() {
    return [
      BadgeEntity(
        id: 'first_transaction',
        name: 'First Step',
        description: 'Add your first transaction',
        icon: 'star',
        isUnlocked: state.xp >= 10,
      ),
      BadgeEntity(
        id: 'spending_master',
        name: 'Spending Master',
        description: 'Track 10 transactions',
        icon: 'trending_up',
        isUnlocked: state.xp >= 100,
      ),
      BadgeEntity(
        id: 'budget_keeper',
        name: 'Budget Keeper',
        description: 'Set your first budget',
        icon: 'savings',
        isUnlocked: state.xp >= 500,
      ),
    ];
  }

  List<QuestEntity> _getDefaultQuests() {
    return [
      QuestEntity(
        id: 'daily_tracker',
        title: 'Daily Tracker',
        description: 'Add 3 transactions today',
        xpReward: 30,
        isCompleted: false,
      ),
      QuestEntity(
        id: 'budget_setter',
        title: 'Budget Setter',
        description: 'Set a monthly budget',
        xpReward: 50,
        isCompleted: false,
      ),
    ];
  }
}
