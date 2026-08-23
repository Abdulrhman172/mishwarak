// ═══════════════════════════════════════════════════════════════
// auth_repository.dart - المصادقة برقم الهاتف (OTP)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_service.dart';

class AuthRepository {
  const AuthRepository();

  /// يرسل رمز تحقق إلى رقم الهاتف.
  ///
  /// [phone] بالصيغة الدولية: `+967771234567`.
  /// يتطلب تفعيل مزوّد SMS في Supabase → Authentication → Providers → Phone.
  Future<void> sendOtp(String phone) async {
    if (!SupabaseService.isReady) {
      throw StateError('Supabase غير مهيّأ — راجع SETUP.md');
    }
    await SupabaseService.client.auth.signInWithOtp(phone: phone);
  }

  /// يتحقق من الرمز ويسجّل الدخول.
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
  }) async {
    if (!SupabaseService.isReady) {
      throw StateError('Supabase غير مهيّأ — راجع SETUP.md');
    }
    return SupabaseService.client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  Future<void> signOut() async {
    if (!SupabaseService.isReady) return;
    await SupabaseService.client.auth.signOut();
  }

  /// يتابع حالة الجلسة (دخول/خروج) لتوجيه المستخدم تلقائياً.
  Stream<AuthState> authStateChanges() {
    if (!SupabaseService.isReady) return const Stream.empty();
    return SupabaseService.client.auth.onAuthStateChange;
  }
}

final authRepositoryProvider = Provider((ref) => const AuthRepository());

/// `true` عندما تكون هناك جلسة نشطة.
final isSignedInProvider = StreamProvider<bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  if (!SupabaseService.isReady) return Stream.value(false);
  return repo.authStateChanges().map((s) => s.session != null);
});
