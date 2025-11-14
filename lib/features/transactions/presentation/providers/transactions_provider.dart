import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/transaction_entity.dart';

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, TransactionsState>((ref) {
  return TransactionsNotifier();
});

class TransactionsState {
  final List<TransactionEntity> transactions;
  final bool isLoading;
  final String? error;

  TransactionsState({
    this.transactions = const [],
    this.isLoading = false,
    this.error,
  });

  TransactionsState copyWith({
    List<TransactionEntity>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TransactionsNotifier extends StateNotifier<TransactionsState> {
  TransactionsNotifier() : super(TransactionsState()) {
    loadTransactions();
  }

  final _uuid = const Uuid();

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true);

    final box = Hive.box('transactions');
    final List<TransactionEntity> transactions = [];

    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i);
      if (data != null) {
        transactions.add(TransactionEntity.fromMap(data as Map));
      }
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));

    state = state.copyWith(
      transactions: transactions,
      isLoading: false,
    );
  }

  Future<void> addTransaction({
    required String type,
    required String category,
    required double amount,
    required DateTime date,
    required String description,
  }) async {
    final box = Hive.box('transactions');

    final transaction = TransactionEntity(
      id: _uuid.v4(),
      type: type,
      category: category,
      amount: amount,
      date: date,
      description: description,
    );

    await box.add(transaction.toMap());

    final gamificationBox = Hive.box('gamification');
    final currentXp = gamificationBox.get('xp', defaultValue: 0) as int;
    await gamificationBox.put('xp', currentXp + 10);

    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    final box = Hive.box('transactions');

    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i) as Map?;
      if (data != null && data['id'] == id) {
        await box.deleteAt(i);
        break;
      }
    }

    await loadTransactions();
  }
}
