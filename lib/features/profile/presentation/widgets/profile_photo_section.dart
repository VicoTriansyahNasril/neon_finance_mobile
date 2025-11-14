import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../domain/entities/user_profile_entity.dart';

class ProfilePhotoSection extends StatelessWidget {
  final UserProfileEntity? profile;

  const ProfilePhotoSection({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.neonPurple, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neonPurple.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: profile?.photoPath != null
                  ? Image.file(File(profile!.photoPath!), fit: BoxFit.cover)
                  : Container(
                      color: AppTheme.cardBg,
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: AppTheme.neonPurple,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile?.name ?? 'User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile?.email ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
