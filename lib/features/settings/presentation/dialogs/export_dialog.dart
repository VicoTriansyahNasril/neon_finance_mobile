import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

void showExportDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Export Data',
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pilih format export:',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 16),
          _buildExportOption(context, 'CSV', Icons.table_chart),
          const SizedBox(height: 12),
          _buildExportOption(context, 'Excel', Icons.grid_on),
          const SizedBox(height: 12),
          _buildExportOption(context, 'PDF', Icons.picture_as_pdf),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Batal',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      ],
    ),
  );
}

Widget _buildExportOption(BuildContext context, String format, IconData icon) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export ke $format akan segera hadir'),
          backgroundColor: AppTheme.neonPurple,
          behavior: SnackBarBehavior.floating,
        ),
      );
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.neonPurple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.neonPurple, size: 24),
          const SizedBox(width: 16),
          Text(
            format,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
