import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../domain/entities/user_profile_entity.dart';

class ProfileInfoSection extends StatelessWidget {
  final UserProfileEntity? profile;

  const ProfileInfoSection({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Pribadi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'Telepon',
            value: profile?.phoneNumber ?? '-',
          ),
          const Divider(color: Colors.white12, height: 32),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Alamat',
            value: profile?.address ?? '-',
          ),
          const Divider(color: Colors.white12, height: 32),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Tanggal Lahir',
            value: profile?.dateOfBirth != null
                ? '${profile!.dateOfBirth!.day}/${profile!.dateOfBirth!.month}/${profile!.dateOfBirth!.year}'
                : '-',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.neonPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.neonPurple, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
