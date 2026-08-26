// ═══════════════════════════════════════════════════════════════
// vip_screen.dart - اشتراك VIP
// ═══════════════════════════════════════════════════════════════
// الاشتراك ليس مبنيّاً في الخلفية بعد (لا جدول اشتراكات ولا بوابة
// دفع). الشاشة تشرح المزايا وتقول ذلك صراحةً بدل زرّ يوهم بالشراء.
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class VipScreen extends StatelessWidget {
  const VipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    final perks = <(IconData, String)>[
      (Icons.percent_rounded, l10n.vipPerkDiscount),
      (Icons.directions_car_filled_rounded, l10n.vipPerkCars),
      (Icons.event_busy_rounded, l10n.vipPerkCancel),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.vipTitle), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: MishwarakColors.accentGradient,
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.vipTitle,
                  style: theme.textTheme.headlineLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.vipIntro,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          for (final (icon, label) in perks)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: MishwarakColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 20, color: MishwarakColors.accent),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(label, style: theme.textTheme.bodyLarge),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: MishwarakColors.lightTextMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.vipNotAvailable,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: MishwarakColors.lightTextMuted),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(l10n.notifyMeDone)));
            },
            icon: const Icon(Icons.notifications_active_outlined, size: 18),
            label: Text(l10n.notifyMe),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
