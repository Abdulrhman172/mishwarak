// ═══════════════════════════════════════════════════════════════
// help_screen.dart - الأسئلة الشائعة والتواصل مع الدعم
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/launchers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/settings_section.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    final faq = <(String, String)>[
      (l10n.helpQ1, l10n.helpA1),
      (l10n.helpQ2, l10n.helpA2),
      (l10n.helpQ3, l10n.helpA3),
      (l10n.helpQ4, l10n.helpA4),
      (l10n.helpQ5, l10n.helpA5),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpTitle), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          SettingsSection(
            title: l10n.helpFaqTitle,
            children: [
              for (final (question, answer) in faq)
                _FaqTile(question: question, answer: answer),
            ],
          ),
          SettingsSection(
            title: l10n.helpContactTitle,
            children: [
              _ContactTile(
                icon: Icons.phone_rounded,
                label: l10n.helpCall,
                value: AppConfig.supportPhone,
                onTap: () => Launchers.call(context, AppConfig.supportPhone),
              ),
              _ContactTile(
                icon: Icons.chat_rounded,
                label: l10n.helpWhatsapp,
                value: AppConfig.supportPhone,
                onTap: () => Launchers.whatsapp(context, AppConfig.supportPhone),
              ),
              _ContactTile(
                icon: Icons.mail_outline_rounded,
                label: l10n.helpEmail,
                value: AppConfig.supportEmail,
                onTap: () => Launchers.email(context, AppConfig.supportEmail),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────── سؤال قابل للطي ───────────────
class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      // ExpansionTile يرسم خطوطه الخاصة فوق حدود البطاقة.
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          question,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            answer,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: MishwarakColors.lightTextMuted, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// ─────────────── قناة تواصل ───────────────
class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
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
            Icon(icon, size: 18, color: MishwarakColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: MishwarakColors.lightTextMuted),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: MishwarakColors.lightTextLight,
            ),
          ],
        ),
      ),
    );
  }
}
