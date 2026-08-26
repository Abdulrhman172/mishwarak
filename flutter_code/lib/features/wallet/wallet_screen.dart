// ═══════════════════════════════════════════════════════════════
// wallet_screen.dart - المحفظة (الرصيد، طرق الدفع، المعاملات)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import 'data/payment_method_repository.dart';
import 'data/wallet_repository.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final balance = ref.watch(walletBalanceProvider);
    final transactions = ref.watch(walletTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.walletTitle),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: l10n.retry,
            onPressed: () {
              ref.invalidate(walletBalanceProvider);
              ref.invalidate(walletTransactionsProvider);
              ref.invalidate(paymentMethodsProvider);
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // ═══ بطاقة الرصيد ═══
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: MishwarakColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: MishwarakColors.primary.withValues(alpha: 0.25),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.currentBalance,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${balance.when(
                          data: formatMoney,
                          loading: () => '—',
                          error: (_, __) => '—',
                        )} ',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: l10n.currency,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _BalanceAction(
                        icon: Icons.add,
                        label: l10n.topUp,
                        filled: true,
                        onTap: () => _snack(context, l10n.topUpComingSoon),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BalanceAction(
                        icon: Icons.send_outlined,
                        label: l10n.transfer,
                        filled: false,
                        onTap: () => _snack(context, l10n.transferComingSoon),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ═══ طرق الدفع ═══
          // البطاقات تأتي من جدول `payment_methods`. كانت هنا بطاقة
          // فيزا ثابتة في الكود (`•••• 4287`) لا وجود لها في حساب أي
          // مستخدم — تعرض للراكب وسيلة دفع لا يملكها.
          const SizedBox(height: 20),
          Text(l10n.paymentMethods, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: Consumer(
              builder: (context, ref, _) {
                final cards =
                    ref.watch(paymentMethodsProvider).valueOrNull ?? const [];

                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // النقد متاح دائماً ولا يحتاج تسجيلاً.
                    const _PaymentCard.cash(),
                    for (final card in cards) ...[
                      const SizedBox(width: 10),
                      _PaymentCard.saved(card),
                    ],
                    const SizedBox(width: 10),
                    _PaymentCard.add(
                      onTap: () => _snack(context, l10n.topUpComingSoon),
                    ),
                  ],
                );
              },
            ),
          ),

          // ═══ المعاملات ═══
          const SizedBox(height: 24),
          Text(l10n.recentTransactions, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.dividerColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: transactions.when(
              data: (list) {
                if (list.isEmpty) {
                  return const _EmptyTxns();
                }
                return Column(
                  children: [
                    for (var i = 0; i < list.length; i++) ...[
                      if (i > 0) Divider(height: 1, color: theme.dividerColor),
                      _TxnTile(txn: list[i]),
                    ],
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(28),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => _EmptyTxns(message: l10n.transactionsFailed),
            ),
          ),
        ],
      ),
    );
  }

  static void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// ─────────────── لا توجد معاملات ───────────────
class _EmptyTxns extends StatelessWidget {
  /// النص الافتراضي يُبنى في build لأنه يحتاج context للترجمة.
  final String? message;

  const _EmptyTxns({this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 34,
            color: MishwarakColors.lightTextMuted,
          ),
          const SizedBox(height: 10),
          Text(
            message ?? L10n.of(context).noTransactions,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: MishwarakColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── زر داخل بطاقة الرصيد ───────────────
class _BalanceAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _BalanceAction({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? Colors.white : Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: filled
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: filled ? MishwarakColors.primary : Colors.white,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: filled ? MishwarakColors.primary : Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────── بطاقة طريقة دفع ───────────────
class _PaymentCard extends StatelessWidget {
  /// بطاقة محفوظة، أو `null` لبطاقتي النقد والإضافة.
  final SavedPaymentMethod? saved;

  final bool isAdd;
  final VoidCallback? onTap;

  const _PaymentCard.cash()
      : saved = null,
        isAdd = false,
        onTap = null;

  const _PaymentCard.saved(SavedPaymentMethod card)
      : saved = card,
        isAdd = false,
        onTap = null;

  const _PaymentCard.add({this.onTap})
      : saved = null,
        isAdd = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    if (isAdd) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.dividerColor, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                size: 22,
                color: MishwarakColors.lightTextMuted,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.addCard,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: MishwarakColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final card = saved;
    final isCash = card == null || card.kind == PaymentKind.cash;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isCash
              ? const [Color(0xFF06D6A0), Color(0xFF04A47C)]
              : const [Color(0xFF1A1F36), Color(0xFF2E3554)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                isCash ? Icons.payments_outlined : Icons.credit_card,
                color: Colors.white,
                size: 22,
              ),
              if (!isCash && card.brand != null)
                Flexible(
                  child: Text(
                    card.brand!.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isCash ? l10n.cash : (card.label ?? '•••• ${card.last4 ?? ''}'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (isCash || card.isDefault)
                Text(
                  l10n.defaultLabel,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────── سطر معاملة ───────────────
class _TxnTile extends StatelessWidget {
  final WalletTransaction txn;

  const _TxnTile({required this.txn});

  /// أيقونة المعاملة.
  ///
  /// المعاملة المرتبطة برحلة معروفة من `ride_id` لا من نصّ وصفها:
  /// المطابقة على كلمات عربية كانت تفشل صامتةً لكل مستخدم إنجليزي،
  /// وتفشل مرة أخرى إن غُيّرت صياغة الوصف في الخادم.
  IconData get _icon {
    if (txn.rideId != null) return Icons.local_taxi_outlined;
    return txn.isCredit ? Icons.add_circle_outline : Icons.arrow_upward;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCredit = txn.isCredit;
    final formatted = formatMoney(txn.amount);

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isCredit
                  ? MishwarakColors.success.withValues(alpha: 0.15)
                  : theme.cardColor,
            ),
            child: Icon(
              _icon,
              size: 18,
              color: isCredit
                  ? MishwarakColors.success
                  : theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  txn.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  formatDateTimeLabel(context, txn.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: MishwarakColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : '-'}$formatted',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: isCredit ? MishwarakColors.success : null,
            ),
          ),
        ],
      ),
    );
  }
}
