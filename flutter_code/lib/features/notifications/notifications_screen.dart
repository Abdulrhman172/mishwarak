// ═══════════════════════════════════════════════════════════════
// notifications_screen.dart - قائمة الإشعارات
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class _Notif {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  final bool unread;

  const _Notif({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
    this.unread = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _initial = [
    _Notif(
      icon: Icons.card_giftcard,
      color: MishwarakColors.accent,
      title: '🎉 حصلت على 200 نقطة',
      subtitle: 'لإكمالك رحلة اليوم',
      time: 'الآن',
      unread: true,
    ),
    _Notif(
      icon: Icons.local_offer_outlined,
      color: MishwarakColors.primary,
      title: 'كوبون خصم 30%',
      subtitle: 'عرض خاص لهذا الأسبوع فقط',
      time: 'منذ ساعتين',
      unread: true,
    ),
    _Notif(
      icon: Icons.check_circle_outline,
      color: MishwarakColors.success,
      title: 'اكتملت رحلتك',
      subtitle: 'إلى جامعة عدن · 3,800 ر.ي',
      time: 'منذ 3 ساعات',
      unread: true,
    ),
    _Notif(
      icon: Icons.workspace_premium,
      color: MishwarakColors.accent,
      title: 'ترقية VIP بخصم 50%',
      subtitle: 'استمتع بمزايا حصرية',
      time: 'أمس',
    ),
    _Notif(
      icon: Icons.star_rounded,
      color: MishwarakColors.primary,
      title: 'محمد قيمك بـ 5 نجوم',
      subtitle: 'راكب رائع، شكراً!',
      time: 'أمس',
    ),
  ];

  /// فهارس الإشعارات التي قُرئت في هذه الجلسة.
  final Set<int> _read = {};

  bool _isUnread(int i) => _initial[i].unread && !_read.contains(i);

  @override
  Widget build(BuildContext context) {
    final hasUnread = List.generate(_initial.length, (i) => i).any(_isUnread);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: hasUnread
                ? () => setState(
                      () => _read.addAll(
                        List.generate(_initial.length, (i) => i),
                      ),
                    )
                : null,
            child: const Text('تحديد الكل مقروء'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        itemCount: _initial.length,
        itemBuilder: (context, i) => _NotifTile(
          notif: _initial[i],
          unread: _isUnread(i),
          onTap: () => setState(() => _read.add(i)),
        ),
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final _Notif notif;
  final bool unread;
  final VoidCallback onTap;

  const _NotifTile({
    required this.notif,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: unread
            ? MishwarakColors.primary.withOpacity(0.05)
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
                    color: notif.color.withOpacity(0.15),
                  ),
                  child: Icon(notif.icon, color: notif.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        notif.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        notif.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: MishwarakColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        notif.time,
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
