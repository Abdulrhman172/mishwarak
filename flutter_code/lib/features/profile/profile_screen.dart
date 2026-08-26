// ═══════════════════════════════════════════════════════════════
// profile_screen.dart - الملف الشخصي (البيانات، النقاط، العناوين)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/driver_avatar.dart';
import '../../shared/widgets/settings_section.dart';
import 'data/profile_repository.dart';
import 'widgets/profile_sheets.dart';

/// النقاط المطلوبة للمستوى الذهبي — تُعرض كهدف في بطاقة النقاط.
const _goldTierPoints = 3000;

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

    final places = placesAsync.valueOrNull ?? const <SavedPlace>[];
    final contacts = contactsAsync.valueOrNull ?? const <EmergencyContact>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => _refresh(ref),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(ref),
        child: ListView(
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
                  IconButton(
                    tooltip: l10n.editProfile,
                    onPressed: () => showEditProfileSheet(context, ref),
                    icon: const Icon(Icons.edit_outlined, size: 20),
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
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: SizedBox(
                            width: 140,
                            height: 5,
                            child: LinearProgressIndicator(
                              value: (points / _goldTierPoints).clamp(0.0, 1.0),
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.3),
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.white),
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
                      color: Colors.white.withValues(alpha: 0.2),
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

            // ═══ المعلومات الشخصية ═══
            const SizedBox(height: 20),
            SettingsSection(
              title: l10n.personalInfo,
              action: TextButton(
                onPressed: () => showEditProfileSheet(context, ref),
                child: Text(l10n.edit),
              ),
              children: [
                _InfoRow(
                  icon: Icons.person_outline,
                  label: l10n.name,
                  value: (profile?.fullName.isNotEmpty ?? false)
                      ? profile!.fullName
                      : l10n.notAddedYet,
                  onTap: () => showEditProfileSheet(context, ref),
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: l10n.phone,
                  value: profile?.phone ?? '—',
                  // الهاتف مُتحقَّق منه دائماً لأنه وسيلة تسجيل الدخول،
                  // ولهذا السبب نفسه لا يُعدَّل من هنا.
                  verified: profile?.phone != null,
                ),
                _InfoRow(
                  icon: Icons.mail_outline,
                  label: l10n.email,
                  value: profile?.email ?? l10n.notAddedYet,
                  onTap: () => showEditProfileSheet(context, ref),
                ),
              ],
            ),

            // ═══ العناوين المحفوظة ═══
            SettingsSection(
              title: l10n.savedPlaces,
              children: [
                for (final place in places)
                  _InfoRow(
                    icon: switch (place.label) {
                      'home' => Icons.home_outlined,
                      'work' => Icons.work_outline,
                      _ => Icons.place_outlined,
                    },
                    label: place.name,
                    value: place.address,
                    onTap: () =>
                        showSavedPlaceSheet(context, ref, existing: place),
                    onDelete: () => _deletePlace(context, ref, place),
                  ),
                _InfoRow(
                  icon: Icons.add,
                  label: l10n.addAddress,
                  primary: true,
                  onTap: () => showSavedPlaceSheet(context, ref),
                ),
              ],
            ),

            // ═══ جهات الطوارئ ═══
            SettingsSection(
              title: l10n.emergencyContacts,
              children: [
                for (final contact in contacts)
                  _InfoRow(
                    icon: Icons.person_outline,
                    label: contact.name,
                    value: contact.phone,
                    onTap: () => showEmergencyContactSheet(
                      context,
                      ref,
                      existing: contact,
                    ),
                    onDelete: () => _deleteContact(context, ref, contact),
                  ),
                _InfoRow(
                  icon: Icons.add,
                  label: l10n.addContact,
                  primary: true,
                  onTap: () => showEmergencyContactSheet(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void _refresh(WidgetRef ref) {
    ref.invalidate(userProfileProvider);
    ref.invalidate(savedPlacesProvider);
    ref.invalidate(emergencyContactsProvider);
  }

  static Future<void> _deletePlace(
    BuildContext context,
    WidgetRef ref,
    SavedPlace place,
  ) async {
    final l10n = L10n.of(context);
    if (!await confirmDelete(context, l10n.deletePlaceConfirm(place.name))) {
      return;
    }

    try {
      await ref.read(profileRepositoryProvider).deleteSavedPlace(place.id);
      ref.invalidate(savedPlacesProvider);
      if (context.mounted) _toast(context, l10n.placeDeleted);
    } catch (_) {
      if (context.mounted) _toast(context, l10n.deleteFailed);
    }
  }

  static Future<void> _deleteContact(
    BuildContext context,
    WidgetRef ref,
    EmergencyContact contact,
  ) async {
    final l10n = L10n.of(context);
    if (!await confirmDelete(context, l10n.deleteContactConfirm(contact.name))) {
      return;
    }

    try {
      await ref
          .read(profileRepositoryProvider)
          .deleteEmergencyContact(contact.id);
      ref.invalidate(emergencyContactsProvider);
      if (context.mounted) _toast(context, l10n.contactDeleted);
    } catch (_) {
      if (context.mounted) _toast(context, l10n.deleteFailed);
    }
  }

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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

// ─────────────── صف معلومة قابل للتعديل والحذف ───────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool verified;

  /// عنصر "إضافة..." بلون التطبيق.
  final bool primary;

  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const _InfoRow({
    required this.icon,
    required this.label,
    this.value = '',
    this.verified = false,
    this.primary = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final color =
        primary ? MishwarakColors.primary : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 4, onDelete == null ? 14 : 4, 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            const Spacer(),
            if (value.isNotEmpty)
              Flexible(
                child: Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: MishwarakColors.lightTextMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            if (verified) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.verified,
                size: 14,
                color: MishwarakColors.success,
              ),
            ],
            if (onDelete != null)
              IconButton(
                tooltip: l10n.delete,
                onPressed: onDelete,
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: MishwarakColors.danger,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
