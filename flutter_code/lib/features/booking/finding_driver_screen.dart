// ═══════════════════════════════════════════════════════════════
// finding_driver_screen.dart - شاشة البحث عن سائق (رادار متحرك)
// ═══════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/map_view.dart';
import '../ride/data/ride_repository.dart';

class FindingDriverScreen extends ConsumerStatefulWidget {
  final String rideId;

  const FindingDriverScreen({super.key, required this.rideId});

  @override
  ConsumerState<FindingDriverScreen> createState() =>
      _FindingDriverScreenState();
}

class _FindingDriverScreenState extends ConsumerState<FindingDriverScreen>
    with TickerProviderStateMixin {
  late final AnimationController _radar;
  late final AnimationController _dots;
  Timer? _noDriverTimer;
  bool _isCancelling = false;

  /// يصبح `true` إذا مضت مهلة دون تعيين سائق (لا سائق متاح لهذا النوع).
  bool _tookTooLong = false;

  @override
  void initState() {
    super.initState();

    _radar = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    _dots = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // بلا هذه المهلة تدور الشاشة إلى ما لا نهاية عندما لا يوجد سائق متاح.
    _noDriverTimer = Timer(const Duration(seconds: 20), () {
      if (mounted) setState(() => _tookTooLong = true);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _matchDriver());
  }

  /// يبحث عن أقرب سائق ويُعيّنه.
  ///
  /// التعيين يحدّث الرحلة في القاعدة، فيصل التغيير عبر Realtime إلى
  /// المستمع في `build` الذي ينقلنا لشاشة الرحلة — لا ننتقل من هنا
  /// حتى يبقى مسار الانتقال واحداً.
  Future<void> _matchDriver() async {
    final ride = await ref.read(rideRepositoryProvider).fetchRide(widget.rideId);
    if (ride == null || !mounted) return;

    // رحلة أُلغيت أو عُيّن لها سائق مسبقاً (عودة للشاشة) — لا نطابق ثانية.
    if (ride.driverId != null || ride.isCancelled) return;

    final driver = await ref.read(rideRepositoryProvider).matchDriver(
          rideId: widget.rideId,
          vehicleTypeId: ride.vehicleTypeId ?? '',
          pickupLat: ride.pickupLat,
          pickupLng: ride.pickupLng,
        );

    // لا سائق متاح → نُظهر رسالة "تعذّر" فوراً بدل انتظار المهلة كاملة.
    if (driver == null && mounted) {
      _noDriverTimer?.cancel();
      setState(() => _tookTooLong = true);
    }
  }

  @override
  void dispose() {
    _noDriverTimer?.cancel();
    _radar.dispose();
    _dots.dispose();
    super.dispose();
  }

  Future<void> _cancel() async {
    setState(() => _isCancelling = true);
    try {
      await ref
          .read(rideRepositoryProvider)
          .cancelRide(widget.rideId, reason: 'ألغاها الراكب');
    } finally {
      if (mounted) context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    // ينتقل تلقائياً فور تعيين سائق — الحالة تصل من القاعدة لحظياً.
    ref.listen(rideStreamProvider(widget.rideId), (_, next) {
      final ride = next.valueOrNull;
      if (ride == null || !mounted) return;
      if (ride.driverId != null && !ride.isCancelled) {
        context.pushReplacement('${AppRoutes.active}?ride=${widget.rideId}');
      } else if (ride.isCancelled) {
        context.go(AppRoutes.home);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          const MapView(),

          // ═══════════════ الرادار ═══════════════
          Align(
            alignment: const Alignment(0, -0.35),
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 3 حلقات متتابعة
                  for (var i = 0; i < 3; i++)
                    AnimatedBuilder(
                      animation: _radar,
                      builder: (context, _) {
                        // إزاحة كل حلقة بثلث الدورة
                        final t = (_radar.value + i / 3) % 1.0;
                        final size = 80 + (220 * t);
                        return Opacity(
                          opacity: (0.8 * (1 - t)).clamp(0.0, 1.0),
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: MishwarakColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  // القرص المركزي
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MishwarakColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: MishwarakColors.primary.withOpacity(0.4),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_taxi_rounded,
                      color: Colors.white,
                      size: 38,
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
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
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
                  Text(
                    _tookTooLong ? l10n.noDriverTitle : l10n.findingDriver,
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _tookTooLong ? l10n.noDriverBody : l10n.findingDriverBody,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: MishwarakColors.lightTextMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),

                  // نقاط نابضة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 3; i++)
                        AnimatedBuilder(
                          animation: _dots,
                          builder: (context, _) {
                            final t = (_dots.value + i * 0.2) % 1.0;
                            // موجة ناعمة: تكبر ثم تصغر
                            final wave =
                                1 - (2 * t - 1).abs(); // 0 → 1 → 0
                            return Transform.scale(
                              scale: 0.7 + 0.4 * wave,
                              child: Container(
                                width: 10,
                                height: 10,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MishwarakColors.primary
                                      .withOpacity(0.3 + 0.7 * wave),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // زر الإلغاء
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _isCancelling ? null : _cancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MishwarakColors.danger,
                        side: BorderSide(
                          color: MishwarakColors.danger.withOpacity(0.4),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        l10n.cancelRequest,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
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
