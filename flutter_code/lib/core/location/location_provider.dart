// ═══════════════════════════════════════════════════════════════
// location_provider.dart - حالة موقع المستخدم
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'location_service.dart';

/// موقع المستخدم مع عنوانه المقروء.
class UserLocation {
  final double lat;
  final double lng;

  /// اسم الحي/المنطقة — يبقى `null` ريثما يصل من الـ geocoding.
  final String? address;

  const UserLocation({required this.lat, required this.lng, this.address});

  /// النص المعروض في بطاقة المسار.
  String get label => address ?? 'موقعي الحالي';

  UserLocation copyWith({String? address}) =>
      UserLocation(lat: lat, lng: lng, address: address ?? this.address);
}

class LocationNotifier extends StateNotifier<AsyncValue<UserLocation?>> {
  LocationNotifier() : super(const AsyncValue.data(null));

  /// آخر سبب فشل — لعرض الرسالة المناسبة في الواجهة.
  LocationStatus? lastStatus;

  /// يحدّد موقع المستخدم ويجلب عنوانه.
  Future<void> locate() async {
    state = const AsyncValue.loading();

    final result = await LocationService.getCurrent();
    lastStatus = result.status;

    if (!result.isOk) {
      // الحالة (لا الرسالة الجاهزة) هي ما يُخزَّن، حتى تختار الواجهة
      // نص الترجمة المناسب — LocationService لا يعرف لغة المستخدم.
      state = AsyncValue.error(result.status, StackTrace.current);
      return;
    }

    final pos = result.position!;
    var location = UserLocation(lat: pos.latitude, lng: pos.longitude);

    // نعرض الإحداثيات فوراً ثم نُثري بالعنوان — حتى لا ينتظر المستخدم.
    state = AsyncValue.data(location);

    final address = await _reverseGeocode(pos);
    if (address != null && mounted) {
      state = AsyncValue.data(location.copyWith(address: address));
    }
  }

  /// يحوّل الإحداثيات إلى اسم منطقة.
  ///
  /// حزمة `geocoding` لا تدعم الويب، لذا نتجاهل الفشل بهدوء
  /// ونكتفي بالنص الافتراضي.
  Future<String?> _reverseGeocode(Position pos) async {
    if (kIsWeb) return null;

    try {
      // اللغة تُضبط عالمياً في هذا الإصدار، لا كوسيط لكل استدعاء.
      await setLocaleIdentifier('ar');

      final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (marks.isEmpty) return null;

      final m = marks.first;
      // نُفضّل اسم الحي، ثم المنطقة الفرعية، ثم المدينة.
      final parts = [
        m.subLocality,
        m.locality,
        m.administrativeArea,
      ].where((p) => p != null && p.isNotEmpty).cast<String>();

      return parts.isEmpty ? null : parts.take(2).join('، ');
    } catch (e) {
      debugPrint('[LocationProvider] تعذّر تحويل الإحداثيات لعنوان: $e');
      return null;
    }
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, AsyncValue<UserLocation?>>(
  (ref) => LocationNotifier(),
);
