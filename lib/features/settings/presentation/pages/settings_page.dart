import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/setting_section.dart';
import '../widgets/settings_item.dart';
import '../widgets/user_info_card.dart';
import '../dialogs/language_dialog.dart';
import '../dialogs/logout_dialog.dart';
import '../dialogs/notification_dialog.dart';
import '../dialogs/change_password_dialog.dart';
import '../dialogs/export_dialog.dart';
import '../dialogs/info_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);

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
            const UserInfoCard(),
            const SizedBox(height: 24),
            SettingsSection(
              title: 'Preferensi',
              items: [
                SettingsItem(
                  icon: Icons.language,
                  title: 'Bahasa',
                  subtitle:
                      locale.languageCode == 'id' ? 'Indonesia' : 'English',
                  onTap: () => showLanguageDialog(context, ref),
                ),
                SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifikasi',
                  subtitle: 'Kelola notifikasi aplikasi',
                  onTap: () => showNotificationDialog(context),
                ),
                SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Tema',
                  subtitle: 'Dark Mode (Default)',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            SettingsSection(
              title: 'Keamanan',
              items: [
                SettingsItem(
                  icon: Icons.lock_outline,
                  title: 'Ubah Password',
                  subtitle: 'Perbarui password Anda',
                  onTap: () => showChangePasswordDialog(context),
                ),
                SettingsItem(
                  icon: Icons.fingerprint,
                  title: 'Biometric Login',
                  subtitle: 'Aktifkan login dengan sidik jari',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            SettingsSection(
              title: 'Data & Backup',
              items: [
                SettingsItem(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Backup Data',
                  subtitle: 'Simpan data ke cloud',
                  onTap: () => showInfoDialog(
                    context,
                    'Backup Data',
                    'Fitur backup data akan segera hadir. Data Anda akan disimpan dengan aman ke cloud storage.',
                  ),
                ),
                SettingsItem(
                  icon: Icons.cloud_download_outlined,
                  title: 'Restore Data',
                  subtitle: 'Pulihkan data dari backup',
                  onTap: () => showInfoDialog(
                    context,
                    'Restore Data',
                    'Fitur restore data akan segera hadir. Anda dapat memulihkan data dari backup yang tersimpan.',
                  ),
                ),
                SettingsItem(
                  icon: Icons.download_outlined,
                  title: 'Export Data',
                  subtitle: 'Export data ke CSV/Excel',
                  onTap: () => showExportDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SettingsSection(
              title: 'Tentang',
              items: [
                SettingsItem(
                  icon: Icons.info_outline,
                  title: 'Versi Aplikasi',
                  subtitle: '1.0.0',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Kebijakan Privasi',
                  subtitle: 'Baca kebijakan privasi kami',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.description_outlined,
                  title: 'Syarat & Ketentuan',
                  subtitle: 'Ketentuan penggunaan aplikasi',
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.star_outline,
                  title: 'Rate Aplikasi',
                  subtitle: 'Berikan rating di Play Store',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            NeonCard(
              child: SettingsItem(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Keluar dari akun Anda',
                color: Colors.red,
                onTap: () => showLogoutDialog(context, ref),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Made with ❤️ by Vico Triansyah',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
