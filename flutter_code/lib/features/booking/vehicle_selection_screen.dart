// ═══════════════════════════════════════════════════════════════
// vehicle_selection_screen.dart - شاشة اختيار نوع المركبة
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/location/location_provider.dart';
import '../../core/location/location_service.dart';
import '../../l10n/app_localizations.dart';
import 'data/fare_calculator.dart';
import '../../shared/widgets/map_view.dart';
import '../../shared/widgets/route_dots.dart';
import '../ride/data/ride_repository.dart';
import 'data/vehicle_type_repository.dart';
import 'models/vehicle_type.dart';

class VehicleSelectionScreen extends ConsumerStatefulWidget {
  final String destName;
  final String destAddress;
  final double destLat;
  final double destLng;

  const VehicleSelectionScreen({
    super.key,
    required this.destName,
    required this.destAddress,
    required this.destLat,
    required this.destLng,
  });

  @override
  ConsumerState<VehicleSelectionScreen> createState() =>
      _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState
    extends ConsumerState<VehicleSelectionScreen> {
  int _selectedIndex = 1; // "مريح" افتراضياً (كما في التصميم)
  String _paymentMethod = 'wallet';
  bool _isRequesting = false;

  /// المسافة بين موقع الراكب والوجهة — أساس حساب الأجرة.
  ///
  /// تعود صفراً قبل وصول الموقع أو حين تكون الوجهة بلا إحداثيات،
  /// فتُعرض الأسعار الأساسية دون أجرة مسافة.
  double get _tripDistanceKm {
    final loc = ref.read(locationProvider).valueOrNull;
    if (loc == null || widget.destLat == 0 || widget.destLng == 0) return 0;

    return LocationService.distanceKm(
      startLat: loc.lat,
      startLng: loc.lng,
      endLat: widget.destLat,
      endLng: widget.destLng,
    );
  }

  /// ينشئ الرحلة في القاعدة ثم ينتقل لشاشة البحث عن سائق.
  Future<void> _confirm(VehicleType vehicle) async {
    setState(() => _isRequesting = true);

    // الموقع الحقيقي إن توفّر، وإلا مركز عدن حتى لا يفشل الطلب.
    final loc = ref.read(locationProvider).valueOrNull;
    final fare = FareCalculator.estimate(
      vehicle: vehicle,
      distanceKm: _tripDistanceKm,
    );

    try {
      final rideId = await ref.read(rideRepositoryProvider).requestRide(
            vehicleTypeId: vehicle.id,
            pickupAddress: loc?.label ?? L10n.of(context).myLocation,
            pickupLat: loc?.lat ?? 12.7794,
            pickupLng: loc?.lng ?? 45.0367,
            destAddress: widget.destAddress.isEmpty
                ? widget.destName
                : widget.destAddress,
            destLat: widget.destLat,
            destLng: widget.destLng,
            estimatedFare: fare.total,
            baseFare: fare.baseFare,
            distanceFare: fare.distanceFare,
            distanceKm: fare.distanceKm,
            paymentMethod: _paymentMethod,
          );

      if (!mounted) return;
      context.push('${AppRoutes.finding}?ride=$rideId');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).requestFailed)),
      );
    } finally {
      if (mounted) setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final vehiclesAsync = ref.watch(vehicleTypesProvider);
    final vehicles = vehiclesAsync.valueOrNull ?? const <VehicleType>[];

    // نراقب الموقع هنا ليُعاد الحساب فور وصوله وتتحدّث الأسعار.
    ref.watch(locationProvider);
    final distanceKm = _tripDistanceKm;

    // القائمة تصل غير متزامنة، فقد يتجاوز الفهرس الافتراضي طولها.
    final selectedIndex =
        vehicles.isEmpty ? 0 : _selectedIndex.clamp(0, vehicles.length - 1);
    final selected = vehicles.isEmpty ? null : vehicles[selectedIndex];

    return Scaffold(
      body: Stack(
        children: [
          // ═══════════════ الخريطة ═══════════════
          const MapView(placeholderIcon: Icons.route_outlined),

          // ═══════════════ الشريط العلوي ═══════════════
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  // زر الرجوع
                  _CircleButton(
                    icon: Icons.arrow_forward, // RTL: للخلف
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  // بطاقة المسار
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const RouteDots(),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ref
                                          .watch(locationProvider)
                                          .valueOrNull
                                          ?.label ??
                                      l10n.myLocation,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.destName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ═══════════════ Bottom Sheet ═══════════════
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.68,
              ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // العنوان + حجز مسبق
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.chooseVehicle,
                                  style: theme.textTheme.headlineMedium),
                              const SizedBox(height: 2),
                              Text(
                                vehiclesAsync.isLoading
                                    ? l10n.loadingOptions
                                    : distanceKm > 0
                                        ? l10n.optionsWithDistance(
                                            vehicles.length,
                                            distanceKm.toStringAsFixed(1),
                                          )
                                        : l10n.optionsCount(vehicles.length),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: MishwarakColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _ScheduleButton(onTap: () {}),
                      ],
                    ),
                  ),

                  // قائمة المركبات
                  Flexible(
                    child: vehiclesAsync.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: vehicles.length,
                            itemBuilder: (context, i) => _VehicleCard(
                              vehicle: vehicles[i],
                              fare: FareCalculator.estimate(
                                vehicle: vehicles[i],
                                distanceKm: distanceKm,
                              ),
                              selected: selectedIndex == i,
                              onTap: () => setState(() => _selectedIndex = i),
                            ),
                          ),
                  ),

                  // الدفع + زر التأكيد
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: theme.dividerColor),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _PaymentChip(
                              icon: Icons.account_balance_wallet_outlined,
                              label: l10n.wallet,
                              iconColor: MishwarakColors.primary,
                              selected: _paymentMethod == 'wallet',
                              onTap: () =>
                                  setState(() => _paymentMethod = 'wallet'),
                            ),
                            const SizedBox(width: 8),
                            _PaymentChip(
                              icon: Icons.payments_outlined,
                              label: l10n.cash,
                              iconColor: MishwarakColors.success,
                              selected: _paymentMethod == 'cash',
                              onTap: () =>
                                  setState(() => _paymentMethod = 'cash'),
                            ),
                            const SizedBox(width: 8),
                            _PromoChip(onTap: () {}),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: selected == null || _isRequesting
                                ? null
                                : () => _confirm(selected),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MishwarakColors.primary,
                              disabledBackgroundColor: theme.dividerColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              ),
                            ),
                            // الأسماء الطويلة (مثل "سائقة للنساء") مع السعر
                            // تتجاوز عرض الزر على الشاشات الضيقة، لذا Flexible.
                            child: _isRequesting
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    selected == null
                                        ? l10n.loading
                                        : l10n.orderVehicle(selected.nameAr),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (selected != null)
                                  Flexible(
                                    child: Text(
                                      '  · ${formatMoney(selected.price)} ر.ي',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
}

/// أيقونة تمثّل فئة المركبة (بدل رسوم SVG).
IconData _iconForCategory(VehicleCategory c) {
  switch (c) {
    case VehicleCategory.economy:
      return Icons.directions_car;
    case VehicleCategory.comfort:
      return Icons.local_taxi;
    case VehicleCategory.xl:
      return Icons.airport_shuttle;
    case VehicleCategory.women:
      return Icons.female;
    case VehicleCategory.vip:
      return Icons.workspace_premium;
  }
}

// ═══════════════ بطاقة المركبة ═══════════════
class _VehicleCard extends StatelessWidget {
  final VehicleType vehicle;

  /// الأجرة المحسوبة لهذه المركبة على مسافة الرحلة.
  final FareBreakdown fare;

  final bool selected;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.vehicle,
    required this.fare,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? MishwarakColors.primary.withOpacity(0.10)
              : Colors.transparent,
          border: Border.all(
            color: selected ? MishwarakColors.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // أيقونة المركبة
            Container(
              width: 72,
              height: 52,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _iconForCategory(vehicle.category),
                size: 30,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 12),
            // الاسم + الوصف
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          vehicle.nameAr,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (vehicle.badgeAr != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEC4899),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            vehicle.badgeAr!,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '🕐 ${vehicle.etaMinutes} دقائق · ${vehicle.descriptionAr}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: MishwarakColors.lightTextMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // السعر
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatMoney(fare.total),
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                if (vehicle.oldPrice != null)
                  Text(
                    formatMoney(vehicle.oldPrice!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: MishwarakColors.lightTextLight,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                Text(
                  L10n.of(context).currency,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: MishwarakColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════ زر دائري (رجوع) ═══════════════
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardColor,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 22, color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}

// ═══════════════ زر حجز مسبق ═══════════════
class _ScheduleButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ScheduleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.schedule, size: 14, color: MishwarakColors.primary),
      label: Text(
        L10n.of(context).schedule,
        style: theme.textTheme.labelMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: BorderSide(color: theme.dividerColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

// ═══════════════ شريحة طريقة دفع ═══════════════
class _PaymentChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentChip({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? MishwarakColors.primary.withOpacity(0.15)
                : theme.colorScheme.surface,
            border: Border.all(
              color: selected ? MishwarakColors.primary : theme.dividerColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════ شريحة كوبون ═══════════════
class _PromoChip extends StatelessWidget {
  final VoidCallback onTap;
  const _PromoChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: MishwarakColors.accent.withOpacity(0.15),
          border: Border.all(color: MishwarakColors.accent.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_offer_outlined,
                size: 16, color: MishwarakColors.accent),
            const SizedBox(width: 6),
            Text(
              L10n.of(context).coupon,
              style: theme.textTheme.labelMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
