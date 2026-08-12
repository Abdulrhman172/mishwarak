// ═══════════════════════════════════════════════════════════════
// history_screen.dart - سجل الرحلات السابقة
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// رحلة واحدة في السجل.
class _Trip {
  final String date;
  final String time;
  final String from;
  final String to;
  final int price;
  final bool cancelled;
  final int? rating;

  const _Trip({
    required this.date,
    required this.time,
    required this.from,
    required this.to,
    required this.price,
    this.cancelled = false,
    this.rating,
  });
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const _trips = [
    _Trip(date: 'اليوم', time: '09:24', from: 'كريتر', to: 'جامعة عدن', price: 3800, rating: 5),
    _Trip(date: 'أمس', time: '18:12', from: 'التواهي', to: 'المعلا', price: 2500, rating: 4),
    _Trip(date: 'أمس', time: '10:30', from: 'خور مكسر', to: 'كريتر', price: 3200, rating: 5),
    _Trip(date: '4 يوليو', time: '14:00', from: 'الملاح', to: 'جامعة عدن', price: 4500, cancelled: true),
    _Trip(date: '3 يوليو', time: '08:00', from: 'المنزل', to: 'العمل', price: 2100, rating: 5),
  ];

  static const _stats = [
    ('رحلات', '47'),
    ('كيلومتر', '312'),
    ('توفير', '4.2K'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('رحلاتي'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // ═══ إحصائيات ═══
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                for (final (label, value) in _stats) ...[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Column(
                        children: [
                          Text(
                            value,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontSize: 20,
                              color: MishwarakColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: MishwarakColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (label != _stats.last.$1) const SizedBox(width: 10),
                ],
              ],
            ),
          ),

          // ═══ قائمة الرحلات ═══
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              itemCount: _trips.length,
              itemBuilder: (context, i) {
                final trip = _trips[i];
                // عنوان التاريخ يظهر مرة واحدة لكل يوم
                final showDate = i == 0 || _trips[i - 1].date != trip.date;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDate)
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, i == 0 ? 4 : 16, 4, 8),
                        child: Text(
                          trip.date,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: MishwarakColors.lightTextMuted,
                          ),
                        ),
                      ),
                    _TripCard(trip: trip),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── بطاقة رحلة ───────────────
class _TripCard extends StatelessWidget {
  final _Trip trip;

  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // خريطة مصغّرة
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isDark
                  ? MishwarakColors.mapBgDark
                  : MishwarakColors.mapBgLight,
            ),
            child: const Icon(
              Icons.map_outlined,
              color: MishwarakColors.lightTextLight,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // التفاصيل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      trip.time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: MishwarakColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (trip.cancelled)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: MishwarakColors.danger.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ملغاة',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: MishwarakColors.danger,
                          ),
                        ),
                      ),
                    if (trip.rating != null) ...[
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: MishwarakColors.accent,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${trip.rating}.0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                _Endpoint(label: trip.from, isDestination: false),
                const SizedBox(height: 4),
                _Endpoint(label: trip.to, isDestination: true),
              ],
            ),
          ),

          // السعر
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                trip.price.toString().replaceAllMapped(
                      RegExp(r'(\d)(?=(\d{3})+$)'),
                      (m) => '${m[1]},',
                    ),
                style: theme.textTheme.headlineSmall,
              ),
              Text(
                'ر.ي',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: MishwarakColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────── نقطة انطلاق أو وجهة ───────────────
class _Endpoint extends StatelessWidget {
  final String label;
  final bool isDestination;

  const _Endpoint({required this.label, required this.isDestination});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: isDestination
                ? MishwarakColors.danger
                : MishwarakColors.success,
            borderRadius: BorderRadius.circular(isDestination ? 1 : 3),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: isDestination ? FontWeight.w700 : FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
