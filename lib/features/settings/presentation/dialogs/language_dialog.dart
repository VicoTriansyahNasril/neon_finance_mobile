import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/locale_provider.dart';

void showLanguageDialog(BuildContext context, WidgetRef ref) {
  final currentLocale = ref.read(localeProvider);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Pilih Bahasa',
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption(
              context, ref, 'Indonesia', const Locale('id'), currentLocale),
          const SizedBox(height: 12),
          _buildLanguageOption(
              context, ref, 'English', const Locale('en'), currentLocale),
        ],
      ),
    ),
  );
}

Widget _buildLanguageOption(
  BuildContext context,
  WidgetRef ref,
  String label,
  Locale locale,
  Locale currentLocale,
) {
  final isSelected = locale.languageCode == currentLocale.languageCode;

  return InkWell(
    onTap: () {
      ref.read(localeProvider.notifier).setLocale(locale);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bahasa diubah ke $label'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.neonPurple.withValues(alpha: 0.2)
            : AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppTheme.neonPurple
              : AppTheme.neonPurple.withValues(alpha: 0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? AppTheme.neonPurple : Colors.white54,
            size: 24,
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppTheme.neonPurple : Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
