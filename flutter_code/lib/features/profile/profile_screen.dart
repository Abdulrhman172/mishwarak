// ═══════════════════════════════════════════════════════════════
// profile_screen.dart - الملف الشخصي (البيانات، النقاط، الإعدادات)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/driver_avatar.dart';

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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: false,
        actions: [TextButton(onPressed: () {}, child: const Text('تعديل'))],
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
                const DriverAvatar(size: 68, initials: 'أ'),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('أحمد الشيباني', style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 4),
                      Text(
                        'ahmed@example.com',
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
                            '4.90',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '· عضو منذ 2023',
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
                      const Text(
                        'نقاطك المتاحة',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      const SizedBox(height: 2),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '2,450 ',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: 'نقطة',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '550 نقطة لمستوى ذهبي',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      const SizedBox(height: 8),
                      // شريط التقدّم
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: SizedBox(
                          width: 140,
                          height: 5,
                          child: LinearProgressIndicator(
                            value: 0.8,
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
          const _SettingSection(
            title: 'المعلومات الشخصية',
            items: [
              _SettingItem(
                icon: Icons.person_outline,
                label: 'الاسم',
                value: 'أحمد الشيباني',
              ),
              _SettingItem(
                icon: Icons.phone_outlined,
                label: 'الجوال',
                value: '+967 77 123 4567',
                verified: true,
              ),
              _SettingItem(
                icon: Icons.mail_outline,
                label: 'البريد',
                value: 'ahmed@example.com',
              ),
            ],
          ),
          const _SettingSection(
            title: 'العناوين المحفوظة',
            items: [
              _SettingItem(
                icon: Icons.home_outlined,
                label: 'المنزل',
                value: 'حي الشيخ عثمان، عدن',
              ),
              _SettingItem(
                icon: Icons.work_outline,
                label: 'العمل',
                value: 'شارع كالتكس، المعلا',
              ),
              _SettingItem(
                icon: Icons.add,
                label: 'إضافة عنوان',
                primary: true,
              ),
            ],
          ),
          const _SettingSection(
            title: 'جهات الطوارئ',
            items: [
              _SettingItem(
                icon: Icons.person_outline,
                label: 'والدي',
                value: '+967 77 xxx xxxx',
              ),
              _SettingItem(
                icon: Icons.add,
                label: 'إضافة جهة اتصال',
                primary: true,
              ),
            ],
          ),
        ],
      ),
    );
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
