// ═══════════════════════════════════════════════════════════════
// settings_section.dart - قسم بطاقة بعنوان وصفوف مفصولة
// ═══════════════════════════════════════════════════════════════
// شكل مشترك بين شاشتي الملف الشخصي والإعدادات: عنوان صغير باهت
// فوق بطاقة تحوي صفوفاً يفصلها خط رفيع.
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SettingsSection extends StatelessWidget {
  final String title;

  /// إجراء اختياري في أقصى العنوان (مثل "إضافة").
  final Widget? action;

  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    this.action,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: MishwarakColors.lightTextMuted,
                  ),
                ),
              ),
              if (action != null) action!,
            ],
          ),
          const SizedBox(height: 8),
          // `Material` لا `Container`: لون الخلفية على DecoratedBox عادي
          // يعترض تموّج اللمس (ink) القادم من الصفوف بداخله، فتبدو
          // غير قابلة للضغط رغم أنها كذلك.
          Material(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: theme.dividerColor),
                    children[i],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
