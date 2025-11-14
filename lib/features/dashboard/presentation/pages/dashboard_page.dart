import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/balance_card.dart';
import '../widgets/level_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_transactions_widget.dart';
import '../widgets/spending_summary_widget.dart';
import '../widgets/wallet_list_widget.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../transactions/presentation/providers/transactions_provider.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final gamificationState = ref.watch(gamificationProvider);
    final walletNotifier = ref.read(walletProvider.notifier);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(profileProvider);
            ref.invalidate(transactionsProvider);
          },
          color: AppTheme.neonPurple,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.darkBg,
                        AppTheme.neonPurple.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                profileAsync.when(
                                  data: (profile) => Text(
                                    profile?.name ?? 'User',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  loading: () => const Text(
                                    'Loading...',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  error: (_, __) => const Text(
                                    'User',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_getDayName(now.weekday)}, ${now.day} ${_getMonthName(now.month)} ${now.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => context.push('/settings'),
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/profile'),
                                child: profileAsync.when(
                                  data: (profile) => Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.neonPurple,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.neonPurple
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: profile?.photoPath != null
                                        ? ClipOval(
                                            child: Image.file(
                                              File(profile!.photoPath!),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.person,
                                            color: AppTheme.neonPurple,
                                            size: 24,
                                          ),
                                  ),
                                  loading: () => Container(
                                    width: 45,
                                    height: 45,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.cardBg,
                                    ),
                                  ),
                                  error: (_, __) => Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.neonPurple,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: AppTheme.neonPurple,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    transactionsAsync.when(
                      data: (transactions) {
                        final now = DateTime.now();
                        final thisMonth = transactions.where((t) =>
                            t.date.month == now.month &&
                            t.date.year == now.year);

                        final income = thisMonth
                            .where((t) => t.type == 'income')
                            .fold(0.0, (sum, t) => sum + t.amount);

                        final expense = thisMonth
                            .where((t) => t.type == 'expense')
                            .fold(0.0, (sum, t) => sum + t.amount);

                        final balance = walletNotifier.getTotalBalance();

                        return BalanceCard(
                          balance: balance,
                          income: income,
                          expense: expense,
                        );
                      },
                      loading: () => BalanceCard(
                        balance: walletNotifier.getTotalBalance(),
                        income: 0,
                        expense: 0,
                      ),
                      error: (_, __) => BalanceCard(
                        balance: walletNotifier.getTotalBalance(),
                        income: 0,
                        expense: 0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const WalletListWidget(),
                    const SizedBox(height: 16),
                    const SpendingSummaryWidget(),
                    const SizedBox(height: 16),
                    LevelCard(
                      level: gamificationState.level,
                      xp: gamificationState.xp,
                      xpToNextLevel: (gamificationState.level * 100) -
                          gamificationState.xp,
                    ),
                    const SizedBox(height: 16),
                    const QuickActions(),
                    const SizedBox(height: 16),
                    const RecentTransactionsWidget(),
                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/transactions/add'),
        backgroundColor: AppTheme.neonPurple,
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  String _getDayName(int weekday) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              icon: Icons.home_outlined,
              label: 'Beranda',
              index: 0,
              currentIndex: currentIndex,
              onTap: () => context.go('/'),
            ),
            _buildNavItem(
              context,
              icon: Icons.receipt_long_outlined,
              label: 'Transaksi',
              index: 1,
              currentIndex: currentIndex,
              onTap: () => context.push('/transactions'),
            ),
            const SizedBox(width: 40),
            _buildNavItem(
              context,
              icon: Icons.bar_chart_outlined,
              label: 'Analitik',
              index: 2,
              currentIndex: currentIndex,
              onTap: () => context.push('/analytics'),
            ),
            _buildNavItem(
              context,
              icon: Icons.person_outline,
              label: 'Profil',
              index: 3,
              currentIndex: currentIndex,
              onTap: () => context.push('/profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == currentIndex;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.neonPurple : Colors.white54,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppTheme.neonPurple : Colors.white54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
