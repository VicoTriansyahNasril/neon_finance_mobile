import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/budget_entity.dart';
import '../../../../core/services/notification_service.dart';
import '../../../transactions/presentation/providers/transactions_provider.dart';

final budgetProvider =
    StateNotifierProvider<BudgetNotifier, List<BudgetEntity>>(
  (ref) => BudgetNotifier(ref),
);

class BudgetNotifier extends StateNotifier<List<BudgetEntity>> {
  final Ref ref;
  final _box = Hive.box('budget');

  BudgetNotifier(this.ref) : super([]) {
    _loadBudgets();
  }

  void _loadBudgets() {
    final budgets = <BudgetEntity>[];
    for (var key in _box.keys) {
      final data = _box.get(key) as Map;
      budgets.add(BudgetEntity.fromJson(Map<String, dynamic>.from(data)));
    }
    state = budgets;
  }

  Future<void> addBudget(BudgetEntity budget) async {
    await _box.put(budget.id, budget.toJson());
    state = [...state, budget];
  }

  Future<void> updateBudget(BudgetEntity budget) async {
    await _box.put(budget.id, budget.toJson());
    state = [
      for (final b in state)
        if (b.id == budget.id) budget else b,
    ];
  }

  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
    state = state.where((b) => b.id != id).toList();
  }

  Future<void> checkBudgetAlerts() async {
    final transactionsAsync = ref.read(transactionsProvider);

    transactionsAsync.whenData((transactions) async {
      final now = DateTime.now();

      for (final budget in state) {
        final spent = transactions
            .where((t) =>
                t.type == 'expense' &&
                t.category == budget.category &&
                t.date.month == now.month &&
                t.date.year == now.year)
            .fold(0.0, (sum, t) => sum + t.amount);

        final percentage = (spent / budget.limit) * 100;

        if (percentage >= 90 && percentage < 100) {
          await NotificationService().showNotification(
            id: budget.id.hashCode,
            title: 'Peringatan Anggaran',
            body:
                'Anggaran ${budget.category} hampir habis! ${percentage.toStringAsFixed(0)}% terpakai.',
          );
        } else if (percentage >= 100) {
          await NotificationService().showNotification(
            id: budget.id.hashCode + 1,
            title: 'Anggaran Terlampaui!',
            body:
                'Anggaran ${budget.category} sudah terlampaui ${(percentage - 100).toStringAsFixed(0)}%!',
          );
        }
      }
    });
  }
}
