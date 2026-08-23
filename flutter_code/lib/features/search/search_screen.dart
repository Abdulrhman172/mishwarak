// ═══════════════════════════════════════════════════════════════
// search_screen.dart - اختيار الوجهة (العناوين المحفوظة + الأخيرة)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../profile/data/profile_repository.dart';
import '../ride/data/ride_repository.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _query = TextEditingController();

  @override
  void initState() {
    super.initState();
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// ينتقل لاختيار المركبة حاملاً الوجهة في المسار.
  void _pick({
    required String name,
    required String address,
    required double lat,
    required double lng,
  }) {
    final uri = Uri(
      path: AppRoutes.vehicle,
      queryParameters: {
        'name': name,
        'addr': address,
        'lat': '$lat',
        'lng': '$lng',
      },
    );
    context.push(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final places = ref.watch(savedPlacesProvider);
    final history = ref.watch(rideHistoryProvider);
    final typed = _query.text.trim();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chooseDestination)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),
          TextField(
            controller: _query,
            autofocus: true,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.destinationHint,
              prefixIcon: const Icon(Icons.search),
            ),
            onSubmitted: (_) => _submitTyped(),
          ),

          // بلا خدمة بحث جغرافي بعد: نسمح باستخدام النص كوجهة مبدئية
          // حتى لا يتوقف المستخدم عند وجهة غير محفوظة.
          if (typed.isNotEmpty) ...[
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: MishwarakColors.primary,
                child: Icon(Icons.place, color: Colors.white, size: 18),
              ),
              title: Text(typed),
              subtitle: Text(l10n.useAsDestination),
              onTap: _submitTyped,
            ),
          ],

          // ═══ العناوين المحفوظة ═══
          const SizedBox(height: 18),
          Text(l10n.savedPlaces, style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          places.when(
            data: (list) => list.isEmpty
                ? _Hint(l10n.noSavedPlaces)
                : Column(
                    children: [
                      for (final p in list)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(switch (p.label) {
                            'home' => Icons.home_outlined,
                            'work' => Icons.work_outline,
                            _ => Icons.place_outlined,
                          }),
                          title: Text(p.name),
                          subtitle: Text(p.address),
                          trailing: const Icon(Icons.arrow_back, size: 18),
                          onTap: () => _pick(
                            name: p.name,
                            address: p.address,
                            lat: p.lat,
                            lng: p.lng,
                          ),
                        ),
                    ],
                  ),
            loading: () => const _Loading(),
            error: (_, __) => _Hint(l10n.savedPlacesFailed),
          ),

          // ═══ الوجهات الأخيرة ═══
          const SizedBox(height: 18),
          Text(l10n.recentDestinations, style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          history.when(
            data: (rides) {
              // نفس الوجهة قد تتكرر في السجل — نعرضها مرة واحدة.
              final seen = <String>{};
              final recent = <RideSummary>[];
              for (final r in rides) {
                if (r.toAddress.isNotEmpty && seen.add(r.toAddress)) {
                  recent.add(r);
                }
                if (recent.length == 5) break;
              }

              if (recent.isEmpty) return _Hint(l10n.noRecentTrips);

              return Column(
                children: [
                  for (final r in recent)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history),
                      title: Text(r.toAddress),
                      subtitle: Text(r.fromAddress),
                      trailing: const Icon(Icons.arrow_back, size: 18),
                      // السجل لا يحفظ إحداثيات الوجهة، فنمرّر العنوان فقط.
                      onTap: () => _pick(
                        name: r.toAddress,
                        address: r.toAddress,
                        lat: 0,
                        lng: 0,
                      ),
                    ),
                ],
              );
            },
            loading: () => const _Loading(),
            error: (_, __) => _Hint(l10n.historyFailed),
          ),
        ],
      ),
    );
  }

  void _submitTyped() {
    final typed = _query.text.trim();
    if (typed.isEmpty) return;
    _pick(name: typed, address: typed, lat: 0, lng: 0);
  }
}

class _Hint extends StatelessWidget {
  final String text;
  const _Hint(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: MishwarakColors.lightTextMuted),
        ),
      );
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Center(child: CircularProgressIndicator()),
      );
}
