// ═══════════════════════════════════════════════════════════════
// service_shortcut.dart - اختصار خدمة سريعة (اقتصادي/VIP/نساء...)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

class ServiceShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const ServiceShortcut({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
