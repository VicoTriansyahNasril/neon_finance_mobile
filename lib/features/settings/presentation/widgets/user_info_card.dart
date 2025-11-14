import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class UserInfoCard extends ConsumerWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      data: (profile) => NeonCard(
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.neonPurple,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.neonPurple.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: AppTheme.neonPurple,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.email ?? 'email@example.com',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.push('/profile/edit'),
              icon: const Icon(
                Icons.edit,
                color: AppTheme.neonPurple,
                size: 24,
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
