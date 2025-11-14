import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../theme/app_theme.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/transactions/presentation/pages/add_transaction_page.dart';
import '../../features/budget/presentation/pages/budget_page.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/gamification/presentation/pages/gamification_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/profile_edit_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/transactions',
      name: 'transactions',
      builder: (context, state) => const TransactionsPage(),
    ),
    GoRoute(
      path: '/transactions/add',
      name: 'addTransaction',
      builder: (context, state) => const AddTransactionPage(),
    ),
    GoRoute(
      path: '/budget',
      name: 'budget',
      builder: (context, state) => const BudgetPage(),
    ),
    GoRoute(
      path: '/goals',
      name: 'goals',
      builder: (context, state) => const GoalsPage(),
    ),
    GoRoute(
      path: '/analytics',
      name: 'analytics',
      builder: (context, state) => const AnalyticsPage(),
    ),
    GoRoute(
      path: '/gamification',
      name: 'gamification',
      builder: (context, state) => const GamificationPage(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/profile/edit',
      name: 'profileEdit',
      builder: (context, state) => const ProfileEditPage(),
    ),
    GoRoute(
      path: '/wallets',
      name: 'wallets',
      builder: (context, state) => const WalletPage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppTheme.darkBg,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            '404 - Page Not Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.neonPurple,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'Go Home',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  ),
);

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    _checkAuth();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authBox = Hive.box('auth');
    final isLoggedIn = authBox.get('isLoggedIn', defaultValue: false) as bool;
    final hasSeenOnboarding =
        authBox.get('hasSeenOnboarding', defaultValue: false) as bool;

    if (!hasSeenOnboarding) {
      context.go('/onboarding');
    } else if (!isLoggedIn) {
      context.go('/login');
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkBg,
              Color(0xFF1A0B2E),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.neonPurple.withValues(alpha: 0.6),
                          blurRadius: 60,
                          spreadRadius: 20,
                        ),
                        BoxShadow(
                          color: AppTheme.neonCyan.withValues(alpha: 0.4),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        'assets/images/neon_finance_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppTheme.neonPurple, AppTheme.neonCyan],
                    ).createShader(bounds),
                    child: const Text(
                      'NeonFinance',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your Smart Finance Companion',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.neonPurple.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
