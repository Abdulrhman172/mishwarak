// ═══════════════════════════════════════════════════════════════
// location_service.dart - الموقع الحقيقي للمستخدم (GPS)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// نتيجة محاولة الحصول على الموقع.
///
/// نُميّز بين أسباب الفشل لأن كل سبب يحتاج رسالة مختلفة للمستخدم:
/// تفعيل الـ GPS شيء، ورفض الإذن نهائياً شيء آخر.
enum LocationStatus {
  ok,
  serviceDisabled, // خدمة الموقع مغلقة في الجهاز
  denied, // رُفض هذه المرة (يمكن طلبه ثانية)
  deniedForever, // رُفض نهائياً (يلزم فتح الإعدادات)
  failed, // خطأ غير متوقع أو انتهت المهلة
}

class LocationResult {
  final LocationStatus status;
  final Position? position;

  const LocationResult(this.status, [this.position]);

  bool get isOk => status == LocationStatus.ok && position != null;

  // ملاحظة: لا رسالة نصية هنا عمداً — [LocationStatus] لا يعرف لغة
  // المستخدم، فالترجمة تتم في الواجهة (راجع home_screen._locationErrorMessage).
}

class LocationService {
  LocationService._();

  /// يطلب الإذن ويعيد الموقع الحالي.
  ///
  /// يتعامل مع كل حالات الرفض بدل رمي استثناء، لأن رفض الإذن
  /// سلوك طبيعي من المستخدم وليس خطأ برمجياً.
  static Future<LocationResult> getCurrent({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    try {
      // على الويب لا توجد "خدمة موقع" تُفحص — المتصفح يتكفّل بذلك.
      if (!kIsWeb) {
        final enabled = await Geolocator.isLocationServiceEnabled();
        if (!enabled) {
          return const LocationResult(LocationStatus.serviceDisabled);
        }
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationResult(LocationStatus.deniedForever);
      }
      if (permission == LocationPermission.denied) {
        return const LocationResult(LocationStatus.denied);
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: timeout,
      );
      return LocationResult(LocationStatus.ok, position);
    } catch (e) {
      debugPrint('[LocationService] فشل تحديد الموقع: $e');
      return const LocationResult(LocationStatus.failed);
    }
  }

  // ملاحظة: أُزيلت `watch()` (تدفّق مستمر للموقع) لأنها لم تُستدعَ من
  // أي شاشة. تتبّع الراكب أثناء الرحلة يأتي من موقع السائق عبر
  // Realtime لا من جهاز الراكب — راجع `rideDriverProvider`.

  /// المسافة بالكيلومترات بين نقطتين — تُستخدم لحساب الأجرة.
  static double distanceKm({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    final meters = Geolocator.distanceBetween(
      startLat,
      startLng,
      endLat,
      endLng,
    );
    return meters / 1000;
  }

  /// يفتح إعدادات التطبيق ليمنح المستخدم الإذن يدوياً.
  static Future<void> openSettings() => Geolocator.openAppSettings();
}
