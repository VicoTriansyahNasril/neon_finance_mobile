import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/goal_entity.dart';

final goalsProvider = StateNotifierProvider<GoalsNotifier, GoalsState>((ref) {
  return GoalsNotifier();
});

class GoalsState {
  final List<GoalEntity> goals;
  final bool isLoading;

  GoalsState({
    this.goals = const [],
    this.isLoading = false,
  });

  GoalsState copyWith({
    List<GoalEntity>? goals,
    bool? isLoading,
  }) {
    return GoalsState(
      goals: goals ?? this.goals,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GoalsNotifier extends StateNotifier<GoalsState> {
  GoalsNotifier() : super(GoalsState()) {
    loadGoals();
  }

  final _uuid = const Uuid();

  Future<void> loadGoals() async {
    state = state.copyWith(isLoading: true);

    final box = Hive.box('goals');
    final List<GoalEntity> goals = [];

    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i);
      if (data != null && data is Map) {
        goals.add(GoalEntity.fromMap(data));
      }
    }

    goals.sort((a, b) => a.deadline.compareTo(b.deadline));

    state = state.copyWith(
      goals: goals,
      isLoading: false,
    );
  }

  Future<void> addGoal({
    required String name,
    required double targetAmount,
    required DateTime deadline,
    required String category,
  }) async {
    final box = Hive.box('goals');

    final goal = GoalEntity(
      id: _uuid.v4(),
      name: name,
      targetAmount: targetAmount,
      currentAmount: 0,
      deadline: deadline,
      category: category,
    );

    await box.add(goal.toMap());
    await loadGoals();
  }

  Future<void> addProgress(String id, double amount) async {
    final box = Hive.box('goals');

    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i) as Map?;
      if (data != null && data['id'] == id) {
        final goal = GoalEntity.fromMap(data);
        final updatedGoal = GoalEntity(
          id: goal.id,
          name: goal.name,
          targetAmount: goal.targetAmount,
          currentAmount: goal.currentAmount + amount,
          deadline: goal.deadline,
          category: goal.category,
        );
        await box.putAt(i, updatedGoal.toMap());
        break;
      }
    }

    await loadGoals();
  }

  Future<void> deleteGoal(String id) async {
    final box = Hive.box('goals');

    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i) as Map?;
      if (data != null && data['id'] == id) {
        await box.deleteAt(i);
        break;
      }
    }

    await loadGoals();
  }
}
