// ═══════════════════════════════════════════════════════════════
// geocoding_service.dart - تحويل نص العنوان إلى إحداثيات
// ═══════════════════════════════════════════════════════════════
// حزمة `geocoding` كانت ضمن الاعتماديات لكنها تُستخدم في اتجاه واحد
// فقط (إحداثيات ← عنوان). النتيجة أن أي وجهة يكتبها المستخدم تُحفظ
// في `rides` بإحداثيات (0,0) — نقطة في خليج غينيا — فتضيع أجرة
// المسافة ويستحيل رسم المسار أو حساب مسافة فعلية للرحلة.
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

/// نتيجة بحث عن مكان.
class PlaceResult {
  final String name;
  final String address;
  final double lat;
  final double lng;

  const PlaceResult({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });

  /// هل للنتيجة إحداثيات صالحة؟
  bool get hasCoordinates => lat != 0 || lng != 0;
}

class GeocodingService {
  const GeocodingService();

  /// هل البحث الجغرافي متاح على هذه المنصّة؟
  ///
  /// الحزمة لا تدعم الويب ولا سطح المكتب — تعتمد على خدمات النظام
  /// في أندرويد و iOS فقط.
  static bool get isSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// يبحث عن عنوان نصّي ويعيد أقرب النتائج.
  ///
  /// [near] يُستخدم لترتيب النتائج بالقرب من المستخدم: البحث عن
  /// "المطار" يعيد مطارات كثيرة، وأقربها هو المقصود غالباً.
  Future<List<PlaceResult>> search(
    String query, {
    double? nearLat,
    double? nearLng,
    int limit = 5,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty || !isSupported) return const [];

    try {
      final locations = await locationFromAddress(trimmed);
      if (locations.isEmpty) return const [];

      final results = <PlaceResult>[];
      for (final location in locations.take(limit)) {
        results.add(
          PlaceResult(
            name: trimmed,
            address: await _describe(location) ?? trimmed,
            lat: location.latitude,
            lng: location.longitude,
          ),
        );
      }

      if (nearLat != null && nearLng != null) {
        results.sort(
          (a, b) => _squared(a, nearLat, nearLng)
              .compareTo(_squared(b, nearLat, nearLng)),
        );
      }

      return results;
    } catch (e) {
      // `locationFromAddress` ترمي عند عدم العثور على نتائج أيضاً،
      // فالقائمة الفارغة هي التعبير الصحيح عن ذلك لا استثناء.
      debugPrint('[GeocodingService] تعذّر البحث عن "$trimmed" ($e).');
      return const [];
    }
  }

  /// وصف مقروء للإحداثيات — الحيّ ثم المدينة.
  Future<String?> _describe(Location location) async {
    try {
      final marks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (marks.isEmpty) return null;

      final m = marks.first;
      final parts = [m.subLocality, m.locality, m.administrativeArea]
          .where((p) => p != null && p.isNotEmpty)
          .cast<String>();

      return parts.isEmpty ? null : parts.take(2).join('، ');
    } catch (_) {
      return null;
    }
  }

  /// مربّع المسافة بالدرجات — يكفي للترتيب دون تكلفة الجذر التربيعي.
  static double _squared(PlaceResult p, double lat, double lng) {
    final dLat = p.lat - lat;
    // تصحيح فرق خطوط الطول بجيب تمام العرض، وإلا بدت النتائج
    // شرقاً وغرباً أقرب مما هي عليه فعلاً.
    final dLng = (p.lng - lng) * math.cos(lat * math.pi / 180);
    return dLat * dLat + dLng * dLng;
  }
}

final geocodingServiceProvider = Provider((ref) => const GeocodingService());
