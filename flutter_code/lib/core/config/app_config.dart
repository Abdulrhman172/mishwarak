// ═══════════════════════════════════════════════════════════════
// app_config.dart - المفاتيح والإعدادات الخارجية
// ═══════════════════════════════════════════════════════════════
// تُمرَّر القيم وقت البناء عبر --dart-define حتى لا تُحفظ في الكود:
//
//   flutter run -d chrome \
//     --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
//     --dart-define=SUPABASE_ANON_KEY=eyJhbGci... \
//     --dart-define=GOOGLE_MAPS_API_KEY=AIza...
//
// أو عبر ملف: flutter run --dart-define-from-file=env.json
//
// التطبيق يعمل بالكامل بدون هذه المفاتيح مستخدماً بيانات وهمية،
// حتى يتمكن المطوّر من التشغيل قبل تجهيز الخدمات.
library;

class AppConfig {
  AppConfig._();

  // ─────────── Supabase ───────────
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// هل إعداد Supabase مكتمل؟ إن لا، تعمل المستودعات ببيانات وهمية.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  // ─────────── Google Maps ───────────
  static const String googleMapsApiKey =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  /// هل يوجد مفتاح خرائط؟ إن لا، تُعرض خريطة بديلة (placeholder).
  ///
  /// ملاحظة: على الويب يُحقَن المفتاح في `web/index.html` وقت التشغيل،
  /// وعلى أندرويد/iOS في ملفات المنصّة — راجع `SETUP.md`.
  static bool get hasMapsKey => googleMapsApiKey.isNotEmpty;

  // ─────────── هوية التطبيق ───────────

  /// إصدار التطبيق كما يُعرض في شاشة الإعدادات.
  ///
  /// يُمرَّر وقت البناء ليطابق `version` في `pubspec.yaml`:
  ///   --dart-define=APP_VERSION=1.0.0
  /// وقيمته الافتراضية هي النسخة الحالية حتى لا تظهر الشاشة فارغة.
  static const String version =
      String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');

  // ─────────── أرقام الطوارئ ───────────

  /// رقم الطوارئ الموحّد في اليمن.
  ///
  /// ثابت في الإعداد لا في الكود، حتى يمكن تغييره لبلد آخر بلا تعديل
  /// الشاشات التي تستخدمه.
  static const String emergencyNumber =
      String.fromEnvironment('EMERGENCY_NUMBER', defaultValue: '199');

  /// رقم دعم العملاء — يُستخدم في شاشة المساعدة.
  static const String supportPhone =
      String.fromEnvironment('SUPPORT_PHONE', defaultValue: '+967730000000');

  static const String supportEmail =
      String.fromEnvironment('SUPPORT_EMAIL', defaultValue: 'support@mishwarak.ye');

  /// ملخّص الإعداد لعرضه في شاشة التشخيص أو سجلّ التشغيل.
  static String get summary => 'Supabase: ${hasSupabase ? "متصل" : "وهمي"} · '
      'Maps: ${hasMapsKey ? "مفعّلة" : "بديلة"}';
}
