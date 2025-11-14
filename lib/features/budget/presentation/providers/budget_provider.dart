import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/budget_entity.dart';

final budgetProvider =
    StateNotifierProvider<BudgetNotifier, BudgetState>((ref) {
  return BudgetNotifier();
});

class BudgetState {
  final List<BudgetEntity> budgets;
  final double monthlyBudget;
  final bool isLoading;

  BudgetState({
    this.budgets = const [],
    this.monthlyBudget = 0,
    this.isLoading = false,
  });

  BudgetState copyWith({
    List<BudgetEntity>? budgets,
    double? monthlyBudget,
    bool? isLoading,
  }) {
    return BudgetState(
      budgets: budgets ?? this.budgets,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BudgetNotifier extends StateNotifier<BudgetState> {
  BudgetNotifier() : super(BudgetState()) {
    loadBudgets();
  }

  final _uuid = const Uuid();

  Future<void> loadBudgets() async {
    state = state.copyWith(isLoading: true);

    final box = Hive.box('budget');
    final List<BudgetEntity> budgets = [];

    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i);
      if (data != null && data is Map) {
        budgets.add(BudgetEntity.fromMap(data));
      }
    }

    final monthlyBudget =
        (box.get('monthly_budget', defaultValue: 0) as num).toDouble();

    state = state.copyWith(
      budgets: budgets,
      monthlyBudget: monthlyBudget,
      isLoading: false,
    );
  }

  Future<void> addBudget(String category, double limit) async {
    final box = Hive.box('budget');

    final budget = BudgetEntity(
      id: _uuid.v4(),
      category: category,
      limit: limit,
      spent: 0,
    );

    await box.add(budget.toMap());
    await loadBudgets();
  }

  Future<void> setMonthlyBudget(double amount) async {
    final box = Hive.box('budget');
    await box.put('monthly_budget', amount);
    await loadBudgets();
  }

  Future<void> deleteBudget(String id) async {
    final box = Hive.box('budget');

    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i) as Map?;
      if (data != null && data['id'] == id) {
        await box.deleteAt(i);
        break;
      }
    }

    await loadBudgets();
  }
}
