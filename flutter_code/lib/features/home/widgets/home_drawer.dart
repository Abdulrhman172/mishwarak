// ═══════════════════════════════════════════════════════════════
// home_drawer.dart - القائمة الجانبية (بطاقة المستخدم + التنقّل)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/driver_avatar.dart';
import '../../auth/data/auth_repository.dart';
import '../../notifications/data/notification_repository.dart';
import '../../profile/data/profile_repository.dart';
import '../../wallet/data/wallet_repository.dart';

/// عنصر واحد في قائمة التنقّل.
class _MenuItem {
  final IconData icon;
  final String label;

  /// المسار المقصود.
  ///
  /// مطلوب لا اختياري: كان `String?` وخمسة عناصر تتركه فارغاً فتعرض
  /// "قيد الإنشاء". النوع نفسه يمنع الآن إضافة عنصر بلا وجهة.
  final String route;

  /// نص شارة صغيرة (عدد غير مقروء أو "جديد").
  final String? badge;

  /// يُلوَّن العنصر بلون التمييز (اشتراك VIP).
  final bool highlight;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.route,
    this.badge,
    this.highlight = false,
  });
}

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    // عدد الإشعارات غير المقروءة يظهر كشارة على عنصر الإشعارات.
    final unread = ref.watch(notificationsProvider).maybeWhen(
          data: (list) => list.where((n) => !n.isRead).length,
          orElse: () => 0,
        );

    final items = <_MenuItem>[
      _MenuItem(
        icon: Icons.person_outline,
        label: l10n.profile,
        route: AppRoutes.under(AppRoutes.profile),
      ),
      _MenuItem(
        icon: Icons.access_time_rounded,
        label: l10n.myTrips,
        route: AppRoutes.under(AppRoutes.history),
      ),
      _MenuItem(
        icon: Icons.account_balance_wallet_outlined,
        label: l10n.walletTitle,
        route: AppRoutes.under(AppRoutes.wallet),
      ),
      _MenuItem(
        icon: Icons.notifications_none_rounded,
        label: l10n.notifications,
        route: AppRoutes.under(AppRoutes.notifications),
        badge: unread > 0 ? '$unread' : null,
      ),
      _MenuItem(
        icon: Icons.local_offer_outlined,
        label: l10n.menuPromos,
        route: AppRoutes.under(AppRoutes.promos),
      ),
      _MenuItem(
        icon: Icons.card_giftcard,
        label: l10n.menuRewards,
        route: AppRoutes.under(AppRoutes.rewards),
        badge: l10n.menuRewardsBadge,
      ),
      _MenuItem(
        icon: Icons.workspace_premium_outlined,
        label: l10n.menuVip,
        route: AppRoutes.under(AppRoutes.vip),
        highlight: true,
      ),
      _MenuItem(
        icon: Icons.shield_outlined,
        label: l10n.emergencyContacts,
        route: AppRoutes.under(AppRoutes.profile),
      ),
      _MenuItem(
        icon: Icons.settings_outlined,
        label: l10n.settings,
        route: AppRoutes.under(AppRoutes.settings),
      ),
      _MenuItem(
        icon: Icons.help_outline_rounded,
        label: l10n.menuHelp,
        route: AppRoutes.under(AppRoutes.help),
      ),
    ];

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      child: Column(
        children: [
          const _DrawerHeaderCard(),

          // ═══ عناصر التنقّل ═══
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                for (final item in items)
                  _MenuTile(
                    item: item,
                    onTap: () => _openItem(context, item),
                  ),
              ],
            ),
          ),

          // ═══ تسجيل الخروج ═══
          const Divider(height: 1),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: MishwarakColors.danger,
              size: 20,
            ),
            title: Text(
              l10n.signOut,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: MishwarakColors.danger,
              ),
            ),
            onTap: () => _confirmSignOut(context, ref, l10n),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// يفتح الشاشة المقصودة.
  ///
  /// نُغلق الدرج أولاً حتى لا تبقى الشاشة السابقة تحته أثناء الانتقال.
  void _openItem(BuildContext context, _MenuItem item) {
    Navigator.pop(context);
    context.push(item.route);
  }

  Future<void> _confirmSignOut(
    BuildContext context,
    WidgetRef ref,
    L10n l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.signOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: MishwarakColors.danger,
            ),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(authRepositoryProvider).signOut();
    // لا حاجة للتنقّل يدوياً: حارس المسارات يتابع تغيّر الجلسة
    // وينقل المستخدم لشاشة الدخول تلقائياً.
  }
}

// ─────────────── رأس الدرج (بطاقة المستخدم) ───────────────
class _DrawerHeaderCard extends ConsumerWidget {
  const _DrawerHeaderCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final balance = ref.watch(walletBalanceProvider);

    final name = (profile?.fullName.isNotEmpty ?? false)
        ? profile!.fullName
        : l10n.defaultUserName;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: const BoxDecoration(
        gradient: MishwarakColors.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // زر الإغلاق + التقييم
            Row(
              children: [
                _CircleIconButton(
                  icon: Icons.close_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: MishwarakColors.accent,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (profile?.rating ?? 5).toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // الصورة والاسم
            Row(
              children: [
                DriverAvatar(size: 56, initials: _initialsOf(name)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile?.phone ?? '—',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ═══ رصيد المحفظة ═══
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.menuWalletBalance,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 10,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${balance.when(
                                  data: formatMoney,
                                  loading: () => '—',
                                  error: (_, __) => '—',
                                )} ',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextSpan(
                                text: l10n.currency,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // زر شحن سريع → يفتح المحفظة
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('${AppRoutes.home}/wallet');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          l10n.menuTopUp,
                          style: const TextStyle(
                            color: MishwarakColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// أول حرف من الاسم — يُستخدم بديلاً عن الصورة.
  static String _initialsOf(String name) {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '؟' : trimmed.characters.first;
  }
}

// ─────────────── زر دائري شفاف داخل الرأس ───────────────
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

// ─────────────── عنصر قائمة ───────────────
class _MenuTile extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onTap;

  const _MenuTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        item.highlight ? MishwarakColors.accent : theme.colorScheme.onSurface;

    return Material(
      color: item.highlight
          ? MishwarakColors.accent.withValues(alpha: 0.08)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.highlight
                      ? MishwarakColors.accent.withValues(alpha: 0.2)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, size: 18, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.badge != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    // الشارة النصية ("جديد") بلون التطبيق، والعددية بالأحمر.
                    color: int.tryParse(item.badge!) == null
                        ? MishwarakColors.primary
                        : MishwarakColors.danger,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14,
                color: MishwarakColors.lightTextLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
