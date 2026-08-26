// ═══════════════════════════════════════════════════════════════
// settings_screen.dart - اللغة والمظهر وحالة الخدمات
// ═══════════════════════════════════════════════════════════════
// كانت الترجمة الإنجليزية والثيم الداكن مبنيين بالكامل لكن بلا شاشة
// تُبدّلهما، فلا يصل إليهما المستخدم أبداً. هذه الشاشة تصل الموفّرين
// (`localeProvider` و `themeModeProvider`) بواجهة.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/settings_section.dart';
import '../profile/data/profile_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // ═══ اللغة ═══
          SettingsSection(
            title: l10n.settingsLanguage,
            children: [
              _ChoiceTile(
                label: l10n.settingsLanguageArabic,
                selected: locale.languageCode == 'ar',
                onTap: () => _setLocale(ref, 'ar'),
              ),
              _ChoiceTile(
                label: l10n.settingsLanguageEnglish,
                selected: locale.languageCode == 'en',
                onTap: () => _setLocale(ref, 'en'),
              ),
            ],
          ),

          // ═══ المظهر ═══
          SettingsSection(
            title: l10n.settingsAppearance,
            children: [
              for (final entry in <(ThemeMode, String, IconData)>[
                (ThemeMode.system, l10n.settingsThemeSystem, Icons.brightness_auto_outlined),
                (ThemeMode.light, l10n.settingsThemeLight, Icons.light_mode_outlined),
                (ThemeMode.dark, l10n.settingsThemeDark, Icons.dark_mode_outlined),
              ])
                _ChoiceTile(
                  icon: entry.$3,
                  label: entry.$2,
                  selected: themeMode == entry.$1,
                  onTap: () =>
                      ref.read(themeModeProvider.notifier).setMode(entry.$1),
                ),
            ],
          ),

          // ═══ حالة الخدمات ═══
          // تشخيص مفيد وقت الإعداد: يوضّح إن كان التطبيق يعمل ببيانات
          // وهمية أو بخريطة بديلة، بدل تركه يبدو معطوباً بلا سبب.
          SettingsSection(
            title: l10n.settingsDiagnostics,
            children: [
              _StatusTile(
                ok: AppConfig.hasSupabase,
                label: AppConfig.hasSupabase
                    ? l10n.settingsBackendOn
                    : l10n.settingsBackendOff,
              ),
              _StatusTile(
                ok: AppConfig.hasMapsKey,
                label: AppConfig.hasMapsKey
                    ? l10n.settingsMapsOn
                    : l10n.settingsMapsOff,
              ),
            ],
          ),

          // ═══ عن التطبيق ═══
          SettingsSection(
            title: l10n.settingsAbout,
            children: [
              _InfoTile(
                icon: Icons.info_outline_rounded,
                label: l10n.settingsVersion,
                value: AppConfig.version,
              ),
              _InfoTile(
                icon: Icons.description_outlined,
                label: l10n.settingsTerms,
              ),
              _InfoTile(
                icon: Icons.privacy_tip_outlined,
                label: l10n.settingsPrivacy,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// يبدّل اللغة ويحفظها في الملف الشخصي أيضاً.
  ///
  /// التخزين المحلي وحده يعني أن الخادم لا يعرف لغة المستخدم، فتصل
  /// الإشعارات المُنشأة على الخادم بلغة خاطئة. الفشل هنا لا يُبلَّغ:
  /// اللغة تبدّلت محلياً بنجاح وهو ما يهمّ المستخدم الآن.
  static Future<void> _setLocale(WidgetRef ref, String code) async {
    await ref.read(localeProvider.notifier).setLocale(code);
    try {
      await ref.read(profileRepositoryProvider).updateProfile(locale: code);
      ref.invalidate(userProfileProvider);
    } catch (_) {
      // بلا جلسة أو بلا شبكة — اللغة محفوظة محلياً على أي حال.
    }
  }
}

// ─────────────── خيار قابل للتحديد ───────────────
class _ChoiceTile extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceTile({
    this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: selected
                    ? MishwarakColors.primary
                    : theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? MishwarakColors.primary : null,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: MishwarakColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────── سطر حالة خدمة ───────────────
class _StatusTile extends StatelessWidget {
  final bool ok;
  final String label;

  const _StatusTile({required this.ok, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_outline : Icons.error_outline,
            size: 18,
            color: ok ? MishwarakColors.success : MishwarakColors.warning,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

// ─────────────── سطر معلومة ───────────────
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const _InfoTile({required this.icon, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurface),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          if (value != null)
            Text(
              value!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: MishwarakColors.lightTextMuted,
              ),
            ),
        ],
      ),
    );
  }
}
