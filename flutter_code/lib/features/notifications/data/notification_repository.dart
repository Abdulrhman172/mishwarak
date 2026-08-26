// ═══════════════════════════════════════════════════════════════
// notification_repository.dart - إشعارات المستخدم
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_service.dart';

class AppNotification {
  final String id;
  final String type;

  /// النص كما خُزِّن — بلغة واحدة، يُستخدم حين لا يعرف التطبيق النوع.
  final String title;
  final String? subtitle;

  /// بيانات الإشعار مفصولة عن نصّه، لبناء نص مترجَم عند العرض.
  final Map<String, dynamic> payload;

  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.payload = const {},
    required this.isRead,
    required this.createdAt,
  });

  String? get _from => payload['from'] as String?;
  String? get _to => payload['to'] as String?;

  /// عنوان مترجَم للأنواع المعروفة، وإلا النص المخزَّن.
  String localizedTitle(String Function(String type) translate) {
    final translated = translate(type);
    return translated.isEmpty ? title : translated;
  }

  /// تفصيل مترجَم — يُبنى من `payload` لا من النص المخزَّن.
  String? localizedSubtitle(String Function(String from, String to) route) {
    final from = _from;
    final to = _to;
    if (from != null && to != null) return route(from, to);
    return subtitle;
  }
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
        // العمود أُضيف لاحقاً، فقد تصل صفوف أقدم بلا قيمة.
        payload: (row['payload'] as Map?)?.cast<String, dynamic>() ?? const {},
        isRead: row['is_read'] as bool? ?? false,
        createdAt: DateTime.parse(row['created_at'] as String),
      );
}

final notificationRepositoryProvider =
    Provider((ref) => const NotificationRepository());

final notificationsProvider = FutureProvider<List<AppNotification>>(
  (ref) => ref.watch(notificationRepositoryProvider).fetchAll(),
);
