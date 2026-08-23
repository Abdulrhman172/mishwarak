// ═══════════════════════════════════════════════════════════════
// vehicle_type.dart - نموذج نوع المركبة
// ═══════════════════════════════════════════════════════════════
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_type.freezed.dart';
part 'vehicle_type.g.dart';

enum VehicleCategory {
  economy,
  comfort,
  xl,
  women,
  vip,
}

@freezed
class VehicleType with _$VehicleType {
  const factory VehicleType({
    required String id,
    required VehicleCategory category,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required int seats,
    required int etaMinutes,
    required int price, // السعر الأساسي بالريال اليمني
    /// يُضرب في المسافة ويُضاف للسعر الأساسي — راجع [FareCalculator].
    @Default(0) int pricePerKm,
    int? oldPrice,
    String? badgeAr,
    String? badgeEn,
    String? imageUrl,
  }) = _VehicleType;

  factory VehicleType.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeFromJson(json);
}

/// بيانات ثابتة - في الإنتاج تأتي من الـ API
class VehicleTypesRepository {
  static final List<VehicleType> mockVehicles = [
    const VehicleType(
      id: 'eco',
      category: VehicleCategory.economy,
      nameAr: 'اقتصادي',
      nameEn: 'Economy',
      descriptionAr: '4 ركاب',
      descriptionEn: '4 seats',
      seats: 4,
      etaMinutes: 3,
      price: 2500,
      pricePerKm: 120,
      oldPrice: 3200,
    ),
    const VehicleType(
      id: 'comfort',
      category: VehicleCategory.comfort,
      nameAr: 'مريح',
      nameEn: 'Comfort',
      descriptionAr: 'سيارة أحدث',
      descriptionEn: 'Newer car',
      seats: 4,
      etaMinutes: 5,
      price: 3800,
      pricePerKm: 180,
    ),
    const VehicleType(
      id: 'xl',
      category: VehicleCategory.xl,
      nameAr: 'عائلي XL',
      nameEn: 'XL',
      descriptionAr: '6 ركاب',
      descriptionEn: '6 seats',
      seats: 6,
      etaMinutes: 7,
      price: 5200,
      pricePerKm: 240,
    ),
    const VehicleType(
      id: 'women',
      category: VehicleCategory.women,
      nameAr: 'سائقة للنساء',
      nameEn: 'Women only',
      descriptionAr: 'سائقة خبيرة',
      descriptionEn: 'Female driver',
      seats: 4,
      etaMinutes: 9,
      price: 3200,
      pricePerKm: 160,
      badgeAr: 'حصري',
      badgeEn: 'Exclusive',
    ),
  ];
}
