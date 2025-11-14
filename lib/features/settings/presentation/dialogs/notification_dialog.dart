import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

void showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Pengaturan Notifikasi',
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNotificationToggle('Notifikasi Transaksi', true),
          _buildNotificationToggle('Notifikasi Budget', true),
          _buildNotificationToggle('Notifikasi Goal', true),
          _buildNotificationToggle('Reminder Harian', false),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Tutup',
            style: TextStyle(
              color: AppTheme.neonPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildNotificationToggle(String label, bool value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        Switch(
          value: value,
          activeTrackColor: AppTheme.neonPurple.withValues(alpha: 0.5),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTheme.neonPurple;
            }
            return Colors.grey;
          }),
          onChanged: (val) {},
        ),
      ],
    ),
  );
}
