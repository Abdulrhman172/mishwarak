// ═══════════════════════════════════════════════════════════════
// onboarding_screen.dart - شاشة التعريف بالتطبيق
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_car_filled_rounded,
                  size: 96, color: MishwarakColors.primary),
              const SizedBox(height: 24),
              Text('أهلاً بك في مِشوارَك',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('توصيل ركاب سريع وآمن في اليمن',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: MishwarakColors.lightTextMuted),
                  textAlign: TextAlign.center),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.login),
                child: const Text('ابدأ الآن'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
