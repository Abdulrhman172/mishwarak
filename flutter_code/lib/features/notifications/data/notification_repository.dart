// ═══════════════════════════════════════════════════════════════
// notification_repository.dart - إشعارات المستخدم
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_service.dart';

class AppNotification {
  final String id;
  final String type;
  final String title;
  final String? subtitle;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.isRead,
    required this.createdAt,
  });
}

class NotificationRepository {
  const NotificationRepository();

  Future<List<AppNotification>> fetchAll({int limit = 50}) async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return const [];

    try {
      final rows = await SupabaseService.client
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(limit);

      return rows.map<AppNotification>(_fromRow).toList();
    } catch (e) {
      debugPrint('[NotificationRepository] فشل الجلب ($e).');
      return const [];
    }
  }

  /// يتابع الإشعارات لحظياً (تصل إشعارات جديدة دون تحديث الشاشة).
  Stream<List<AppNotification>> watch() {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return const Stream.empty();

    return SupabaseService.client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<void> markRead(String id) async {
    if (!SupabaseService.isReady) return;
    await SupabaseService.client
        .from('notifications')
        .update({'is_read': true}).eq('id', id);
  }

  Future<void> markAllRead() async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return;

    await SupabaseService.client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', user.id)
        .eq('is_read', false);
  }

  static AppNotification _fromRow(Map<String, dynamic> row) => AppNotification(
        id: row['id'] as String,
        type: row['type'] as String? ?? 'general',
        title: row['title'] as String? ?? '',
        subtitle: row['subtitle'] as String?,
        isRead: row['is_read'] as bool? ?? false,
        createdAt: DateTime.parse(row['created_at'] as String),
      );
}

final notificationRepositoryProvider =
    Provider((ref) => const NotificationRepository());

final notificationsProvider = FutureProvider<List<AppNotification>>(
  (ref) => ref.watch(notificationRepositoryProvider).fetchAll(),
);
