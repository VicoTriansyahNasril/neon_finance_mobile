import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../domain/entities/wallet_entity.dart';
import '../providers/wallet_provider.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletProvider);
    final totalBalance = ref.read(walletProvider.notifier).getTotalBalance();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        title: const Text(
          'Kelola Dompet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.neonPurple.withValues(alpha: 0.3),
                  AppTheme.neonCyan.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.neonPurple.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neonPurple.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Total Saldo Keseluruhan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${totalBalance.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${wallets.length} Dompet Aktif',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: wallets.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: wallets.length,
                    itemBuilder: (context, index) {
                      return _buildWalletCard(context, ref, wallets[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWalletDialog(context, ref),
        backgroundColor: AppTheme.neonPurple,
        icon: const Icon(Icons.add, size: 24),
        label: const Text(
          'Tambah Dompet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
            'Belum ada dompet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan dompet untuk mulai tracking',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(
      BuildContext context, WidgetRef ref, WalletEntity wallet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeonCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getWalletColor(wallet.type).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getWalletIcon(wallet.type),
                    color: _getWalletColor(wallet.type),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wallet.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _getWalletTypeLabel(wallet.type),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  color: AppTheme.cardBg,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.edit,
                              color: AppTheme.neonPurple, size: 20),
                          SizedBox(width: 12),
                          Text('Edit', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      onTap: () => Future.delayed(
                        Duration.zero,
                        () => _showEditWalletDialog(context, ref, wallet),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 12),
                          Text('Hapus', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      onTap: () => Future.delayed(
                        Duration.zero,
                        () => _showDeleteDialog(context, ref, wallet.id),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getWalletColor(wallet.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getWalletColor(wallet.type).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saldo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Rp ${wallet.balance.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getWalletColor(wallet.type),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddWalletDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final balanceController = TextEditingController(text: '0');
    String selectedType = 'bank';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Tambah Dompet',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nama Dompet',
                      labelStyle: const TextStyle(color: AppTheme.neonPurple),
                      hintText: 'Contoh: BCA, Gopay, Tunai',
                      hintStyle: const TextStyle(color: Colors.white30),
                      filled: true,
                      fillColor: AppTheme.darkCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan nama dompet';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Jenis Dompet',
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
                    items: const [
                      DropdownMenuItem(value: 'bank', child: Text('Bank')),
                      DropdownMenuItem(value: 'cash', child: Text('Tunai')),
                      DropdownMenuItem(
                          value: 'ewallet', child: Text('E-Wallet')),
                    ],
                    onChanged: (value) => setState(() => selectedType = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: balanceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Saldo Awal',
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
                        return 'Masukkan saldo awal';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final wallet = WalletEntity(
                    id: const Uuid().v4(),
                    name: nameController.text.trim(),
                    type: selectedType,
                    balance: double.parse(balanceController.text),
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  await ref.read(walletProvider.notifier).addWallet(wallet);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dompet berhasil ditambahkan'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: AppTheme.neonPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditWalletDialog(
      BuildContext context, WidgetRef ref, WalletEntity wallet) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: wallet.name);
    final balanceController =
        TextEditingController(text: wallet.balance.toStringAsFixed(0));
    String selectedType = wallet.type;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit Dompet',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nama Dompet',
                      labelStyle: const TextStyle(color: AppTheme.neonPurple),
                      filled: true,
                      fillColor: AppTheme.darkCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan nama dompet';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Jenis Dompet',
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
                    items: const [
                      DropdownMenuItem(value: 'bank', child: Text('Bank')),
                      DropdownMenuItem(value: 'cash', child: Text('Tunai')),
                      DropdownMenuItem(
                          value: 'ewallet', child: Text('E-Wallet')),
                    ],
                    onChanged: (value) => setState(() => selectedType = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: balanceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Saldo',
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
                        return 'Masukkan saldo';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final updatedWallet = wallet.copyWith(
                    name: nameController.text.trim(),
                    type: selectedType,
                    balance: double.parse(balanceController.text),
                    updatedAt: DateTime.now(),
                  );
                  await ref
                      .read(walletProvider.notifier)
                      .updateWallet(updatedWallet);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dompet berhasil diupdate'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: AppTheme.neonPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String walletId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Hapus Dompet',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus dompet ini?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(walletProvider.notifier).deleteWallet(walletId);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dompet berhasil dihapus'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
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
