import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../l10n/app_localizations.dart';

final notificationEnabledProvider = StateProvider<bool>((ref) {
  final box = Hive.box('settings');
  return box.get('notificationsEnabled', defaultValue: false) as bool;
});

final reminderEnabledProvider = StateProvider<bool>((ref) {
  final box = Hive.box('settings');
  return box.get('reminderEnabled', defaultValue: false) as bool;
});

final budgetAlertsProvider = StateProvider<bool>((ref) {
  final box = Hive.box('settings');
  return box.get('budgetAlerts', defaultValue: true) as bool;
});

final goalRemindersProvider = StateProvider<bool>((ref) {
  final box = Hive.box('settings');
  return box.get('goalReminders', defaultValue: true) as bool;
});

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        title: Text(
          l10n.settings,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLanguageSection(context, ref, l10n, currentLocale),
            const SizedBox(height: 24),
            _buildNotificationSection(context, ref, l10n),
            const SizedBox(height: 24),
            _buildThemeSection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Locale currentLocale,
  ) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.neonPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.language,
                  color: AppTheme.neonPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                l10n.language,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildLanguageTile(
            context: context,
            ref: ref,
            title: l10n.english,
            locale: const Locale('en'),
            currentLocale: currentLocale,
          ),
          const SizedBox(height: 12),
          _buildLanguageTile(
            context: context,
            ref: ref,
            title: l10n.indonesian,
            locale: const Locale('id'),
            currentLocale: currentLocale,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required Locale locale,
    required Locale currentLocale,
  }) {
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return InkWell(
      onTap: () => ref.read(localeProvider.notifier).setLocale(locale),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.neonPurple.withValues(alpha: 0.1)
              : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.neonPurple
                : AppTheme.neonPurple.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppTheme.neonPurple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final notificationEnabled = ref.watch(notificationEnabledProvider);
    final reminderEnabled = ref.watch(reminderEnabledProvider);
    final budgetAlerts = ref.watch(budgetAlertsProvider);
    final goalReminders = ref.watch(goalRemindersProvider);

    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.neonCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.neonCyan,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Notifikasi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSwitchTile(
            title: 'Aktifkan Notifikasi',
            subtitle: 'Aktifkan notifikasi aplikasi',
            value: notificationEnabled,
            onChanged: (value) async {
              if (value) {
                final granted =
                    await NotificationService().requestPermissions();
                if (granted) {
                  await NotificationService().initialize();
                  ref.read(notificationEnabledProvider.notifier).state = true;
                  final box = Hive.box('settings');
                  await box.put('notificationsEnabled', true);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Notifikasi diaktifkan',
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Izin notifikasi ditolak',
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              } else {
                await NotificationService().cancelAllNotifications();
                ref.read(notificationEnabledProvider.notifier).state = false;
                ref.read(reminderEnabledProvider.notifier).state = false;
                final box = Hive.box('settings');
                await box.put('notificationsEnabled', false);
                await box.put('reminderEnabled', false);
              }
            },
          ),
          if (notificationEnabled) ...[
            const Divider(color: Colors.white12, height: 32),
            _buildSwitchTile(
              title: 'Pengingat 6 Jam',
              subtitle: 'Pengingat otomatis setiap 6 jam',
              value: reminderEnabled,
              onChanged: (value) async {
                if (value) {
                  await NotificationService().schedule6HourReminder(
                    'Pengingat NeonFinance',
                    'Jangan lupa catat pengeluaran Anda hari ini!',
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pengingat 6 jam diaktifkan',
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else {
                  await NotificationService().cancelNotification(1);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pengingat 6 jam dinonaktifkan',
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }

                ref.read(reminderEnabledProvider.notifier).state = value;
                final box = Hive.box('settings');
                await box.put('reminderEnabled', value);
              },
            ),
            const Divider(color: Colors.white12, height: 32),
            _buildSwitchTile(
              title: 'Peringatan Anggaran',
              subtitle: 'Peringatan saat anggaran hampir habis',
              value: budgetAlerts,
              onChanged: (value) async {
                ref.read(budgetAlertsProvider.notifier).state = value;
                final box = Hive.box('settings');
                await box.put('budgetAlerts', value);
              },
            ),
            const Divider(color: Colors.white12, height: 32),
            _buildSwitchTile(
              title: 'Pengingat Target',
              subtitle: 'Pengingat deadline target',
              value: goalReminders,
              onChanged: (value) async {
                ref.read(goalRemindersProvider.notifier).state = value;
                final box = Hive.box('settings');
                await box.put('goalReminders', value);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppTheme.neonPurple.withValues(alpha: 0.3),
          thumbColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.neonPurple;
              }
              return Colors.white;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection(AppLocalizations l10n) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.neonGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.palette_outlined,
                  color: AppTheme.neonGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                l10n.theme,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Tema Neon (Default)',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
