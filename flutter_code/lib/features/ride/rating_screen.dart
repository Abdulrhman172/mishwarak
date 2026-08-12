// ═══════════════════════════════════════════════════════════════
// rating_screen.dart - نهاية الرحلة وتقييم السائق
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/driver_avatar.dart';
import '../../shared/widgets/star_rating.dart';
import 'models/driver.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  static const _driver = DriversRepository.mockDriver;

  static const _goodTags = [
    'قيادة آمنة',
    'سيارة نظيفة',
    'كلام لطيف',
    'في الموعد',
    'طريق سريع',
    'موسيقى جيدة',
  ];
  static const _badTags = [
    'قيادة متهورة',
    'سيارة متسخة',
    'غير مهذب',
    'تأخر كثيراً',
  ];
  static const _tips = [0, 200, 500, 1000];

  int _rating = 0;
  final Set<String> _selectedTags = {};
  int _tip = 0;

  /// الوسوم تتبدّل حسب التقييم: 4+ إيجابية، أقل سلبية.
  List<String> get _currentTags {
    if (_rating == 0) return const [];
    return _rating >= 4 ? _goodTags : _badTags;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSubmit = _rating > 0;

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
                        color: MishwarakColors.success.withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: MishwarakColors.success,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('وصلت بسلامة!', style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      'نتمنى لك يوماً سعيداً 🌟',
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
                          const _FareRow(label: 'السعر الأساسي', value: '3,500 ر.ي'),
                          const SizedBox(height: 8),
                          const _FareRow(label: 'المسافة (7.2 كم)', value: '+800'),
                          const SizedBox(height: 8),
                          const _FareRow(
                            label: 'خصم كوبون',
                            value: '-500',
                            highlight: MishwarakColors.success,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 2),
                            child: Divider(height: 1, color: theme.dividerColor),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('الإجمالي', style: theme.textTheme.labelLarge),
                              RichText(
                                text: TextSpan(
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontSize: 20,
                                    color: MishwarakColors.primary,
                                  ),
                                  children: const [
                                    TextSpan(text: '3,800 '),
                                    TextSpan(
                                      text: 'ر.ي',
                                      style: TextStyle(
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
                      initials: _driver.name.characters.first,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'كيف كانت رحلتك مع ${_driver.name.split(' ').first}؟',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 14),
                    StarRatingInput(
                      value: _rating,
                      onChanged: (v) => setState(() {
                        // تبديل نوع الوسوم يُلغي الاختيار السابق
                        final flipped = (v >= 4) != (_rating >= 4);
                        _rating = v;
                        if (flipped) _selectedTags.clear();
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
                              _rating >= 4 ? 'ما الذي أعجبك؟' : 'ما الذي أزعجك؟',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: MishwarakColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final tag in _currentTags)
                                  _TagChip(
                                    label: tag,
                                    selected: _selectedTags.contains(tag),
                                    onTap: () => setState(() {
                                      _selectedTags.contains(tag)
                                          ? _selectedTags.remove(tag)
                                          : _selectedTags.add(tag);
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
                              'أضف إكرامية للسائق',
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
                                      label: t == 0 ? 'لا شكراً' : '$t',
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
                    shadowColor: MishwarakColors.primary.withOpacity(0.4),
                  ),
                  child: const Text('إرسال التقييم'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    // TODO: إرسال التقييم إلى الـ API
    final tipText = _tip > 0 ? ' مع إكرامية $_tip ر.ي' : '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('شكراً لك! تم إرسال تقييمك ($_rating نجوم)$tipText')),
    );
    context.go(AppRoutes.home);
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
