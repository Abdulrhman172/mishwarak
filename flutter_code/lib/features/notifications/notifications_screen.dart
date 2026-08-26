// ═══════════════════════════════════════════════════════════════
// notifications_screen.dart - قائمة الإشعارات
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import 'data/notification_repository.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final notifications = ref.watch(notificationsProvider);
    final repo = ref.read(notificationRepositoryProvider);

    final hasUnread = notifications.maybeWhen(
      data: (list) => list.any((n) => !n.isRead),
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: hasUnread
                ? () async {
                    await repo.markAllRead();
                    ref.invalidate(notificationsProvider);
                  }
                : null,
            child: Text(l10n.markAllRead),
          ),
        ],
      ),
      body: notifications.when(
        data: (list) {
          if (list.isEmpty) return const _EmptyNotifications();
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            itemCount: list.length,
            itemBuilder: (context, i) => _NotifTile(
              notif: list[i],
              onTap: () async {
                if (list[i].isRead) return;
                await repo.markRead(list[i].id);
                ref.invalidate(notificationsProvider);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _EmptyNotifications(message: l10n.notificationsFailed),
      ),
    );
  }
}

// ─────────────── لا توجد إشعارات ───────────────
class _EmptyNotifications extends StatelessWidget {
  /// النص الافتراضي (لا إشعارات) يُبنى في build لأنه يحتاج context
  /// للترجمة — لا يصح كقيمة ثابتة في المعامل.
  final String? message;

  const _EmptyNotifications({this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size: 44,
            color: MishwarakColors.lightTextMuted,
          ),
          const SizedBox(height: 12),
          Text(
            message ?? L10n.of(context).noNotifications,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: MishwarakColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap;

  const _NotifTile({required this.notif, required this.onTap});

  /// أيقونة ولون حسب نوع الإشعار المخزّن في العمود `type`.
  (IconData, Color) get _visual => switch (notif.type) {
        'promo' => (Icons.local_offer_outlined, MishwarakColors.primary),
        'ride' ||
        'ride_completed' =>
          (Icons.check_circle_outline, MishwarakColors.success),
        'points' => (Icons.card_giftcard, MishwarakColors.accent),
        'rating' => (Icons.star_rounded, MishwarakColors.accent),
        _ => (Icons.notifications_none_rounded, MishwarakColors.primary),
      };

  /// عنوان الإشعار بلغة الواجهة للأنواع المعروفة.
  ///
  /// النص المخزَّن في `title` يُكتب على الخادم بلغة واحدة، فيبقى
  /// عربياً في واجهة إنجليزية. نُترجم ما نعرف نوعه، ونستخدم المخزَّن
  /// لما لا نعرفه (إشعارات حملات تسويقية مثلاً).
  String _title(L10n l10n) => switch (notif.type) {
        'ride_completed' => l10n.notifRideCompleted,
        'promo' => l10n.notifPromo,
        'points' => l10n.notifPoints,
        'rating' => l10n.notifRating,
        _ => notif.title,
      };

  /// تفصيل الإشعار — يُبنى من `payload` حين توفّر بيانات المسار.
  String? _subtitle(L10n l10n) =>
      notif.localizedSubtitle((from, to) => l10n.notifRoute(from, to));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final unread = !notif.isRead;
    final (icon, color) = _visual;
    final subtitle = _subtitle(l10n);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: unread
            ? MishwarakColors.primary.withValues(alpha: 0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // نقطة "غير مقروء"
                SizedBox(
                  width: 12,
                  child: unread
                      ? Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 18),
                          decoration: const BoxDecoration(
                            color: MishwarakColors.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color.withValues(alpha: 0.15),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _title(l10n),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: MishwarakColors.lightTextMuted,
                          ),
                        ),
                      ],
                      const SizedBox(height: 5),
                      Text(
                        formatRelative(context, notif.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: MishwarakColors.lightTextLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
