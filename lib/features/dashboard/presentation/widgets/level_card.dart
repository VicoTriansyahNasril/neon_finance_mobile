import 'package:flutter/material.dart';
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
    final progress = xp / xpToNextLevel;

    return NeonCard(
      glowColor: AppTheme.neonCyan,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.neonCyan.withValues(alpha: 0.6),
                  AppTheme.neonCyan.withValues(alpha: 0.2),
                ],
              ),
              border: Border.all(
                color: AppTheme.neonCyan,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '$level',
                style: const TextStyle(
                  fontSize: 24,
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
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '$xp / $xpToNextLevel XP',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.neonCyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white10,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppTheme.neonCyan),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep going to reach Level ${level + 1}!',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
