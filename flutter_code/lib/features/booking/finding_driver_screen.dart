// ═══════════════════════════════════════════════════════════════
// finding_driver_screen.dart - شاشة البحث عن سائق (رادار متحرك)
// ═══════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/map_placeholder.dart';

class FindingDriverScreen extends StatefulWidget {
  const FindingDriverScreen({super.key});

  @override
  State<FindingDriverScreen> createState() => _FindingDriverScreenState();
}

class _FindingDriverScreenState extends State<FindingDriverScreen>
    with TickerProviderStateMixin {
  late final AnimationController _radar;
  late final AnimationController _dots;
  Timer? _foundTimer;

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

    // محاكاة العثور على سائق - في الإنتاج يأتي من الـ socket
    _foundTimer = Timer(const Duration(milliseconds: 3500), () {
      if (mounted) context.pushReplacement(AppRoutes.active);
    });
  }

  @override
  void dispose() {
    _foundTimer?.cancel();
    _radar.dispose();
    _dots.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const MapPlaceholder(),

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
                    'نبحث لك عن أفضل سائق...',
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'لحظات وسنجد لك أقرب سائق متاح',
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
                      onPressed: () => context.pop(),
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
                      child: const Text(
                        'إلغاء الطلب',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
