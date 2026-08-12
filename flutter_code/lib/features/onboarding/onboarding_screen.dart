// ═══════════════════════════════════════════════════════════════
// onboarding_screen.dart - شاشات التعريف بالتطبيق (3 خطوات)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';

class _Slide {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _Slide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _step = 0;

  static const _slides = [
    _Slide(
      title: 'اطلب مشوارك بضغطة زر',
      subtitle: 'سائقون موثوقون في عدن حول الساعة، جاهزون لخدمتك',
      icon: Icons.directions_car_filled_rounded,
      color: MishwarakColors.primary,
    ),
    _Slide(
      title: 'أسعار شفافة قبل الرحلة',
      subtitle: 'اعرف السعر قبل تأكيد الطلب. بدون مفاجآت.',
      icon: Icons.receipt_long_rounded,
      color: MishwarakColors.secondary,
    ),
    _Slide(
      title: 'أمانك أولويتنا',
      subtitle: 'شارك رحلتك مع عائلتك، وزر SOS للطوارئ، وخيار سائقة للنساء',
      icon: Icons.verified_user_rounded,
      color: MishwarakColors.accent,
    ),
  ];

  bool get _isLast => _step == _slides.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_isLast) {
      context.go(AppRoutes.login);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ═══ تخطي ═══
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  style: TextButton.styleFrom(
                    foregroundColor: MishwarakColors.lightTextMuted,
                  ),
                  child: const Text('تخطي'),
                ),
              ),
            ),

            // ═══ الشرائح ═══
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _step = i),
                itemBuilder: (context, i) {
                  final slide = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // رسم توضيحي
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: slide.color.withOpacity(0.12),
                          ),
                          child: Icon(slide.icon, size: 84, color: slide.color),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide.title,
                          style: theme.textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.subtitle,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: MishwarakColors.lightTextMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ═══ مؤشر الصفحات ═══
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _step == i ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _step == i
                          ? MishwarakColors.primary
                          : theme.dividerColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // ═══ زر المتابعة ═══
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  elevation: 8,
                  shadowColor: MishwarakColors.primary.withOpacity(0.4),
                ),
                child: Text(_isLast ? 'يلا نبدأ' : 'التالي'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
