// ═══════════════════════════════════════════════════════════════
// payment_method_repository.dart - طرق الدفع المحفوظة
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_service.dart';

enum PaymentKind { wallet, cash, card }

/// طريقة دفع يملكها المستخدم.
///
/// لا تحمل رقم بطاقة: القاعدة تخزّن آخر أربعة أرقام ورمز المزوّد فقط.
class SavedPaymentMethod {
  final String id;
  final PaymentKind kind;
  final String? label;
  final String? last4;
  final String? brand;
  final bool isDefault;

  const SavedPaymentMethod({
    required this.id,
    required this.kind,
    this.label,
    this.last4,
    this.brand,
    this.isDefault = false,
  });

  static SavedPaymentMethod fromRow(Map<String, dynamic> row) =>
      SavedPaymentMethod(
        id: row['id'] as String,
        kind: PaymentKind.values.firstWhere(
          (k) => k.name == row['kind'],
          orElse: () => PaymentKind.card,
        ),
        label: row['label'] as String?,
        last4: row['last4'] as String?,
        brand: row['brand'] as String?,
        isDefault: row['is_default'] as bool? ?? false,
      );
}

class PaymentMethodRepository {
  const PaymentMethodRepository();

  Future<List<SavedPaymentMethod>> fetchAll() async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return const [];

    try {
      final rows = await SupabaseService.client
          .from('payment_methods')
          .select()
          .eq('user_id', user.id)
          .order('created_at');

      return rows.map<SavedPaymentMethod>(SavedPaymentMethod.fromRow).toList();
    } catch (e) {
      debugPrint('[PaymentMethodRepository] فشل الجلب ($e).');
      return const [];
    }
  }

  /// يجعل طريقة دفع هي الافتراضية.
  ///
  /// إلغاء الافتراضية القديمة أولاً ضروري: على الجدول فهرس فريد يمنع
  /// وجود اثنتين افتراضيتين لنفس المستخدم.
  Future<void> setDefault(String id) async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return;

    final client = SupabaseService.client;
    await client
        .from('payment_methods')
        .update({'is_default': false})
        .eq('user_id', user.id)
        .eq('is_default', true);

    await client
        .from('payment_methods')
        .update({'is_default': true})
        .eq('id', id)
        .eq('user_id', user.id);
  }

  Future<void> remove(String id) async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return;

    await SupabaseService.client
        .from('payment_methods')
        .delete()
        .eq('id', id)
        .eq('user_id', user.id);
  }
}

final paymentMethodRepositoryProvider =
    Provider((ref) => const PaymentMethodRepository());

final paymentMethodsProvider = FutureProvider<List<SavedPaymentMethod>>(
  (ref) => ref.watch(paymentMethodRepositoryProvider).fetchAll(),
);
