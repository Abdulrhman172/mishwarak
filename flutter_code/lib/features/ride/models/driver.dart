// ═══════════════════════════════════════════════════════════════
// driver.dart - نموذج بيانات السائق
// ═══════════════════════════════════════════════════════════════
import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver.freezed.dart';
part 'driver.g.dart';

@freezed
class Driver with _$Driver {
  const factory Driver({
    required String id,
    required String name,
    required String phone,
    required double rating,
    required int completedTrips,
    required String carModel,
    required String carColor,
    required String plateNumber,
    String? photoUrl,
    @Default(false) bool isFemale,
  }) = _Driver;

  factory Driver.fromJson(Map<String, dynamic> json) =>
      _$DriverFromJson(json);
}

@freezed
class Ride with _$Ride {
  const factory Ride({
    required String id,
    required Driver driver,
    required RideStatus status,
    required DateTime requestedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    required String pickupAddress,
    required String destinationAddress,
    required double pickupLat,
    required double pickupLng,
    required double destLat,
    required double destLng,
    required int fare,
    required int distanceKm,
    required String paymentMethod,
    int? tip,
    int? rating,
  }) = _Ride;

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);
}

enum RideStatus {
  requested,       // بحث عن سائق
  driverAssigned,  // تم تعيين سائق
  arriving,        // السائق في الطريق
  arrived,         // السائق وصل
  onTrip,          // الرحلة جارية
  completed,       // انتهت
  cancelled,       // ملغاة
}

/// بيانات ثابتة - في الإنتاج تأتي من الـ API
class DriversRepository {
  static const Driver mockDriver = Driver(
    id: 'drv_001',
    name: 'محمد صالح',
    phone: '+967771234567',
    rating: 4.92,
    completedTrips: 1247,
    carModel: 'تويوتا هايلوكس',
    carColor: 'أبيض',
    plateNumber: 'ADN 4287',
  );
}
