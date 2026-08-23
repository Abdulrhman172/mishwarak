// ═══════════════════════════════════════════════════════════════
// profile_screen.dart - الملف الشخصي (البيانات، النقاط، الإعدادات)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/driver_avatar.dart';
import 'data/profile_repository.dart';

/// النقاط المطلوبة للمستوى الذهبي — تُعرض كهدف في بطاقة النقاط.
const _goldTierPoints = 3000;

/// عنصر داخل قسم إعدادات.
class _SettingItem {
  final IconData icon;
  final String label;
  final String value;
  final bool verified;
  final bool primary; // عنصر "إضافة..." بلون التطبيق

  const _SettingItem({
    required this.icon,
    required this.label,
    this.value = '',
    this.verified = false,
    this.primary = false,
  });
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final profileAsync = ref.watch(userProfileProvider);
    final placesAsync = ref.watch(savedPlacesProvider);
    final contactsAsync = ref.watch(emergencyContactsProvider);

    final profile = profileAsync.valueOrNull;
    final points = profile?.points ?? 0;
    final remaining = (_goldTierPoints - points).clamp(0, _goldTierPoints);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(userProfileProvider);
              ref.invalidate(savedPlacesProvider);
              ref.invalidate(emergencyContactsProvider);
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // ═══ بطاقة المستخدم ═══
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                DriverAvatar(
                  size: 68,
                  initials: _initialsOf(profile?.fullName, profile?.phone),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (profile?.fullName.isNotEmpty ?? false)
                            ? profile!.fullName
                            : l10n.defaultUserName,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile?.email ?? profile?.phone ?? '—',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: MishwarakColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: MishwarakColors.accent,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            (profile?.rating ?? 5).toStringAsFixed(2),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              profile == null
                                  ? ''
                                  : l10n.memberSince(profile.createdAt.year),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: MishwarakColors.lightTextMuted,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ═══ بطاقة النقاط ═══
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: MishwarakColors.accentGradient,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.yourPoints,
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${formatMoney(points)} ',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: l10n.points,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        remaining == 0
                            ? l10n.goldReached
                            : l10n.pointsToGold(formatMoney(remaining)),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // شريط التقدّم
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: SizedBox(
                          width: 140,
                          height: 5,
                          child: LinearProgressIndicator(
                            value: (points / _goldTierPoints).clamp(0.0, 1.0),
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // ═══ الأقسام ═══
          const SizedBox(height: 20),
          _SettingSection(
            title: l10n.personalInfo,
            items: [
              _SettingItem(
                icon: Icons.person_outline,
                label: l10n.name,
                value: (profile?.fullName.isNotEmpty ?? false)
                    ? profile!.fullName
                    : l10n.notAddedYet,
              ),
              _SettingItem(
                icon: Icons.phone_outlined,
                label: l10n.phone,
                value: profile?.phone ?? '—',
                // الهاتف مُتحقَّق منه دائماً لأنه وسيلة تسجيل الدخول.
                verified: profile?.phone != null,
              ),
              _SettingItem(
                icon: Icons.mail_outline,
                label: l10n.email,
                value: profile?.email ?? l10n.notAddedYet,
              ),
            ],
          ),
          _SettingSection(
            title: l10n.savedPlaces,
            items: [
              for (final place in placesAsync.valueOrNull ?? const <SavedPlace>[])
                _SettingItem(
                  icon: switch (place.label) {
                    'home' => Icons.home_outlined,
                    'work' => Icons.work_outline,
                    _ => Icons.place_outlined,
                  },
                  label: place.name,
                  value: place.address,
                ),
              _SettingItem(
                icon: Icons.add,
                label: l10n.addAddress,
                primary: true,
              ),
            ],
          ),
          _SettingSection(
            title: l10n.emergencyContacts,
            items: [
              for (final c
                  in contactsAsync.valueOrNull ?? const <EmergencyContact>[])
                _SettingItem(
                  icon: Icons.person_outline,
                  label: c.name,
                  value: c.phone,
                ),
              _SettingItem(
                icon: Icons.add,
                label: l10n.addContact,
                primary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// أول حرف من الاسم، أو آخر رقمين من الجوال إن لم يوجد اسم.
  static String _initialsOf(String? fullName, String? phone) {
    final name = fullName?.trim() ?? '';
    if (name.isNotEmpty) return name.characters.first;
    if (phone != null && phone.length >= 2) {
      return phone.substring(phone.length - 2);
    }
    return '؟';
  }
}

// ─────────────── قسم إعدادات ───────────────
class _SettingSection extends StatelessWidget {
  final String title;
  final List<_SettingItem> items;

  const _SettingSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: MishwarakColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.dividerColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: theme.dividerColor),
                  _SettingTile(item: items[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final _SettingItem item;

  const _SettingTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        item.primary ? MishwarakColors.primary : theme.colorScheme.onSurface;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Icon(item.icon, size: 18, color: color),
            const SizedBox(width: 12),
            Text(
              item.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            if (item.value.isNotEmpty)
              Flexible(
                child: Text(
                  item.value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: MishwarakColors.lightTextMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            if (item.verified) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.verified,
                size: 14,
                color: MishwarakColors.success,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
