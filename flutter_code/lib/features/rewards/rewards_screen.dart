// ═══════════════════════════════════════════════════════════════
// rewards_screen.dart - نظام النقاط والمستويات
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/settings_section.dart';
import '../profile/data/profile_repository.dart';

/// عتبات المستويات بالنقاط.
///
/// مطابقة لقاعدة الاحتساب في `settle_completed_ride`: نقطة لكل 100
/// ريال، أي أن المستوى الذهبي ≈ 300 ألف ريال من الرحلات.
const _tiers = <int>[1000, 3000, 10000];

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final points = ref.watch(userProfileProvider).valueOrNull?.points ?? 0;

    final tierNames = [
      l10n.rewardsTierSilver,
      l10n.rewardsTierGold,
      l10n.rewardsTierPlatinum,
    ];

    // أعلى مستوى بلغه المستخدم، أو "—" إن لم يبلغ الأول بعد.
    final reachedIndex =
        _tiers.lastIndexWhere((threshold) => points >= threshold);
    final currentTier =
        reachedIndex < 0 ? '—' : tierNames[reachedIndex];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.rewardsTitle), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // ═══ بطاقة الرصيد ═══
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: MishwarakColors.accentGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.rewardsBalance,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${formatMoney(points)} ',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: l10n.points,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.rewardsCurrentTier(currentTier),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Text(
            l10n.rewardsIntro,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: MishwarakColors.lightTextMuted),
          ),
          const SizedBox(height: 20),

          // ═══ المستويات ═══
          SettingsSection(
            title: l10n.rewardsTitle,
            children: [
              for (var i = 0; i < _tiers.length; i++)
                _TierTile(
                  name: tierNames[i],
                  threshold: _tiers[i],
                  points: points,
                  label: l10n.rewardsTierAt(formatMoney(_tiers[i])),
                ),
            ],
          ),

          // ═══ المزايا ═══
          SettingsSection(
            title: l10n.settingsAbout,
            children: [
              _PerkTile(icon: Icons.card_giftcard, label: l10n.rewardsPerkFreeRide),
              _PerkTile(icon: Icons.bolt_rounded, label: l10n.rewardsPerkPriority),
              _PerkTile(
                icon: Icons.support_agent_rounded,
                label: l10n.rewardsPerkSupport,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────── مستوى واحد مع شريط تقدّم ───────────────
class _TierTile extends StatelessWidget {
  final String name;
  final int threshold;
  final int points;
  final String label;

  const _TierTile({
    required this.name,
    required this.threshold,
    required this.points,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reached = points >= threshold;
    final progress = (points / threshold).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(
            reached ? Icons.workspace_premium : Icons.lock_outline_rounded,
            size: 20,
            color: reached
                ? MishwarakColors.accent
                : MishwarakColors.lightTextLight,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: MishwarakColors.lightTextMuted),
                ),
                if (!reached) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: theme.dividerColor,
                      valueColor: const AlwaysStoppedAnimation(
                        MishwarakColors.accent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── ميزة ───────────────
class _PerkTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PerkTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: MishwarakColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
