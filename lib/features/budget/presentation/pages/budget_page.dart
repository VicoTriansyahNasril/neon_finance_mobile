import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/budget_entity.dart';
import '../providers/budget_provider.dart';
import '../../../transactions/presentation/providers/transactions_provider.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final budgets = ref.watch(budgetProvider);
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.budget,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddBudgetDialog(context, ref, l10n),
            icon: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ],
      ),
      body: budgets.isEmpty
          ? _buildEmptyState(l10n)
          : transactionsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.neonPurple),
              ),
              error: (error, stack) => Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              data: (transactions) => RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(budgetProvider);
                  ref.invalidate(transactionsProvider);
                },
                color: AppTheme.neonPurple,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    return _buildBudgetCard(
                      context,
                      ref,
                      budgets[index],
                      transactions,
                      l10n,
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada anggaran',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + untuk menambah anggaran',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(
    BuildContext context,
    WidgetRef ref,
    BudgetEntity budget,
    List<dynamic> transactions,
    AppLocalizations l10n,
  ) {
    final now = DateTime.now();
    final spent = transactions
        .where((t) =>
            t.type == 'expense' &&
            t.category == budget.category &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);

    final percentage = (spent / budget.limit) * 100;
    final remaining = budget.limit - spent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeonCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    budget.category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      _showDeleteDialog(context, ref, budget.id, l10n),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Terpakai',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${spent.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Limit',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${budget.limit.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppTheme.neonPurple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage > 100 ? 1.0 : percentage / 100,
                minHeight: 12,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage >= 100
                      ? Colors.red
                      : percentage >= 80
                          ? Colors.orange
                          : AppTheme.neonGreen,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${percentage.toStringAsFixed(1)}% terpakai',
                  style: TextStyle(
                    color: percentage >= 100
                        ? Colors.red
                        : percentage >= 80
                            ? Colors.orange
                            : AppTheme.neonGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  remaining >= 0
                      ? 'Sisa: Rp ${remaining.toStringAsFixed(0)}'
                      : 'Lebih: Rp ${(-remaining).toStringAsFixed(0)}',
                  style: TextStyle(
                    color: remaining >= 0 ? Colors.white70 : Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBudgetDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final formKey = GlobalKey<FormState>();
    final limitController = TextEditingController();
    String? category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Tambah Anggaran',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: const TextStyle(color: AppTheme.neonPurple),
                  filled: true,
                  fillColor: AppTheme.darkCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: AppTheme.darkCard,
                style: const TextStyle(color: Colors.white),
                items: AppConstants.expenseCategories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) => category = value,
                validator: (value) {
                  if (value == null) return 'Pilih kategori';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: limitController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Limit Anggaran',
                  labelStyle: const TextStyle(color: AppTheme.neonPurple),
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(color: AppTheme.neonPurple),
                  filled: true,
                  fillColor: AppTheme.darkCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan limit';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Limit harus lebih dari 0';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final budget = BudgetEntity(
                  id: const Uuid().v4(),
                  category: category!,
                  limit: double.parse(limitController.text),
                  month: DateTime.now(),
                );
                await ref.read(budgetProvider.notifier).addBudget(budget);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text(
              l10n.save,
              style: const TextStyle(
                color: AppTheme.neonPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String budgetId,
      AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Hapus Anggaran',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus anggaran ini?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(budgetProvider.notifier).deleteBudget(budgetId);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
