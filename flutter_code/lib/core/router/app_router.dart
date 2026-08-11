// ═══════════════════════════════════════════════════════════════
// app_router.dart - نظام التنقل باستخدام go_router
// ═══════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/booking/vehicle_selection_screen.dart';
import '../../features/booking/finding_driver_screen.dart';
import '../../features/ride/active_ride_screen.dart';
import '../../features/ride/rating_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/notifications/notifications_screen.dart';

/// أسماء المسارات (Type-safe)
class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/otp';
  static const home = '/home';
  static const search = '/search';
  static const vehicle = '/booking/vehicle';
  static const finding = '/booking/finding';
  static const active = '/ride/active';
  static const rating = '/ride/rating';
  static const wallet = '/wallet';
  static const history = '/history';
  static const profile = '/profile';
  static const notifications = '/notifications';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (_, state) => OtpScreen(
          phoneNumber: state.uri.queryParameters['phone'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'search',
            builder: (_, __) => const SearchScreen(),
          ),
          GoRoute(
            path: 'wallet',
            builder: (_, __) => const WalletScreen(),
          ),
          GoRoute(
            path: 'history',
            builder: (_, __) => const HistoryScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (_, __) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'notifications',
            builder: (_, __) => const NotificationsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.vehicle,
        builder: (_, __) => const VehicleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.finding,
        builder: (_, __) => const FindingDriverScreen(),
      ),
      GoRoute(
        path: AppRoutes.active,
        builder: (_, __) => const ActiveRideScreen(),
      ),
      GoRoute(
        path: AppRoutes.rating,
        builder: (_, __) => const RatingScreen(),
      ),
    ],
  );
});
