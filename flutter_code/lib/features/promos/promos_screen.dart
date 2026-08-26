// ═══════════════════════════════════════════════════════════════
// promos_screen.dart - الكوبونات والعروض المتاحة
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../booking/data/promo_repository.dart';

class PromosScreen extends ConsumerWidget {
  const PromosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final promos = ref.watch(availablePromosProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.promosTitle),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(availablePromosProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: promos.when(
        data: (list) => list.isEmpty
            ? _Empty(message: l10n.promoNone)
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: list.length,
                itemBuilder: (_, i) => _PromoCard(promo: list[i]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _Empty(message: l10n.promoFailed),
      ),
    );
  }
}

// ─────────────── بطاقة كوبون ───────────────
class _PromoCard extends StatelessWidget {
  final PromoCode promo;

  const _PromoCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final language = Localizations.localeOf(context).languageCode;

    // نسبة أو مبلغ ثابت — أحدهما موجود دائماً.
    final headline = promo.discountPercent != null
        ? l10n.promoOffPercent(promo.discountPercent!)
        : l10n.promoOffAmount(
            formatMoney(promo.discountAmount ?? 0),
            l10n.currency,
          );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MishwarakColors.accent.withValues(alpha: 0.45),
          width: 1.5,
        ),
        color: MishwarakColors.accent.withValues(alpha: 0.06),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_offer_rounded,
                  size: 20,
                  color: MishwarakColors.accent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    headline,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              promo.description(language),
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: MishwarakColors.lightTextMuted),
            ),
            if (promo.validUntil != null) ...[
              const SizedBox(height: 4),
              Text(
                l10n.promoValidUntil(formatDayLabel(context, promo.validUntil!)),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: MishwarakColors.lightTextLight),
              ),
            ],
            const SizedBox(height: 12),

            // ═══ الرمز + نسخ ═══
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Text(
                      promo.code,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _copy(context, l10n),
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: Text(l10n.promoCopy),
                  style: FilledButton.styleFrom(
                    backgroundColor: MishwarakColors.primary,
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context, L10n l10n) async {
    await Clipboard.setData(ClipboardData(text: promo.code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.promoCopied(promo.code))));
  }
}

// ─────────────── لا توجد عروض ───────────────
class _Empty extends StatelessWidget {
  final String message;

  const _Empty({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 44,
            color: MishwarakColors.lightTextMuted,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: MishwarakColors.lightTextMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
