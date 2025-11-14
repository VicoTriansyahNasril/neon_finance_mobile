import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});

class DashboardState {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final double remainingBudget;
  final int level;
  final int xp;
  final int xpToNextLevel;
  final List<DailyTransaction> weeklyTransactions;
  final bool isLoading;

  DashboardState({
    this.totalBalance = 0,
    this.monthlyIncome = 0,
    this.monthlyExpense = 0,
    this.remainingBudget = 0,
    this.level = 1,
    this.xp = 0,
    this.xpToNextLevel = 100,
    this.weeklyTransactions = const [],
    this.isLoading = false,
  });

  DashboardState copyWith({
    double? totalBalance,
    double? monthlyIncome,
    double? monthlyExpense,
    double? remainingBudget,
    int? level,
    int? xp,
    int? xpToNextLevel,
    List<DailyTransaction>? weeklyTransactions,
    bool? isLoading,
  }) {
    return DashboardState(
      totalBalance: totalBalance ?? this.totalBalance,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpense: monthlyExpense ?? this.monthlyExpense,
      remainingBudget: remainingBudget ?? this.remainingBudget,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      weeklyTransactions: weeklyTransactions ?? this.weeklyTransactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DailyTransaction {
  final DateTime date;
  final double income;
  final double expense;

  DailyTransaction({
    required this.date,
    required this.income,
    required this.expense,
  });
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState()) {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true);

    final transactionsBox = Hive.box('transactions');
    final gamificationBox = Hive.box('gamification');
    final budgetBox = Hive.box('budget');

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    double income = 0;
    double expense = 0;
    final weeklyData = <DateTime, DailyTransaction>{};

    for (var i = 0; i < transactionsBox.length; i++) {
      final transaction = transactionsBox.getAt(i) as Map?;
      if (transaction == null) continue;

      final date = transaction['date'] as DateTime?;
      if (date == null) continue;

      final amount = (transaction['amount'] as num?)?.toDouble() ?? 0;
      final type = transaction['type'] as String?;

      if (date.isAfter(startOfMonth)) {
        if (type == 'income') {
          income += amount;
        } else if (type == 'expense') {
          expense += amount;
        }
      }

      final dayKey = DateTime(date.year, date.month, date.day);
      if (date.isAfter(now.subtract(const Duration(days: 7)))) {
        if (!weeklyData.containsKey(dayKey)) {
          weeklyData[dayKey] = DailyTransaction(
            date: dayKey,
            income: 0,
            expense: 0,
          );
        }
        if (type == 'income') {
          weeklyData[dayKey] = DailyTransaction(
            date: dayKey,
            income: weeklyData[dayKey]!.income + amount,
            expense: weeklyData[dayKey]!.expense,
          );
        } else if (type == 'expense') {
          weeklyData[dayKey] = DailyTransaction(
            date: dayKey,
            income: weeklyData[dayKey]!.income,
            expense: weeklyData[dayKey]!.expense + amount,
          );
        }
      }
    }

    final balance = income - expense;
    final level = gamificationBox.get('level', defaultValue: 1) as int;
    final xp = gamificationBox.get('xp', defaultValue: 0) as int;
    final xpToNext = _calculateXpToNextLevel(level);
    final monthlyBudget =
        (budgetBox.get('monthly_budget', defaultValue: 0) as num).toDouble();
    final remaining = monthlyBudget - expense;

    final sortedTransactions = weeklyData.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    state = state.copyWith(
      totalBalance: balance,
      monthlyIncome: income,
      monthlyExpense: expense,
      remainingBudget: remaining > 0 ? remaining : 0,
      level: level,
      xp: xp,
      xpToNextLevel: xpToNext,
      weeklyTransactions: sortedTransactions,
      isLoading: false,
    );
  }

  int _calculateXpToNextLevel(int level) {
    return level * 100;
  }

  void refresh() {
    loadDashboardData();
  }
}
