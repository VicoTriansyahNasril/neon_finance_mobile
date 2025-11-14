import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/locale_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(l10n.language),
          _buildLanguageTile(context, ref, l10n, currentLocale),
          const SizedBox(height: 24),
          _buildSectionTitle(l10n.theme),
          _buildThemeTile(l10n),
          const SizedBox(height: 24),
          _buildSectionTitle(l10n.security),
          _buildSecurityTiles(l10n),
          const SizedBox(height: 24),
          _buildSectionTitle(l10n.about),
          _buildAboutTiles(l10n),
          const SizedBox(height: 24),
          _buildLogoutButton(context, l10n),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.neonPurple,
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, WidgetRef ref,
      AppLocalizations l10n, Locale currentLocale) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.neonPurple.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.neonPurple.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.language, color: AppTheme.neonPurple),
        ),
        title: Text(
          l10n.language,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          currentLocale.languageCode == 'en' ? l10n.english : l10n.indonesian,
          style: const TextStyle(color: Colors.white60),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white60),
        onTap: () => _showLanguageDialog(context, ref, l10n, currentLocale),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref,
      AppLocalizations l10n, Locale currentLocale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context,
              ref,
              l10n.english,
              'en',
              currentLocale.languageCode == 'en',
            ),
            const SizedBox(height: 8),
            _buildLanguageOption(
              context,
              ref,
              l10n.indonesian,
              'id',
              currentLocale.languageCode == 'id',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, WidgetRef ref, String title,
      String code, bool isSelected) {
    return InkWell(
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(Locale(code));
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.neonPurple.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.neonPurple : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppTheme.neonPurple : Colors.white,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: AppTheme.neonPurple, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeTile(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.neonCyan.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.neonCyan.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.palette, color: AppTheme.neonCyan),
        ),
        title: Text(
          l10n.theme,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          l10n.neonPurple,
          style: const TextStyle(color: Colors.white60),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white60),
        onTap: () {},
      ),
    );
  }

  Widget _buildSecurityTiles(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.neonPink.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.neonPink.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.lock, color: AppTheme.neonPink),
            ),
            title: Text(
              l10n.appLock,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeThumbColor: AppTheme.neonPink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTiles(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.electricBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.electricBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info, color: AppTheme.electricBlue),
            ),
            title: Text(
              l10n.version,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              '1.0.0',
              style: TextStyle(color: Colors.white60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.logout, color: Colors.red),
        ),
        title: Text(
          l10n.logout,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        onTap: () async {
          final authBox = Hive.box('auth');
          await authBox.clear();
          if (context.mounted) {
            context.go('/login');
          }
        },
      ),
    );
  }
}
