import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

void showInfoDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white70, fontSize: 15),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'OK',
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
