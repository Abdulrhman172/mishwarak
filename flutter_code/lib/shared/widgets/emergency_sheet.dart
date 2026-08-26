// ═══════════════════════════════════════════════════════════════
// emergency_sheet.dart - زر الطوارئ (SOS)
// ═══════════════════════════════════════════════════════════════
// كان زر الطوارئ في الشاشة الرئيسية يحمل `// TODO: تفعيل الطوارئ`
// ويُغلق النافذة بلا أثر، وزر الرحلة الجارية يعرض "تم إبلاغ جهات
// الطوارئ" دون أن يُبلغ أحداً. في تطبيق نقل ركّاب هذا أسوأ من زرّ
// معطّل: الراكب يظن أن النجدة في الطريق.
//
// الآن يفتح إجراءين حقيقيين: اتصال بالطوارئ، ورسالة تحمل الموقع
// إلى جهات الطوارئ المحفوظة — ويقول صراحةً حين لا توجد جهات.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/location/location_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/launchers.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../l10n/app_localizations.dart';

/// يفتح نافذة الطوارئ.
///
/// [lat]/[lng] موقع يُرفق بالرسالة؛ إن غاب نستخدم آخر موقع معروف
/// للمستخدم، وإن لم يوجد نرسل الرسالة بلا رابط بدل حجب الإرسال.
Future<void> showEmergencySheet(
  BuildContext context, {
  double? lat,
  double? lng,
}) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _EmergencySheet(lat: lat, lng: lng),
  );
}

class _EmergencySheet extends ConsumerWidget {
  final double? lat;
  final double? lng;

  const _EmergencySheet({this.lat, this.lng});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final contacts =
        ref.watch(emergencyContactsProvider).valueOrNull ?? const [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: MishwarakColors.danger.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: MishwarakColors.danger,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.emergencyTitle,
                        style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 2),
                    Text(
                      l10n.emergencyBody,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: MishwarakColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ═══ اتصال بالطوارئ ═══
          ElevatedButton.icon(
            onPressed: () => _call(context),
            icon: const Icon(Icons.call_rounded, size: 20),
            label: Text(l10n.emergencyCallPolice(AppConfig.emergencyNumber)),
            style: ElevatedButton.styleFrom(
              backgroundColor: MishwarakColors.danger,
              minimumSize: const Size(double.infinity, 54),
            ),
          ),
          const SizedBox(height: 10),

          // ═══ إبلاغ جهات الطوارئ ═══
          if (contacts.isEmpty)
            _NoContactsNotice(l10n: l10n)
          else
            OutlinedButton.icon(
              onPressed: () => _notify(context, ref, contacts),
              icon: const Icon(Icons.sms_outlined, size: 20),
              label: Text(l10n.emergencyNotifyContacts),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                side: const BorderSide(
                  color: MishwarakColors.danger,
                  width: 1.5,
                ),
                foregroundColor: MishwarakColors.danger,
              ),
            ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _call(BuildContext context) async {
    // لا نُغلق النافذة قبل المحاولة: إن تعذّر فتح تطبيق الاتصال يجب
    // أن تبقى بقية الخيارات أمام المستخدم.
    final ok = await Launchers.call(context, AppConfig.emergencyNumber);
    if (ok && context.mounted) Navigator.pop(context);
  }

  Future<void> _notify(
    BuildContext context,
    WidgetRef ref,
    List<EmergencyContact> contacts,
  ) async {
    final l10n = L10n.of(context);

    // الموقع المُمرَّر أولاً (موقع الرحلة)، ثم آخر موقع معروف.
    final known = ref.read(locationProvider).valueOrNull;
    final latitude = lat ?? known?.lat;
    final longitude = lng ?? known?.lng;

    final body = (latitude != null && longitude != null)
        ? l10n.emergencySmsBody(Launchers.mapsLink(latitude, longitude))
        : l10n.emergencySmsNoLocation;

    final ok = await Launchers.sms(
      context,
      recipients: contacts.map((c) => c.phone).toList(),
      body: body,
    );
    if (ok && context.mounted) Navigator.pop(context);
  }
}

// ─────────────── لا توجد جهات طوارئ ───────────────
class _NoContactsNotice extends StatelessWidget {
  final L10n l10n;

  const _NoContactsNotice({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: MishwarakColors.lightTextMuted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.emergencyNoContacts,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: MishwarakColors.lightTextMuted),
            ),
          ),
        ],
      ),
    );
  }
}
