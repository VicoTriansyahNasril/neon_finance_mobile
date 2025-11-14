import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeonCard extends StatelessWidget {
  final Widget child;
  final Color? glowColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const NeonCard({
    super.key,
    required this.child,
    this.glowColor,
    this.borderRadius,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = glowColor ?? AppTheme.neonPurple;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
