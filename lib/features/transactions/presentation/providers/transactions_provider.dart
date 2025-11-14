import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/transaction_entity.dart';

final transactionsProvider = StateNotifierProvider<TransactionsNotifier,
    AsyncValue<List<TransactionEntity>>>(
  (ref) => TransactionsNotifier(),
);

class TransactionsNotifier
    extends StateNotifier<AsyncValue<List<TransactionEntity>>> {
  final _box = Hive.box('transactions');

  TransactionsNotifier() : super(const AsyncValue.loading()) {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final transactions = <TransactionEntity>[];
      for (var key in _box.keys) {
        final data = _box.get(key) as Map;
        transactions.add(TransactionEntity.fromMap(data));
      }
      transactions.sort((a, b) => b.date.compareTo(a.date));
      state = AsyncValue.data(transactions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      await _box.put(transaction.id, transaction.toMap());
      await _loadTransactions();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTransaction(TransactionEntity transaction) async {
    try {
      await _box.put(transaction.id, transaction.toMap());
      await _loadTransactions();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _box.delete(id);
      await _loadTransactions();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  List<TransactionEntity> getTransactionsByMonth(DateTime month) {
    return state.maybeWhen(
      data: (transactions) => transactions.where((t) {
        return t.date.year == month.year && t.date.month == month.month;
      }).toList(),
      orElse: () => [],
    );
  }

  double getTotalIncome(DateTime month) {
    return state.maybeWhen(
      data: (transactions) => transactions.where((t) {
        return t.type == 'income' &&
            t.date.year == month.year &&
            t.date.month == month.month;
      }).fold(0.0, (sum, t) => sum + t.amount),
      orElse: () => 0.0,
    );
  }

  double getTotalExpense(DateTime month) {
    return state.maybeWhen(
      data: (transactions) => transactions.where((t) {
        return t.type == 'expense' &&
            t.date.year == month.year &&
            t.date.month == month.month;
      }).fold(0.0, (sum, t) => sum + t.amount),
      orElse: () => 0.0,
    );
  }
}
