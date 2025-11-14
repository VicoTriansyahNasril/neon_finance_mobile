import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../../transactions/presentation/providers/transactions_provider.dart';

class SpendingSummaryWidget extends ConsumerStatefulWidget {
  const SpendingSummaryWidget({super.key});

  @override
  ConsumerState<SpendingSummaryWidget> createState() =>
      _SpendingSummaryWidgetState();
}

class _SpendingSummaryWidgetState extends ConsumerState<SpendingSummaryWidget> {
  String _selectedPeriod = 'week';

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Keuangan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          transactionsAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.neonPurple),
            ),
            error: (error, stack) => Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
            ),
            data: (transactions) {
              final summary = _calculateSummary(transactions);
              return Column(
                children: [
                  _buildSummaryRow(
                    'Pemasukan',
                    summary['income']!,
                    AppTheme.neonGreen,
                    Icons.trending_up,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Pengeluaran',
                    summary['expense']!,
                    Colors.red,
                    Icons.trending_down,
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Saldo',
                    summary['balance']!,
                    summary['balance']! >= 0 ? AppTheme.neonPurple : Colors.red,
                    Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 16),
                  _buildProgressBar(summary['expense']!, summary['income']!),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      children: [
        _buildPeriodButton('week', 'Minggu'),
        const SizedBox(width: 8),
        _buildPeriodButton('month', 'Bulan'),
        const SizedBox(width: 8),
        _buildPeriodButton('3months', '3 Bulan'),
      ],
    );
  }

  Widget _buildPeriodButton(String period, String label) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedPeriod = period),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.neonPurple.withValues(alpha: 0.2)
                : AppTheme.darkCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppTheme.neonPurple
                  : AppTheme.neonPurple.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? AppTheme.neonPurple : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      String label, double amount, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ),
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

  Widget _buildProgressBar(double expense, double income) {
    if (income == 0) {
      return const SizedBox.shrink();
    }

    final percentage = (expense / income * 100).clamp(0, 100);
    final isHealthy = percentage <= 70;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rasio Pengeluaran',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white54,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isHealthy ? AppTheme.neonGreen : Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(
              isHealthy ? AppTheme.neonGreen : Colors.orange,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isHealthy
              ? '✓ Pengeluaran terkendali dengan baik'
              : '⚠ Perhatikan pengeluaran Anda',
          style: TextStyle(
            fontSize: 12,
            color: isHealthy ? AppTheme.neonGreen : Colors.orange,
          ),
        ),
      ],
    );
  }

  Map<String, double> _calculateSummary(List transactions) {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case '3months':
        startDate = DateTime(now.year, now.month - 2, 1);
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    final filteredTransactions = transactions.where((t) {
      return t.date.isAfter(startDate) || t.date.isAtSameMomentAs(startDate);
    }).toList();

    final income = filteredTransactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);

    final expense = filteredTransactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    return {
      'income': income,
      'expense': expense,
      'balance': income - expense,
    };
  }
}
