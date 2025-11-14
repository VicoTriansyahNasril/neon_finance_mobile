import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../../../../core/theme/app_theme.dart';

void showLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Logout',
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
      content: const Text(
        'Apakah Anda yakin ingin keluar?',
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Batal',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () async {
            final box = Hive.box('auth');
            await box.put('isLoggedIn', false);

            if (context.mounted) {
              Navigator.pop(context);
              context.go('/login');
            }
          },
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );
}
