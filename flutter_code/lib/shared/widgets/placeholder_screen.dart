// ═══════════════════════════════════════════════════════════════
// placeholder_screen.dart - شاشة مؤقتة لحين بناء الشاشة الفعلية
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool showBack;

  const PlaceholderScreen({
    super.key,
    required this.title,
    this.icon = Icons.construction_rounded,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBack,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: MishwarakColors.lightTextLight),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text(
              'قيد الإنشاء',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MishwarakColors.lightTextMuted,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
