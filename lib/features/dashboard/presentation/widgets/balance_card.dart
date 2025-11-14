import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      child: Column(
        children: [
          const Text(
            'Total Saldo',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rp ${balance.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  'Pemasukan',
                  income,
                  AppTheme.neonGreen,
                  Icons.trending_up,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white12,
              ),
              Expanded(
                child: _buildBalanceItem(
                  'Pengeluaran',
                  expense,
                  Colors.red,
                  Icons.trending_down,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(
      String label, double amount, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Rp ${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
