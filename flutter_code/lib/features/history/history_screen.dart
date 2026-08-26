// ═══════════════════════════════════════════════════════════════
// history_screen.dart - سجل الرحلات السابقة
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../core/router/app_router.dart';
import '../ride/data/ride_repository.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(rideHistoryProvider);
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myTrips),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(rideHistoryProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: history.when(
        data: (trips) =>
            trips.isEmpty ? const _EmptyHistory() : _HistoryList(trips: trips),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _EmptyHistory(message: l10n.tripsFailed),
      ),
    );
  }
}

// ─────────────── الإحصائيات + القائمة ───────────────
class _HistoryList extends StatelessWidget {
  final List<RideSummary> trips;

  const _HistoryList({required this.trips});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // الرحلات المكتملة فقط تدخل في الإحصائيات.
    final completed = trips.where((t) => !t.cancelled).toList();
    final totalFare = completed.fold<int>(0, (sum, t) => sum + t.fare);
    final rated = completed.where((t) => t.rating != null).toList();
    final avgRating = rated.isEmpty
        ? null
        : rated.fold<int>(0, (s, t) => s + t.rating!) / rated.length;

    final l10n = L10n.of(context);
    final stats = <(String, String)>[
      (l10n.tripsCount, '${completed.length}'),
      (l10n.totalSpent, formatMoney(totalFare)),
      (l10n.avgRating, avgRating == null ? '—' : avgRating.toStringAsFixed(1)),
    ];

    return Column(
      children: [
        // ═══ إحصائيات ═══
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              for (var i = 0; i < stats.length; i++) ...[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      children: [
                        Text(
                          stats[i].$2,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontSize: 20,
                            color: MishwarakColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stats[i].$1,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: MishwarakColors.lightTextMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                if (i < stats.length - 1) const SizedBox(width: 10),
              ],
            ],
          ),
        ),

        // ═══ قائمة الرحلات ═══
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            itemCount: trips.length,
            itemBuilder: (context, i) {
              final trip = trips[i];
              final day = formatDayLabel(context, trip.requestedAt);
              // عنوان التاريخ يظهر مرة واحدة لكل يوم
              final showDate = i == 0 ||
                  formatDayLabel(context, trips[i - 1].requestedAt) != day;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showDate)
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, i == 0 ? 4 : 16, 4, 8),
                      child: Text(
                        day,
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
    );
  }
}

// ─────────────── لا توجد رحلات ───────────────
class _EmptyHistory extends StatelessWidget {
  /// النص الافتراضي يُبنى في build لأنه يحتاج context للترجمة.
  final String? message;

  const _EmptyHistory({this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_taxi_outlined,
            size: 44,
            color: MishwarakColors.lightTextMuted,
          ),
          const SizedBox(height: 12),
          Text(
            message ?? L10n.of(context).noTripsYet,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: MishwarakColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── بطاقة رحلة ───────────────
class _TripCard extends StatelessWidget {
  final RideSummary trip;

  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = L10n.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: _details(context, theme, isDark),
          ),
          // رحلة مكتملة بلا تقييم: الطريق الوحيد لتقييمها كان شاشة
          // التقييم التي تظهر مرة واحدة فور انتهاء الرحلة — فإن أغلقها
          // الراكب ضاعت الفرصة نهائياً.
          if (trip.isRateable)
            InkWell(
              onTap: () => context.push('${AppRoutes.rating}?ride=${trip.id}'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: MishwarakColors.accent.withValues(alpha: 0.10),
                  border: Border(
                    top: BorderSide(color: theme.dividerColor),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_outline_rounded,
                      size: 16,
                      color: MishwarakColors.accent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.rateThisTrip,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _details(BuildContext context, ThemeData theme, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // خريطة مصغّرة
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                isDark ? MishwarakColors.mapBgDark : MishwarakColors.mapBgLight,
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
                    formatTime(trip.requestedAt),
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
                        color: MishwarakColors.danger.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        L10n.of(context).cancelledTrip,
                        style: const TextStyle(
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
              _Endpoint(label: trip.fromAddress, isDestination: false),
              const SizedBox(height: 4),
              _Endpoint(label: trip.toAddress, isDestination: true),
            ],
          ),
        ),

        // السعر
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatMoney(trip.fare),
              style: theme.textTheme.headlineSmall,
            ),
            Text(
              L10n.of(context).currency,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: MishwarakColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ],
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
