import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';

class WalletListWidget extends ConsumerWidget {
  const WalletListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletProvider);
    final totalBalance = ref.read(walletProvider.notifier).getTotalBalance();

    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dompet Saya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton.icon(
                onPressed: () => context.push('/wallets'),
                icon:
                    const Icon(Icons.add, size: 18, color: AppTheme.neonPurple),
                label: const Text(
                  'Kelola',
                  style: TextStyle(
                    color: AppTheme.neonPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.neonPurple.withValues(alpha: 0.2),
                  AppTheme.neonCyan.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.neonPurple.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.neonPurple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: AppTheme.neonPurple,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Saldo',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${totalBalance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (wallets.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...wallets.take(3).map((wallet) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            _getWalletColor(wallet.type).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getWalletIcon(wallet.type),
                        color: _getWalletColor(wallet.type),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wallet.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _getWalletTypeLabel(wallet.type),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Rp ${wallet.balance.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _getWalletColor(wallet.type),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  IconData _getWalletIcon(String type) {
    switch (type) {
      case 'bank':
        return Icons.account_balance;
      case 'cash':
        return Icons.payments;
      case 'ewallet':
        return Icons.phone_android;
      default:
        return Icons.wallet;
    }
  }

  Color _getWalletColor(String type) {
    switch (type) {
      case 'bank':
        return AppTheme.electricBlue;
      case 'cash':
        return AppTheme.neonGreen;
      case 'ewallet':
        return AppTheme.neonPink;
      default:
        return AppTheme.neonPurple;
    }
  }

  String _getWalletTypeLabel(String type) {
    switch (type) {
      case 'bank':
        return 'Bank';
      case 'cash':
        return 'Tunai';
      case 'ewallet':
        return 'E-Wallet';
      default:
        return 'Lainnya';
    }
  }
}
