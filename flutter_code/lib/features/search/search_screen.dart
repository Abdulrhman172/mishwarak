// ═══════════════════════════════════════════════════════════════
// search_screen.dart - اختيار الوجهة (بحث + محفوظة + أخيرة)
// ═══════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/location/location_provider.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../profile/data/profile_repository.dart';
import '../ride/data/ride_repository.dart';
import 'data/geocoding_service.dart';

class SearchScreen extends ConsumerStatefulWidget {
  /// فئة مركبة مُفضّلة قادمة من اختصارات الشاشة الرئيسية.
  final String? preferredCategory;

  const SearchScreen({super.key, this.preferredCategory});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _query = TextEditingController();

  /// يؤخّر البحث حتى يتوقّف المستخدم عن الكتابة.
  ///
  /// بدونه يُطلق كل حرف عملية geocoding — وهي استدعاء لخدمة النظام
  /// لا حساب محلي، فتتزاحم النتائج ويصل أبطأها أخيراً فيظهر خطأً.
  Timer? _debounce;
  int _searchToken = 0;

  List<PlaceResult> _results = const [];
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _query.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.removeListener(_onQueryChanged);
    _query.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    setState(() {});
    _debounce?.cancel();

    final text = _query.text.trim();
    if (text.length < 3 || !GeocodingService.isSupported) {
      if (_results.isNotEmpty) setState(() => _results = const []);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 450), () => _search(text));
  }

  Future<void> _search(String text) async {
    // رمز لكل بحث: نتجاهل نتيجة بحث سبقه بحث أحدث.
    final token = ++_searchToken;
    setState(() => _searching = true);

    final near = ref.read(locationProvider).valueOrNull;
    final results = await ref.read(geocodingServiceProvider).search(
          text,
          nearLat: near?.lat,
          nearLng: near?.lng,
        );

    if (!mounted || token != _searchToken) return;
    setState(() {
      _results = results;
      _searching = false;
    });
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
        if (widget.preferredCategory != null)
          'category': widget.preferredCategory!,
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
              suffixIcon: _searching
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : typed.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: _query.clear,
                        ),
            ),
            onSubmitted: (_) => _submitTyped(),
          ),

          // ═══ نتائج البحث الجغرافي ═══
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 10),
            for (final place in _results)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: MishwarakColors.primary,
                  child: Icon(Icons.place, color: Colors.white, size: 18),
                ),
                title: Text(place.name),
                subtitle: Text(
                  place.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => _pick(
                  name: place.name,
                  address: place.address,
                  lat: place.lat,
                  lng: place.lng,
                ),
              ),
          ]
          // ═══ استخدام النص كما هو ═══
          // متاح حين لا يدعم النظام البحث الجغرافي (الويب) أو حين لا
          // يجد نتيجة — لكن الأجرة حينها تقديرية، ونقول ذلك صراحةً
          // بدل تمرير إحداثيات (0,0) بصمت.
          else if (typed.isNotEmpty && !_searching) ...[
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: MishwarakColors.primary,
                child: Icon(Icons.place, color: Colors.white, size: 18),
              ),
              title: Text(typed),
              subtitle: Text(
                GeocodingService.isSupported
                    ? l10n.useAsDestination
                    : l10n.searchOnWebUnsupported,
              ),
              isThreeLine: !GeocodingService.isSupported,
              onTap: _submitTyped,
            ),
            if (typed.length >= 3 && GeocodingService.isSupported)
              _Hint(l10n.searchNoResults),
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
                      // ملخّص السجل لا يحمل إحداثيات، فنبحث عن العنوان
                      // من جديد بدل تمرير أصفار.
                      onTap: () => _resolveThenPick(r.toAddress),
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

    // إن كانت هناك نتيجة جغرافية جاهزة فهي الأدقّ.
    if (_results.isNotEmpty) {
      final best = _results.first;
      _pick(
        name: typed,
        address: best.address,
        lat: best.lat,
        lng: best.lng,
      );
      return;
    }

    _resolveThenPick(typed);
  }

  /// يحاول إيجاد إحداثيات العنوان قبل الانتقال.
  ///
  /// عند الفشل ننتقل بإحداثيات صفرية مع تنبيه أن الأجرة تقديرية —
  /// أفضل من منع الراكب من الطلب، وأصدق من إخفاء الأمر.
  Future<void> _resolveThenPick(String address) async {
    final l10n = L10n.of(context);
    final near = ref.read(locationProvider).valueOrNull;

    setState(() => _searching = true);
    final found = await ref.read(geocodingServiceProvider).search(
          address,
          nearLat: near?.lat,
          nearLng: near?.lng,
          limit: 1,
        );
    if (!mounted) return;
    setState(() => _searching = false);

    if (found.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.destinationNeedsLocation)),
        );
      _pick(name: address, address: address, lat: 0, lng: 0);
      return;
    }

    _pick(
      name: address,
      address: found.first.address,
      lat: found.first.lat,
      lng: found.first.lng,
    );
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
