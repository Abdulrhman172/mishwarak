// ═══════════════════════════════════════════════════════════════
// wallet_repository.dart - الرصيد والمعاملات
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_service.dart';

class WalletTransaction {
  final String id;
  final String description;
  final int amount;
  final bool isCredit;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.isCredit,
    required this.createdAt,
  });
}

class WalletRepository {
  const WalletRepository();

  /// الرصيد الحالي بالريال اليمني.
  ///
  /// محسوب في قاعدة البيانات من مجموع المعاملات (دالة `my_wallet_balance`)
  /// بدل تخزين رقم قابل للتضارب.
  Future<int> fetchBalance() async {
    if (!SupabaseService.isReady || !SupabaseService.isSignedIn) return 0;

    try {
      final result = await SupabaseService.client.rpc('my_wallet_balance');
      return (result as num?)?.toInt() ?? 0;
    } catch (e) {
      debugPrint('[WalletRepository] فشل جلب الرصيد ($e).');
      return 0;
    }
  }

  Future<List<WalletTransaction>> fetchTransactions({int limit = 30}) async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return const [];

    try {
      final rows = await SupabaseService.client
          .from('wallet_transactions')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(limit);

      return rows
          .map<WalletTransaction>((row) => WalletTransaction(
                id: row['id'] as String,
                description: row['description'] as String? ?? '',
                amount: (row['amount'] as num?)?.toInt() ?? 0,
                isCredit: row['type'] == 'credit',
                createdAt: DateTime.parse(row['created_at'] as String),
              ))
          .toList();
    } catch (e) {
      debugPrint('[WalletRepository] فشل جلب المعاملات ($e).');
      return const [];
    }
  }
}

final walletRepositoryProvider = Provider((ref) => const WalletRepository());

final walletBalanceProvider =
    FutureProvider<int>((ref) => ref.watch(walletRepositoryProvider).fetchBalance());

final walletTransactionsProvider = FutureProvider<List<WalletTransaction>>(
  (ref) => ref.watch(walletRepositoryProvider).fetchTransactions(),
);
