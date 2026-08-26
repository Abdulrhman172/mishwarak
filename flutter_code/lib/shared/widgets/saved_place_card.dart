// ═══════════════════════════════════════════════════════════════
// saved_place_card.dart - بطاقة مكان محفوظ (المنزل/العمل/إضافة)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SavedPlaceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isAdd;

  const SavedPlaceCard({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isAdd ? MishwarakColors.primary.withValues(alpha: 0.4) : theme.dividerColor,
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 20,
                  color: isAdd ? MishwarakColors.primary : theme.colorScheme.onSurface),
              const SizedBox(height: 6),
              Text(label,
                  style: theme.textTheme.labelMedium, textAlign: TextAlign.center),
              Text(subtitle,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: MishwarakColors.lightTextMuted),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
