// ═══════════════════════════════════════════════════════════════
// fare_calculator_test.dart - منطق حساب الأجرة
// ═══════════════════════════════════════════════════════════════
import 'package:flutter_test/flutter_test.dart';

import 'package:mishwarak/features/booking/data/fare_calculator.dart';
import 'package:mishwarak/features/booking/models/vehicle_type.dart';

const _comfort = VehicleType(
  id: 'comfort',
  category: VehicleCategory.comfort,
  nameAr: 'مريح',
  nameEn: 'Comfort',
  descriptionAr: '',
  descriptionEn: '',
  seats: 4,
  etaMinutes: 5,
  price: 3800,
  pricePerKm: 180,
);

void main() {
  test('الأجرة = الأساسي + (سعر الكيلومتر × المسافة)', () {
    final fare = FareCalculator.estimate(vehicle: _comfort, distanceKm: 7.2);

    expect(fare.baseFare, 3800);
    expect(fare.distanceFare, 1296); // 180 × 7.2
    expect(fare.total, 5096);
  });

  test('بلا مسافة تُعرض الأجرة الأساسية فقط', () {
    final fare = FareCalculator.estimate(vehicle: _comfort, distanceKm: 0);

    expect(fare.distanceFare, 0);
    expect(fare.total, 3800);
  });

  test('المسافة السالبة أو غير الصالحة تُعامل كصفر', () {
    for (final bad in [-5.0, double.nan, double.infinity]) {
      final fare = FareCalculator.estimate(vehicle: _comfort, distanceKm: bad);
      expect(fare.distanceFare, 0, reason: 'مسافة غير صالحة: $bad');
      expect(fare.total, 3800);
    }
  });

  test('الأجرة لا تنزل تحت الحد الأدنى', () {
    const cheap = VehicleType(
      id: 'x',
      category: VehicleCategory.economy,
      nameAr: '',
      nameEn: '',
      descriptionAr: '',
      descriptionEn: '',
      seats: 4,
      etaMinutes: 1,
      price: 300, // أقل من الحد الأدنى
      pricePerKm: 0,
    );

    final fare = FareCalculator.estimate(vehicle: cheap, distanceKm: 0.2);
    expect(fare.total, greaterThanOrEqualTo(1000));
  });

  test('المسافة الأطول تُنتج أجرة أعلى', () {
    final short = FareCalculator.estimate(vehicle: _comfort, distanceKm: 2);
    final long = FareCalculator.estimate(vehicle: _comfort, distanceKm: 20);

    expect(long.total, greaterThan(short.total));
  });
}
