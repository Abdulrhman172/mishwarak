// ═══════════════════════════════════════════════════════════════
// promo_sheet.dart - إدخال كوبون الخصم قبل تأكيد الطلب
// ═══════════════════════════════════════════════════════════════
// كانت شريحة "كوبون" في شاشة اختيار المركبة `onTap: () {}` رغم أن
// جدولَي `promo_codes` و `promo_redemptions` مبنيان بالكامل.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/app_localizations.dart';
import '../data/promo_repository.dart';

/// كوبون مقبول: رمزه وقيمة خصمه.
class AppliedPromo {
  /// `null` يعني إزالة الكوبون المطبَّق.
  final String? code;
  final int discount;

  const AppliedPromo(this.code, this.discount);

  const AppliedPromo.none()
      : code = null,
        discount = 0;
}

/// رسالة مترجَمة لسبب رفض الكوبون.
String promoMessage(L10n l10n, PromoResult result) => switch (result.rejection) {
      PromoRejection.notFound => l10n.promoNotFound,
      PromoRejection.expired => l10n.promoExpired,
      PromoRejection.notStarted => l10n.promoNotStarted,
      PromoRejection.exhausted => l10n.promoExhausted,
      PromoRejection.alreadyUsed => l10n.promoAlreadyUsed,
      PromoRejection.rideClosed => l10n.promoRideClosed,
      _ => l10n.promoFailed,
    };

/// يفتح نافذة الكوبون. يعيد `null` إن أُغلقت بلا تغيير.
Future<AppliedPromo?> showPromoSheet(
  BuildContext context,
  WidgetRef ref, {
  required int fare,
  String? appliedCode,
}) {
  return showModalBottomSheet<AppliedPromo>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: _PromoSheet(ref: ref, fare: fare, appliedCode: appliedCode),
    ),
  );
}

class _PromoSheet extends StatefulWidget {
  final WidgetRef ref;
  final int fare;
  final String? appliedCode;

  const _PromoSheet({
    required this.ref,
    required this.fare,
    this.appliedCode,
  });

  @override
  State<_PromoSheet> createState() => _PromoSheetState();
}

class _PromoSheetState extends State<_PromoSheet> {
  late final TextEditingController _code;
  bool _checking = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _code = TextEditingController(text: widget.appliedCode ?? '');
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    final code = _code.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() {
      _checking = true;
      _error = null;
    });

    final l10n = L10n.of(context);
    final result = await widget.ref.read(promoRepositoryProvider).preview(
          code: code,
          fare: widget.fare,
        );

    if (!mounted) return;

    if (result.valid) {
      Navigator.pop(context, AppliedPromo(code, result.discount));
      return;
    }

    setState(() {
      _checking = false;
      _error = promoMessage(l10n, result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final available = widget.ref.watch(availablePromosProvider).valueOrNull ??
        const <PromoCode>[];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(l10n.promosTitle, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),

          TextField(
            controller: _code,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(24),
            ],
            decoration: InputDecoration(
              labelText: l10n.promoCodeLabel,
              errorText: _error,
              prefixIcon: const Icon(Icons.local_offer_outlined),
            ),
            onSubmitted: (_) => _check(),
          ),
          const SizedBox(height: 14),

          ElevatedButton(
            onPressed: _checking ? null : _check,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: theme.dividerColor,
            ),
            child: _checking
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(l10n.apply),
          ),

          if (widget.appliedCode != null) ...[
            const SizedBox(height: 6),
            TextButton.icon(
              onPressed: () =>
                  Navigator.pop(context, const AppliedPromo.none()),
              icon: const Icon(Icons.close_rounded, size: 18),
              label: Text(l10n.remove),
              style: TextButton.styleFrom(
                foregroundColor: MishwarakColors.danger,
              ),
            ),
          ],

          // ═══ عروض جاهزة للنقر ═══
          if (available.isNotEmpty) ...[
            const SizedBox(height: 18),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                l10n.promosTitle,
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: MishwarakColors.lightTextMuted),
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: available.length,
                itemBuilder: (_, i) {
                  final promo = available[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: const Icon(
                      Icons.local_offer_rounded,
                      color: MishwarakColors.accent,
                      size: 20,
                    ),
                    title: Text(
                      promo.code,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      promo.description(language),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      promo.discountPercent != null
                          ? l10n.promoOffPercent(promo.discountPercent!)
                          : l10n.promoOffAmount(
                              formatMoney(promo.discountAmount ?? 0),
                              l10n.currency,
                            ),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: MishwarakColors.success),
                    ),
                    onTap: () {
                      _code.text = promo.code;
                      _check();
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
