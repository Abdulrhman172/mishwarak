// ═══════════════════════════════════════════════════════════════
// fare_calculator.dart - حساب أجرة الرحلة
// ═══════════════════════════════════════════════════════════════
import '../models/vehicle_type.dart';

/// تفصيل الأجرة كما يُعرض للراكب ويُخزَّن في جدول `rides`.
class FareBreakdown {
  /// السعر الأساسي لنوع المركبة (يشمل أول كيلومتر).
  final int baseFare;

  /// أجرة المسافة = سعر الكيلومتر × المسافة.
  final int distanceFare;

  final double distanceKm;

  const FareBreakdown({
    required this.baseFare,
    required this.distanceFare,
    required this.distanceKm,
  });

  int get total => baseFare + distanceFare;
}

class FareCalculator {
  FareCalculator._();

  /// أقل أجرة تُحتسب مهما قصرت المسافة.
  static const _minimumFare = 1000;

  /// يحسب أجرة رحلة بين نقطتين.
  ///
  /// [distanceKm] تأتي من `LocationService.distanceKm`. عندما تكون صفراً
  /// (لم يُحدَّد الموقع بعد) نكتفي بالسعر الأساسي بدل عرض رقم مضلّل.
  static FareBreakdown estimate({
    required VehicleType vehicle,
    required double distanceKm,
  }) {
    final safeDistance = distanceKm.isFinite && distanceKm > 0 ? distanceKm : 0.0;
    final distanceFare = (vehicle.pricePerKm * safeDistance).round();

    final base = vehicle.price < _minimumFare ? _minimumFare : vehicle.price;

    return FareBreakdown(
      baseFare: base,
      distanceFare: distanceFare,
      distanceKm: safeDistance,
    );
  }
}
