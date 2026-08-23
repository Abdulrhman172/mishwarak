// ═══════════════════════════════════════════════════════════════
// vehicle_type_repository.dart - جلب أنواع المركبات
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_service.dart';
import '../models/vehicle_type.dart';

class VehicleTypeRepository {
  const VehicleTypeRepository();

  /// أنواع المركبات المتاحة، مرتّبة كما في لوحة التحكم.
  ///
  /// ترجع البيانات الوهمية إذا لم يكن Supabase مهيّأً أو فشل الطلب،
  /// حتى تظل الشاشة قابلة للاستخدام أثناء التطوير.
  Future<List<VehicleType>> fetchAll() async {
    if (!SupabaseService.isReady) return VehicleTypesRepository.mockVehicles;

    try {
      final rows = await SupabaseService.client
          .from('vehicle_types')
          .select()
          .eq('is_active', true)
          .order('sort_order');

      if (rows.isEmpty) return VehicleTypesRepository.mockVehicles;

      return rows.map<VehicleType>(_fromRow).toList();
    } catch (e) {
      debugPrint('[VehicleTypeRepository] فشل الجلب ($e) — بيانات وهمية.');
      return VehicleTypesRepository.mockVehicles;
    }
  }

  /// يحوّل صفاً من `vehicle_types` إلى النموذج.
  ///
  /// أسماء أعمدة SQL بصيغة snake_case بينما النموذج بـ camelCase،
  /// لذا التحويل يدوي بدل `fromJson`.
  static VehicleType _fromRow(Map<String, dynamic> row) => VehicleType(
        id: row['id'] as String,
        category: _categoryFrom(row['category'] as String?),
        nameAr: row['name_ar'] as String? ?? '',
        nameEn: row['name_en'] as String? ?? '',
        descriptionAr: row['description_ar'] as String? ?? '',
        descriptionEn: row['description_en'] as String? ?? '',
        seats: (row['seats'] as num?)?.toInt() ?? 4,
        etaMinutes: (row['eta_minutes'] as num?)?.toInt() ?? 5,
        price: (row['base_price'] as num?)?.toInt() ?? 0,
        pricePerKm: (row['price_per_km'] as num?)?.toInt() ?? 0,
        badgeAr: row['badge_ar'] as String?,
        badgeEn: row['badge_en'] as String?,
        imageUrl: row['image_url'] as String?,
      );

  static VehicleCategory _categoryFrom(String? value) =>
      VehicleCategory.values.firstWhere(
        (c) => c.name == value,
        orElse: () => VehicleCategory.economy,
      );
}

final vehicleTypeRepositoryProvider =
    Provider((ref) => const VehicleTypeRepository());

/// أنواع المركبات للعرض في شاشة الاختيار.
final vehicleTypesProvider = FutureProvider<List<VehicleType>>(
  (ref) => ref.watch(vehicleTypeRepositoryProvider).fetchAll(),
);
