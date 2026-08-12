// ═══════════════════════════════════════════════════════════════
// active_ride_screen.dart - شاشة الرحلة الجارية (تتبّع السائق)
// ═══════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/driver_avatar.dart';
import '../../shared/widgets/map_placeholder.dart';
import '../../shared/widgets/star_rating.dart';
import 'models/driver.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  static const _driver = DriversRepository.mockDriver;

  /// تقدّم السائق على المسار من 0 إلى 1.
  double _progress = 0.05;
  Timer? _ticker;

  /// قبل 0.35 السائق في طريقه إليك، بعدها الرحلة بدأت.
  bool get _isArriving => _progress < 0.35;

  @override
  void initState() {
    super.initState();
    // محاكاة تحرّك السائق - في الإنتاج من الـ socket
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (t) {
      if (!mounted) return;
      setState(() => _progress += 0.015);
      if (_progress >= 0.98) {
        t.cancel();
        context.pushReplacement(AppRoutes.rating);
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String get _statusLabel {
    if (_isArriving) {
      final mins = ((0.35 - _progress) * 30).round().clamp(1, 99);
      return 'السائق يصل خلال $mins دقائق';
    }
    final mins = ((1 - _progress) * 15).round().clamp(1, 99);
    return 'في الطريق · $mins دقيقة';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const MapPlaceholder(icon: Icons.navigation_outlined),

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
                      color: Colors.black.withOpacity(0.15),
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
                      _statusLabel,
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
                      onTap: () => _snack('تمت مشاركة رحلتك'),
                    ),
                    const SizedBox(height: 8),
                    _RoundAction(
                      icon: Icons.shield_outlined,
                      color: Colors.white,
                      background: MishwarakColors.danger,
                      onTap: () => _snack('تم إبلاغ جهات الطوارئ'),
                    ),
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
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // ═══ بطاقة السائق ═══
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        DriverAvatar(
                          size: 60,
                          initials: _driver.name.characters.first,
                          verified: true,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _driver.name,
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  StarRating(value: _driver.rating, size: 12),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${_driver.rating}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '· ${_driver.completedTrips} رحلة',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: MishwarakColors.lightTextMuted,
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
                          background: MishwarakColors.primary.withOpacity(0.12),
                          border: true,
                          onTap: () => _snack('المحادثة قيد الإنشاء'),
                        ),
                        const SizedBox(width: 8),
                        _RoundAction(
                          icon: Icons.phone,
                          color: Colors.white,
                          background: MishwarakColors.primary,
                          onTap: () => _snack('جارِ الاتصال بـ ${_driver.name}'),
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
                                _driver.carModel,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _driver.carColor,
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
                            _driver.plateNumber,
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
                                'كريتر - موقعي',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'جامعة عدن',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
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
                              'السعر',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: MishwarakColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                style: theme.textTheme.headlineSmall,
                                children: const [
                                  TextSpan(text: '3,800 '),
                                  TextSpan(
                                    text: 'ر.ي',
                                    style: TextStyle(
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

  void _snack(String msg) {
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
                color: MishwarakColors.primary.withOpacity(0.3),
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
