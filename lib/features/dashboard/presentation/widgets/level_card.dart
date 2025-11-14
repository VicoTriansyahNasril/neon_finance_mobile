import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';

class LevelCard extends StatelessWidget {
  final int level;
  final int xp;
  final int xpToNextLevel;

  const LevelCard({
    super.key,
    required this.level,
    required this.xp,
    required this.xpToNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (xp % 100) / 100;

    return NeonCard(
      child: InkWell(
        onTap: () => context.push('/gamification'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.neonPurple, AppTheme.neonCyan],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonPurple.withValues(alpha: 0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$level',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Level Progress',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$xpToNextLevel XP lagi',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.neonPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.neonPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$xp / ${level * 100} XP',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
