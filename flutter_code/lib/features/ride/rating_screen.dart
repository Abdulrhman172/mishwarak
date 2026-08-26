// ═══════════════════════════════════════════════════════════════
// rating_screen.dart - نهاية الرحلة وتقييم السائق
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/driver_avatar.dart';
import '../../shared/widgets/star_rating.dart';
import 'data/rating_tags.dart';
import 'data/ride_repository.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final String rideId;

  const RatingScreen({super.key, required this.rideId});

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  static const _tips = [0, 200, 500, 1000];

  int _rating = 0;

  /// مفاتيح الوسوم المختارة (`safe_driving`) لا نصوصها المعروضة —
  /// راجع [RatingTags].
  final Set<String> _selectedTagKeys = {};

  int _tip = 0;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final canSubmit = _rating > 0 && !_isSubmitting;

    final ride = ref.watch(rideStreamProvider(widget.rideId)).valueOrNull;
    final driver = ride?.driverId == null
        ? null
        : ref.watch(rideDriverProvider(ride!.driverId!)).valueOrNull;
    final driverName = driver?.fullName ?? l10n.driver;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ═══ رأس الشاشة ═══
                    const SizedBox(height: 20),
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MishwarakColors.success.withValues(alpha: 0.15),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: MishwarakColors.success,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(l10n.tripDone, style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      l10n.tripDoneBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: MishwarakColors.lightTextMuted,
                      ),
                    ),

                    // ═══ ملخص الأجرة ═══
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Column(
                        children: [
                          _FareRow(
                            label: l10n.tripFare,
                            value: '${formatMoney(ride?.fare ?? 0)} ${l10n.currency}',
                          ),
                          if (_tip > 0) ...[
                            const SizedBox(height: 8),
                            _FareRow(
                              label: l10n.tip,
                              value: '+${formatMoney(_tip)}',
                              highlight: MishwarakColors.success,
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 2),
                            child: Divider(height: 1, color: theme.dividerColor),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l10n.total, style: theme.textTheme.labelLarge),
                              RichText(
                                text: TextSpan(
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontSize: 20,
                                    color: MishwarakColors.primary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${formatMoney((ride?.fare ?? 0) + _tip)} ',
                                    ),
                                    TextSpan(
                                      text: l10n.currency,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: MishwarakColors.lightTextMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ═══ السائق والنجوم ═══
                    const SizedBox(height: 24),
                    DriverAvatar(
                      size: 70,
                      initials:
                          driverName.isEmpty ? '؟' : driverName.characters.first,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.rateQuestion(driverName.split(' ').first),
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    StarRatingInput(
                      value: _rating,
                      onChanged: (v) => setState(() {
                        // تبديل نوع الوسوم يُلغي الاختيار السابق
                        final flipped = (v >= 4) != (_rating >= 4);
                        _rating = v;
                        if (flipped) _selectedTagKeys.clear();
                        if (v < 4) _tip = 0;
                      }),
                    ),

                    // ═══ الوسوم ═══
                    if (_rating > 0) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _rating >= 4 ? l10n.whatYouLiked : l10n.whatWentWrong,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: MishwarakColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final tag
                                    in RatingTags.forRating(l10n, _rating))
                                  _TagChip(
                                    label: tag.label,
                                    selected:
                                        _selectedTagKeys.contains(tag.key),
                                    onTap: () => setState(() {
                                      _selectedTagKeys.contains(tag.key)
                                          ? _selectedTagKeys.remove(tag.key)
                                          : _selectedTagKeys.add(tag.key);
                                    }),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ═══ الإكرامية (للتقييم الجيد فقط) ═══
                    if (_rating >= 4) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.addTip,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: MishwarakColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                for (final t in _tips) ...[
                                  Expanded(
                                    child: _TipButton(
                                      label: t == 0 ? l10n.noTip : '$t',
                                      selected: _tip == t,
                                      onTap: () => setState(() => _tip = t),
                                    ),
                                  ),
                                  if (t != _tips.last) const SizedBox(width: 8),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ═══ زر الإرسال ═══
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: canSubmit ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MishwarakColors.primary,
                    disabledBackgroundColor: theme.dividerColor,
                    elevation: canSubmit ? 6 : 0,
                    shadowColor: MishwarakColors.primary.withValues(alpha: 0.4),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.submitRating),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(rideRepositoryProvider).submitRating(
            rideId: widget.rideId,
            rating: _rating,
            tagKeys: _selectedTagKeys.toList(),
            tip: _tip,
          );
      if (!mounted) return;

      // السجل يعرض التقييم، فنُبطل ذاكرته حتى يظهر فوراً.
      ref.invalidate(rideHistoryProvider);

      final l10n = L10n.of(context);
      final tipText = _tip > 0
          ? l10n.ratingSentTipSuffix(formatMoney(_tip), l10n.currency)
          : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.ratingSent(_rating)}$tipText')),
      );
      context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).ratingFailed)),
      );
    }
  }
}

// ─────────────── سطر في ملخص الأجرة ───────────────
class _FareRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? highlight;

  const _FareRow({required this.label, required this.value, this.highlight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: highlight ?? MishwarakColors.lightTextMuted,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: highlight,
          ),
        ),
      ],
    );
  }
}

// ─────────────── وسم قابل للاختيار ───────────────
class _TagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TagChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected ? MishwarakColors.primary : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? MishwarakColors.primary : theme.dividerColor,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────── زر إكرامية ───────────────
class _TipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected ? MishwarakColors.primary : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? MishwarakColors.primary : theme.dividerColor,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: selected ? Colors.white : theme.colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
