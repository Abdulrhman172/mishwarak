// ═══════════════════════════════════════════════════════════════
// wallet_screen.dart - المحفظة (الرصيد، طرق الدفع، المعاملات)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// معاملة واحدة في سجل المحفظة.
class _Txn {
  final IconData icon;
  final String title;
  final String subtitle;
  final int amount; // موجب = إيداع، سالب = خصم

  const _Txn(this.icon, this.title, this.subtitle, this.amount);
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const _transactions = [
    _Txn(Icons.local_taxi_outlined, 'رحلة إلى جامعة عدن', 'اليوم · 09:24', -3800),
    _Txn(Icons.add_circle_outline, 'شحن المحفظة', 'أمس · 18:12', 10000),
    _Txn(Icons.card_giftcard, 'مكافأة ترحيبية', '4 يوليو · 14:00', 2000),
    _Txn(Icons.local_taxi_outlined, 'رحلة إلى المعلا', '3 يوليو · 20:30', -2100),
    _Txn(Icons.local_offer_outlined, 'استرداد كوبون', '2 يوليو · 11:15', 500),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المحفظة'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('السجل'),
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
                  color: MishwarakColors.primary.withOpacity(0.25),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الرصيد الحالي',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '15,300 ',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
                      ),
                      TextSpan(
                        text: 'ر.ي',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _BalanceAction(
                        icon: Icons.add,
                        label: 'شحن الرصيد',
                        filled: true,
                        onTap: () => _snack(context, 'شحن الرصيد قيد الإنشاء'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BalanceAction(
                        icon: Icons.send_outlined,
                        label: 'تحويل',
                        filled: false,
                        onTap: () => _snack(context, 'التحويل قيد الإنشاء'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ═══ طرق الدفع ═══
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('طرق الدفع', style: theme.textTheme.headlineSmall),
              TextButton(onPressed: () {}, child: const Text('+ إضافة')),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _PaymentCard.cash(),
                SizedBox(width: 10),
                _PaymentCard.visa(last4: '4287'),
                SizedBox(width: 10),
                _PaymentCard.add(),
              ],
            ),
          ),

          // ═══ المعاملات ═══
          const SizedBox(height: 24),
          Text('آخر المعاملات', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.dividerColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < _transactions.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: theme.dividerColor),
                  _TxnTile(txn: _transactions[i]),
                ],
              ],
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
      color: filled ? Colors.white : Colors.white.withOpacity(0.2),
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
                : Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
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
enum _CardKind { cash, visa, add }

class _PaymentCard extends StatelessWidget {
  final _CardKind kind;
  final String? last4;

  const _PaymentCard._(this.kind, {this.last4});

  const _PaymentCard.cash() : this._(_CardKind.cash);
  const _PaymentCard.visa({required String last4})
      : this._(_CardKind.visa, last4: last4);
  const _PaymentCard.add() : this._(_CardKind.add);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (kind == _CardKind.add) {
      return Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.dividerColor,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 22, color: MishwarakColors.lightTextMuted),
            const SizedBox(height: 6),
            Text(
              'إضافة بطاقة',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: MishwarakColors.lightTextMuted,
              ),
            ),
          ],
        ),
      );
    }

    final isCash = kind == _CardKind.cash;
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
              if (!isCash)
                const Text(
                  'VISA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
          if (isCash)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'نقدي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'الافتراضي',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            )
          else
            Text(
              '•••• $last4',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                letterSpacing: 1.5,
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────── سطر معاملة ───────────────
class _TxnTile extends StatelessWidget {
  final _Txn txn;

  const _TxnTile({required this.txn});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCredit = txn.amount > 0;
    // تنسيق يدوي للفاصلة الألفية (بدل intl لتفادي تهيئة locale)
    final abs = txn.amount.abs().toString();
    final formatted = abs.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );

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
                  ? MishwarakColors.success.withOpacity(0.15)
                  : theme.cardColor,
            ),
            child: Icon(
              txn.icon,
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
                  txn.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  txn.subtitle,
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
