// ═══════════════════════════════════════════════════════════════
// app_router.dart - نظام التنقل باستخدام go_router
// ═══════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_service.dart';
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

/// المسارات المتاحة قبل تسجيل الدخول.
const _publicRoutes = <String>{
  AppRoutes.splash,
  AppRoutes.onboarding,
  AppRoutes.login,
  AppRoutes.otp,
};

/// يُخطر go_router بإعادة تقييم الحماية كلما تغيّرت الجلسة،
/// فينتقل المستخدم تلقائياً عند الدخول أو الخروج.
class _AuthRefresh extends ChangeNotifier {
  StreamSubscription<AuthState>? _sub;

  _AuthRefresh() {
    if (SupabaseService.isReady) {
      _sub = SupabaseService.client.auth.onAuthStateChange
          .listen((_) => notifyListeners());
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefresh();
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: refresh,

    // ═══════════════ حارس المسارات ═══════════════
    redirect: (context, state) {
      // بلا إعداد Supabase يعمل التطبيق ببيانات وهمية ولا توجد جلسة
      // أصلاً — الحماية هنا كانت ستحبس المطوّر خارج كل الشاشات.
      if (!SupabaseService.isReady) return null;

      final signedIn = SupabaseService.isSignedIn;
      final isPublic = _publicRoutes.contains(state.matchedLocation);

      // زائر يحاول الوصول لشاشة محمية → إلى تسجيل الدخول
      if (!signedIn && !isPublic) return AppRoutes.login;

      // مسجّل دخول ووصل لشاشات الدخول → إلى الرئيسية.
      // نستثني السبلاش ليُكمل حركته الافتتاحية.
      if (signedIn && isPublic && state.matchedLocation != AppRoutes.splash) {
        return AppRoutes.home;
      }

      return null;
    },

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
      // الوجهة تُمرَّر كمعاملات استعلام لا عبر `extra`، حتى تبقى الحالة
      // بعد تحديث الصفحة على الويب.
      GoRoute(
        path: AppRoutes.vehicle,
        builder: (_, state) {
          final q = state.uri.queryParameters;
          return VehicleSelectionScreen(
            destName: q['name'] ?? 'الوجهة',
            destAddress: q['addr'] ?? '',
            destLat: double.tryParse(q['lat'] ?? '') ?? 0,
            destLng: double.tryParse(q['lng'] ?? '') ?? 0,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.finding,
        builder: (_, state) => FindingDriverScreen(
          rideId: state.uri.queryParameters['ride'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.active,
        builder: (_, state) => ActiveRideScreen(
          rideId: state.uri.queryParameters['ride'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.rating,
        builder: (_, state) => RatingScreen(
          rideId: state.uri.queryParameters['ride'] ?? '',
        ),
      ),
    ],
  );
});
