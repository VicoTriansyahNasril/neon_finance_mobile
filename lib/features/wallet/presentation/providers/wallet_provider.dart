import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/wallet_entity.dart';

final walletProvider =
    StateNotifierProvider<WalletNotifier, List<WalletEntity>>(
  (ref) => WalletNotifier(),
);

class WalletNotifier extends StateNotifier<List<WalletEntity>> {
  final _box = Hive.box('wallet');

  WalletNotifier() : super([]) {
    _loadWallets();
  }

  void _loadWallets() {
    final wallets = <WalletEntity>[];
    for (var key in _box.keys) {
      final data = _box.get(key) as Map;
      wallets.add(WalletEntity.fromJson(Map<String, dynamic>.from(data)));
    }
    state = wallets;
  }

  Future<void> addWallet(WalletEntity wallet) async {
    await _box.put(wallet.id, wallet.toJson());
    state = [...state, wallet];
  }

  Future<void> updateWallet(WalletEntity wallet) async {
    await _box.put(wallet.id, wallet.toJson());
    state = [
      for (final w in state)
        if (w.id == wallet.id) wallet else w,
    ];
  }

  Future<void> deleteWallet(String id) async {
    await _box.delete(id);
    state = state.where((w) => w.id != id).toList();
  }

  Future<void> updateBalance(String walletId, double amount) async {
    final wallet = state.firstWhere((w) => w.id == walletId);
    final updatedWallet = wallet.copyWith(
      balance: wallet.balance + amount,
      updatedAt: DateTime.now(),
    );
    await updateWallet(updatedWallet);
  }

  double getTotalBalance() {
    return state.fold(0.0, (sum, w) => sum + w.balance);
  }

  WalletEntity? getWalletById(String id) {
    try {
      return state.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }
}
