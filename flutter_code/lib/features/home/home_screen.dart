// ═══════════════════════════════════════════════════════════════
// home_screen.dart - الشاشة الرئيسية (خريطة + Bottom Sheet)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/location/location_provider.dart';
import '../../core/location/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/glass_button.dart';
import '../../shared/widgets/map_view.dart';
import '../../shared/widgets/saved_place_card.dart';
import '../../shared/widgets/service_shortcut.dart';
import '../profile/data/profile_repository.dart';
import '../wallet/data/wallet_repository.dart';
import 'widgets/home_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  /// يبقى `null` عندما تُعرض الخريطة البديلة (بلا مفتاح API).
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // نطلب الموقع بعد أول إطار — لا أثناء البناء.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).locate();
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  /// يحدّد الموقع ويحرّك الكاميرا إليه، ويعرض سبب الفشل إن حدث.
  Future<void> _goToMyLocation() async {
    final notifier = ref.read(locationProvider.notifier);
    await notifier.locate();
    if (!mounted) return;

    final state = ref.read(locationProvider);
    state.when(
      data: (loc) {
        if (loc == null) return;
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(loc.lat, loc.lng), 16),
        );
      },
      loading: () {},
      error: (_, __) {
        final isDeniedForever =
            notifier.lastStatus == LocationStatus.deniedForever;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_locationErrorMessage(context, notifier.lastStatus)),
            action: isDeniedForever
                ? SnackBarAction(
                    label: L10n.of(context).settings,
                    onPressed: LocationService.openSettings,
                  )
                : null,
          ),
        );
      },
    );
  }

  /// يترجم [LocationStatus] لرسالة قابلة للعرض — الحالة نفسها لا تحمل
  /// نصاً لأنها تُنتج في طبقة لا تعرف لغة المستخدم.
  static String _locationErrorMessage(BuildContext context, LocationStatus? status) {
    final l10n = L10n.of(context);
    return switch (status) {
      LocationStatus.serviceDisabled => l10n.locationServiceDisabled,
      LocationStatus.denied => l10n.locationDenied,
      LocationStatus.deniedForever => l10n.locationDeniedForever,
      _ => l10n.locationFailed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Scaffold(
      drawer: const HomeDrawer(),
      body: Builder(
        builder: (context) => Stack(
          children: [
            // ═══════════════ الخريطة ═══════════════
            // خريطة حقيقية عند توفّر المفتاح، وإلا بديل — راجع MapView.
            MapView(
              bottomPadding: 320,
              onMapCreated: (c) => _mapController = c,
            ),

            // ═══════════════ الشريط العلوي ═══════════════
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    // زر القائمة
                    GlassButton(
                      icon: Icons.menu_rounded,
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                    const Spacer(),
                    // شارة المحفظة
                    Consumer(
                      builder: (context, ref, _) {
                        final balance = ref.watch(walletBalanceProvider);
                        return GestureDetector(
                          onTap: () => context.push('${AppRoutes.home}/wallet'),
                          child: GlassPill(
                            icon: Icons.account_balance_wallet_outlined,
                            iconColor: MishwarakColors.primary,
                            child: RichText(
                              text: TextSpan(
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${balance.when(
                                      data: formatMoney,
                                      loading: () => '—',
                                      error: (_, __) => '—',
                                    )} ',
                                  ),
                                  TextSpan(
                                    text: l10n.currency,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: MishwarakColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ═══════════════ Floating Action Buttons ═══════════════
            Positioned(
              right: 12,
              bottom: 340,
              child: Column(
                children: [
                  GlassButton(
                    icon: Icons.my_location,
                    iconColor: MishwarakColors.primary,
                    onTap: _goToMyLocation,
                  ),
                  const SizedBox(height: 8),
                  GlassButton(
                    icon: Icons.shield_outlined,
                    iconColor: MishwarakColors.danger,
                    onTap: _showSosDialog,
                  ),
                ],
              ),
            ),

            // ═══════════════ Bottom Sheet ═══════════════
            DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.42,
              minChildSize: 0.15,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 32,
                        offset: const Offset(0, -8),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Handle
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

                          // ═══ التحية ═══
                          Consumer(
                            builder: (context, ref, _) {
                              final name = ref
                                  .watch(userProfileProvider)
                                  .valueOrNull
                                  ?.fullName
                                  .trim();
                              return Text(
                                (name != null && name.isNotEmpty)
                                    ? l10n.greeting(name)
                                    : l10n.welcome,
                                style: theme.textTheme.headlineLarge,
                              );
                            },
                          ),
                          const SizedBox(height: 2),
                          // يعرض الموقع الحقيقي فور وصوله، وإلا نص افتراضي.
                          Consumer(
                            builder: (context, ref, _) {
                              final loc = ref.watch(locationProvider);
                              return Row(
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    size: 13,
                                    color: loc.hasValue && loc.value != null
                                        ? MishwarakColors.primary
                                        : MishwarakColors.lightTextMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      loc.when(
                                        data: (l) => l?.label ?? l10n.whereTo,
                                        loading: () => l10n.locating,
                                        error: (_, __) => l10n.whereTo,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: MishwarakColors.lightTextMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 14),

                          // ═══ خانة البحث ═══
                          _SearchButton(
                            onTap: () => context.push('${AppRoutes.home}/search'),
                          ),
                          const SizedBox(height: 14),

                          // ═══ الأماكن المحفوظة ═══
                          // نعرض أول عنوانين فقط ليبقى زر "إضافة" ظاهراً.
                          Consumer(
                            builder: (context, ref, _) {
                              final places = ref
                                      .watch(savedPlacesProvider)
                                      .valueOrNull ??
                                  const <SavedPlace>[];
                              final shown = places.take(2).toList();
                              return Row(
                                children: [
                                  for (final place in shown) ...[
                                    Expanded(
                                      child: SavedPlaceCard(
                                        icon: switch (place.label) {
                                          'home' => Icons.home_outlined,
                                          'work' => Icons.work_outline,
                                          _ => Icons.place_outlined,
                                        },
                                        label: place.name,
                                        subtitle: place.address,
                                        onTap: () => context
                                            .push('${AppRoutes.home}/search'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                  Expanded(
                                    child: SavedPlaceCard(
                                      icon: Icons.add,
                                      label: l10n.add,
                                      subtitle: l10n.newPlace,
                                      isAdd: true,
                                      onTap: () => context
                                          .push('${AppRoutes.home}/profile'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 14),

                          // ═══ الخدمات السريعة ═══
                          GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.05,
                            children: [
                              ServiceShortcut(
                                icon: Icons.directions_car,
                                label: l10n.serviceEconomy,
                                color: MishwarakColors.secondary,
                              ),
                              ServiceShortcut(
                                icon: Icons.workspace_premium,
                                label: l10n.serviceVip,
                                color: MishwarakColors.accent,
                              ),
                              ServiceShortcut(
                                icon: Icons.female,
                                label: l10n.serviceWomen,
                                color: const Color(0xFFEC4899),
                              ),
                              ServiceShortcut(
                                icon: Icons.schedule,
                                label: l10n.schedule,
                                color: MishwarakColors.success,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSosDialog() {
    final l10n = L10n.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.emergencyTitle),
        content: Text(l10n.emergencyBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              // TODO: تفعيل الطوارئ
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: MishwarakColors.danger),
            child: Text(l10n.emergencyAction),
          ),
        ],
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.dividerColor, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: MishwarakColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.search,
                  color: MishwarakColors.primary,
                  size: 18,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    l10n.searchHint,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: MishwarakColors.lightTextMuted,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: MishwarakColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  l10n.bookNow,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
