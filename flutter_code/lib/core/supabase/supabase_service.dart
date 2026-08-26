// ═══════════════════════════════════════════════════════════════
// supabase_service.dart - تهيئة عميل Supabase
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

class SupabaseService {
  SupabaseService._();

  static bool _initialized = false;

  /// هل العميل جاهز للاستخدام فعلياً؟
  ///
  /// يكون `false` عندما لا يوجد إعداد، فترجع المستودعات لبياناتها الوهمية
  /// بدل أن ينهار التطبيق.
  static bool get isReady => _initialized;

  /// عميل Supabase — لا تستدعِه قبل التأكد من [isReady].
  static SupabaseClient get client => Supabase.instance.client;

  /// المستخدم الحالي، أو `null` إن لم يسجّل الدخول.
  static User? get currentUser => _initialized ? client.auth.currentUser : null;

  static bool get isSignedIn => currentUser != null;

  /// تهيئة آمنة: لا ترمي استثناءً إن غاب الإعداد أو فشل الاتصال،
  /// حتى يبقى التطبيق قابلاً للتشغيل أثناء التطوير.
  static Future<void> initialize() async {
    if (_initialized) return;

    if (!AppConfig.hasSupabase) {
      debugPrint(
        '[Supabase] لا يوجد إعداد — التطبيق يعمل ببيانات وهمية.\n'
        'مرّر SUPABASE_URL و SUPABASE_ANON_KEY عبر --dart-define للاتصال.',
      );
      return;
    }

    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        // `anonKey` مهجورة وستُحذف في إصدار رئيسي قادم. الاسم الجديد
        // فقط هو ما تغيّر — المفتاح نفسه (anon / publishable) بلا تبديل.
        publishableKey: AppConfig.supabaseAnonKey,
      );
      _initialized = true;
      debugPrint('[Supabase] متصل ✓');
    } catch (e) {
      // الشبكة أو المفاتيح خاطئة — نُكمل ببيانات وهمية بدل تعطيل التطبيق.
      debugPrint('[Supabase] فشل الاتصال ($e) — الرجوع للبيانات الوهمية.');
    }
  }
}
