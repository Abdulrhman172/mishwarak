// ═══════════════════════════════════════════════════════════════
// active_ride_screen.dart - شاشة الرحلة الجارية (تتبّع السائق)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/launchers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/driver_avatar.dart';
import '../../shared/widgets/emergency_sheet.dart';
import '../../shared/widgets/map_view.dart';
import '../../shared/widgets/star_rating.dart';
import 'data/ride_repository.dart';

class ActiveRideScreen extends ConsumerWidget {
  final String rideId;

  const ActiveRideScreen({super.key, required this.rideId});

  /// نص الحالة مشتقّ من حالة الرحلة في القاعدة لا من مؤقّت وهمي.
  static String _statusLabel(L10n l10n, String status) => switch (status) {
        'driver_assigned' => l10n.statusAssigned,
        'arriving' => l10n.statusArriving,
        'arrived' => l10n.statusArrived,
        'on_trip' => l10n.statusOnTrip,
        'completed' => l10n.statusCompleted,
        'cancelled' => l10n.statusCancelled,
        _ => l10n.statusRequested,
      };

  /// علامات الخريطة: السائق ونقطتا الانطلاق والوجهة.
  ///
  /// قبل بدء الرحلة نركّز على نقطة الالتقاء، وبعدها على الوجهة —
  /// وهي المعلومة التي تهمّ الراكب في كل مرحلة.
  static Set<Marker> _markers(RideDetails? ride, RideDriver? driver) {
    if (ride == null) return const {};

    return {
      if (driver?.lat != null && driver?.lng != null)
        Marker(
          markerId: const MarkerId('driver'),
          position: LatLng(driver!.lat!, driver.lng!),
          infoWindow: InfoWindow(title: driver.fullName, snippet: driver.carModel),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(ride.pickupLat, ride.pickupLng),
        infoWindow: InfoWindow(title: ride.pickupAddress),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(ride.destLat, ride.destLng),
        infoWindow: InfoWindow(title: ride.destAddress),
      ),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final rideAsync = ref.watch(rideStreamProvider(rideId));
    final ride = rideAsync.valueOrNull;

    // تنتقل لشاشة التقييم فور اكتمال الرحلة في القاعدة.
    ref.listen(rideStreamProvider(rideId), (_, next) {
      final r = next.valueOrNull;
      if (r == null) return;
      if (r.isCompleted) {
        context.pushReplacement('${AppRoutes.rating}?ride=$rideId');
      } else if (r.isCancelled) {
        context.go(AppRoutes.home);
      }
    });

    final driver = ride?.driverId == null
        ? null
        : ref.watch(rideDriverProvider(ride!.driverId!)).valueOrNull;

    // قبل الالتقاء يهمّ الراكب أين السائق؛ بعده تهمّه الوجهة.
    final focus = ride == null
        ? kAdenCenter
        : ride.isArriving && driver?.lat != null
            ? LatLng(driver!.lat!, driver.lng!)
            : LatLng(ride.destLat, ride.destLng);

    return Scaffold(
      body: Stack(
        children: [
          MapView(
            placeholderIcon: Icons.navigation_outlined,
            center: focus,
            zoom: 15,
            bottomPadding: 300,
            markers: _markers(ride, driver),
          ),

          // ═══════════════ شارة الحالة ═══════════════
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _BlinkingDot(),
                    const SizedBox(width: 8),
                    Text(
                      _statusLabel(l10n, ride?.status ?? 'requested'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ═══════════════ أزرار جانبية ═══════════════
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 72, right: 12),
                child: Column(
                  children: [
                    _RoundAction(
                      icon: Icons.share_outlined,
                      color: MishwarakColors.primary,
                      background: theme.cardColor,
                      onTap: () => _shareTrip(context, l10n, driver),
                    ),
                    const SizedBox(height: 8),
                    _RoundAction(
                      icon: Icons.shield_outlined,
                      color: Colors.white,
                      background: MishwarakColors.danger,
                      // نمرّر موقع السائق: هو الموقع الحقيقي للراكب
                      // أثناء الرحلة، وهو ما يجب أن تحمله رسالة النجدة.
                      onTap: () => showEmergencySheet(
                        context,
                        lat: driver?.lat ?? ride?.pickupLat,
                        lng: driver?.lng ?? ride?.pickupLng,
                      ),
                    ),
                    // الإلغاء متاح ما دامت الرحلة لم تبدأ.
                    if (ride != null && ride.isArriving) ...[
                      const SizedBox(height: 8),
                      _RoundAction(
                        icon: Icons.close_rounded,
                        color: MishwarakColors.danger,
                        background: theme.cardColor,
                        onTap: () => _confirmCancel(context, ref, rideId),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // ═══════════════ Bottom Sheet ═══════════════
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
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
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // ═══ بطاقة السائق ═══
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: driver == null
                        ? Row(
                            children: [
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                l10n.loadingDriver,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: MishwarakColors.lightTextMuted,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              DriverAvatar(
                                size: 60,
                                initials: driver.fullName.isEmpty
                                    ? '؟'
                                    : driver.fullName.characters.first,
                                verified: true,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      driver.fullName,
                                      style: theme.textTheme.headlineSmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        StarRating(
                                          value: driver.rating,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${driver.rating}',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            l10n.driverTripsCount(driver.completedTrips),
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: MishwarakColors
                                                  .lightTextMuted,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              _RoundAction(
                                icon: Icons.chat_bubble_outline_rounded,
                                color: MishwarakColors.primary,
                                background:
                                    MishwarakColors.primary.withValues(alpha: 0.12),
                                border: true,
                                onTap: () =>
                                    _snack(context, l10n.chatComingSoon),
                              ),
                              const SizedBox(width: 8),
                              _RoundAction(
                                icon: Icons.phone,
                                color: Colors.white,
                                background: MishwarakColors.primary,
                                // اتصال فعلي؛ كان يعرض SnackBar فقط
                                // رغم أن رقم السائق متاح في البيانات.
                                onTap: () => Launchers.call(
                                  context,
                                  driver.phone,
                                ),
                              ),
                            ],
                          ),
                  ),

                  // ═══ تفاصيل السيارة ═══
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.directions_car_filled,
                          size: 34,
                          color: MishwarakColors.secondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                driver?.carModel ?? '—',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                driver?.carColor ?? '',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: MishwarakColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // لوحة الترخيص
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            driver?.plateNumber ?? '—',
                            style: TextStyle(
                              color: theme.scaffoldBackgroundColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ═══ المسار والسعر ═══
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // نقاط المسار بارتفاع أكبر
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: MishwarakColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 20,
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                color: theme.dividerColor,
                              ),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: MishwarakColors.danger,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                ride?.pickupAddress ?? '—',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                ride?.destAddress ?? '—',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // السعر
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.fare,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: MishwarakColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                style: theme.textTheme.headlineSmall,
                                children: [
                                  TextSpan(
                                    text:
                                        '${formatMoney(ride?.fare ?? 0)} ',
                                  ),
                                  TextSpan(
                                    text: l10n.currency,
                                    style: const TextStyle(
                                      fontSize: 10,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ينسخ تفاصيل الرحلة لمشاركتها مع شخص موثوق.
  ///
  /// النسخ للحافظة لا مشاركة نظامية: `share_plus` ليست ضمن اعتماديات
  /// المشروع، والنسخ يعمل على كل المنصّات بما فيها الويب. المهم أن
  /// يحصل المستخدم على النص فعلاً بدل رسالة "تمت المشاركة" الكاذبة.
  static Future<void> _shareTrip(
    BuildContext context,
    L10n l10n,
    RideDriver? driver,
  ) async {
    if (driver == null) return;

    await Clipboard.setData(
      ClipboardData(
        text: l10n.shareTripText(
          driver.fullName,
          driver.carModel,
          driver.plateNumber,
        ),
      ),
    );
    if (!context.mounted) return;
    _snack(context, l10n.shareTripCopied);
  }

  /// يؤكّد إلغاء الرحلة ثم ينفّذه.
  static Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    String rideId,
  ) async {
    final l10n = L10n.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cancelRide),
        content: Text(l10n.cancelRideConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.keepRide),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: MishwarakColors.danger,
              minimumSize: const Size(0, 44),
            ),
            child: Text(l10n.cancelRide),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(rideRepositoryProvider).cancelRide(rideId);
      // لا ننتقل من هنا: مستمع `build` يتابع الحالة وينقل للرئيسية.
    } catch (_) {
      if (context.mounted) _snack(context, l10n.cancelRideFailed);
    }
  }

  static void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }
}

// ─────────────── نقطة خضراء وامضة ───────────────
class _BlinkingDot extends StatefulWidget {
  const _BlinkingDot();

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0.3).animate(_c),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: MishwarakColors.success,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ─────────────── زر دائري ───────────────
class _RoundAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;
  final bool border;

  const _RoundAction({
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: CircleBorder(
        side: border
            ? BorderSide(
                color: MishwarakColors.primary.withValues(alpha: 0.3),
                width: 1.5,
              )
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
