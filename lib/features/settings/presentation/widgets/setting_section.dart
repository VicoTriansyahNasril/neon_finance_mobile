import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/neon_card.dart';
import 'settings_item.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  const SettingsSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.neonPurple,
            ),
          ),
        ),
        NeonCard(
          child: Column(
            children: List.generate(
              items.length * 2 - 1,
              (index) {
                if (index.isOdd) {
                  return const Divider(color: Colors.white12, height: 1);
                }
                return items[index ~/ 2];
              },
            ),
          ),
        ),
      ],
    );
  }
}
