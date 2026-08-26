// ═══════════════════════════════════════════════════════════════
// glass_button.dart - أزرار زجاجية شفافة (Glass morphism)
// ═══════════════════════════════════════════════════════════════
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final double size;

  const GlassButton({
    super.key,
    required this.icon,
    this.iconColor,
    this.onTap,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          color: theme.cardColor.withValues(alpha: 0.85),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(
                icon,
                size: 22,
                color: iconColor ?? theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassPill extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final Widget child;
  final VoidCallback? onTap;

  const GlassPill({
    super.key,
    this.icon,
    this.iconColor,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          color: theme.cardColor.withValues(alpha: 0.85),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: iconColor),
                    const SizedBox(width: 8),
                  ],
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
