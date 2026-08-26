// ═══════════════════════════════════════════════════════════════
// promo_repository.dart - كوبونات الخصم
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../../core/supabase/supabase_service.dart';

/// كوبون معروض في قائمة العروض.
class PromoCode {
  final String code;
  final String? descriptionAr;
  final String? descriptionEn;
  final int? discountPercent;
  final int? discountAmount;
  final int? maxDiscount;
  final DateTime? validUntil;

  const PromoCode({
    required this.code,
    this.descriptionAr,
    this.descriptionEn,
    this.discountPercent,
    this.discountAmount,
    this.maxDiscount,
    this.validUntil,
  });

  /// الوصف بلغة المستخدم، مع الرجوع للّغة الأخرى إن غابت ترجمتها.
  String description(String languageCode) {
    final preferred = languageCode == 'en' ? descriptionEn : descriptionAr;
    return preferred?.trim().isNotEmpty == true
        ? preferred!
        : (descriptionAr ?? descriptionEn ?? code);
  }

  static PromoCode fromRow(Map<String, dynamic> row) => PromoCode(
        code: row['code'] as String,
        descriptionAr: row['description_ar'] as String?,
        descriptionEn: row['description_en'] as String?,
        discountPercent: (row['discount_percent'] as num?)?.toInt(),
        discountAmount: (row['discount_amount'] as num?)?.toInt(),
        maxDiscount: (row['max_discount'] as num?)?.toInt(),
        validUntil: row['valid_until'] == null
            ? null
            : DateTime.tryParse(row['valid_until'] as String),
      );
}

/// سبب رفض الكوبون — مفاتيح ثابتة تُترجمها الواجهة.
enum PromoRejection {
  notFound,
  expired,
  notStarted,
  exhausted,
  alreadyUsed,
  rideClosed,
  unknown;

  static PromoRejection fromReason(String? reason) => switch (reason) {
        'not_found' => PromoRejection.notFound,
        'expired' => PromoRejection.expired,
        'not_started' => PromoRejection.notStarted,
        'exhausted' => PromoRejection.exhausted,
        'already_used' => PromoRejection.alreadyUsed,
        'ride_closed' || 'ride_not_found' => PromoRejection.rideClosed,
        _ => PromoRejection.unknown,
      };
}

/// نتيجة التحقّق من كوبون.
class PromoResult {
  final bool valid;
  final int discount;
  final PromoRejection? rejection;

  const PromoResult.valid(this.discount)
      : valid = true,
        rejection = null;

  const PromoResult.rejected(this.rejection)
      : valid = false,
        discount = 0;
}

class PromoRepository {
  const PromoRepository();

  /// الكوبونات الفعّالة المتاحة للمستخدم.
  ///
  /// سياسة RLS تُظهر الفعّال غير المنتهي فقط، لكنها لا تعرف ما استهلكه
  /// المستخدم — نستبعده هنا حتى لا نعرض عرضاً لن يقبله الخادم.
  Future<List<PromoCode>> fetchAvailable() async {
    if (!SupabaseService.isReady) return const [];

    try {
      final rows = await SupabaseService.client.from('promo_codes').select();
      final used = await _usedCodes();

      return rows
          .where((r) => !used.contains(r['code'] as String))
          .map<PromoCode>(PromoCode.fromRow)
          .toList();
    } catch (e) {
      debugPrint('[PromoRepository] فشل جلب العروض ($e).');
      return const [];
    }
  }

  Future<Set<String>> _usedCodes() async {
    final user = SupabaseService.currentUser;
    if (user == null) return const {};

    try {
      final rows = await SupabaseService.client
          .from('promo_redemptions')
          .select('code')
          .eq('user_id', user.id);
      return rows.map<String>((r) => r['code'] as String).toSet();
    } catch (e) {
      debugPrint('[PromoRepository] فشل جلب الكوبونات المستخدمة ($e).');
      return const {};
    }
  }

  /// يتحقّق من كوبون ويعيد قيمة الخصم دون تسجيله.
  ///
  /// التحقّق كلّه في القاعدة (`preview_promo`) لا هنا: حساب الخصم في
  /// التطبيق يعني أن نسخة معدَّلة منه تستطيع ادّعاء أي رقم.
  Future<PromoResult> preview({
    required String code,
    required int fare,
  }) async {
    if (!SupabaseService.isReady) {
      return const PromoResult.rejected(PromoRejection.unknown);
    }

    try {
      final rows = await SupabaseService.client.rpc(
        'preview_promo',
        params: {'promo_code': code, 'ride_fare': fare},
      );

      // `preview_promo` تعيد `table(...)` أي صفاً واحداً داخل مصفوفة.
      final list = rows as List;
      if (list.isEmpty) {
        return const PromoResult.rejected(PromoRejection.notFound);
      }
      final row = list.first as Map<String, dynamic>;

      if (row['valid'] == true) {
        return PromoResult.valid((row['discount'] as num?)?.toInt() ?? 0);
      }
      return PromoResult.rejected(
        PromoRejection.fromReason(row['reason'] as String?),
      );
    } catch (e) {
      debugPrint('[PromoRepository] فشل التحقّق من الكوبون ($e).');
      return const PromoResult.rejected(PromoRejection.unknown);
    }
  }

  /// يطبّق الكوبون على رحلة قائمة ويعيد قيمة الخصم المسجَّلة.
  Future<PromoResult> redeem({
    required String code,
    required String rideId,
  }) async {
    if (!SupabaseService.isReady) {
      return const PromoResult.rejected(PromoRejection.unknown);
    }

    try {
      final discount = await SupabaseService.client.rpc(
        'redeem_promo',
        params: {'promo_code': code, 'target_ride': rideId},
      );
      return PromoResult.valid((discount as num?)?.toInt() ?? 0);
    } on PostgrestException catch (e) {
      // الدالة ترفع سبب الرفض كرسالة الاستثناء.
      return PromoResult.rejected(PromoRejection.fromReason(e.message));
    } catch (e) {
      debugPrint('[PromoRepository] فشل استخدام الكوبون ($e).');
      return const PromoResult.rejected(PromoRejection.unknown);
    }
  }
}

final promoRepositoryProvider = Provider((ref) => const PromoRepository());

final availablePromosProvider = FutureProvider<List<PromoCode>>(
  (ref) => ref.watch(promoRepositoryProvider).fetchAvailable(),
);
