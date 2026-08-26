// ═══════════════════════════════════════════════════════════════
// launchers.dart - فتح الاتصال والرسائل والبريد والخرائط
// ═══════════════════════════════════════════════════════════════
// كانت أزرار "اتصال بالسائق" و"إبلاغ الطوارئ" تعرض SnackBar فقط —
// أي أنها تُخبر المستخدم أن شيئاً حدث ولم يحدث. هذه الطبقة تنفّذها
// فعلاً عبر `url_launcher`، وتُبلغ بصدق حين يتعذّر ذلك.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';

class Launchers {
  Launchers._();

  /// يفتح تطبيق الاتصال على [phone].
  static Future<bool> call(BuildContext context, String phone) =>
      _open(context, Uri(scheme: 'tel', path: _clean(phone)));

  /// يفتح تطبيق الرسائل برسالة جاهزة.
  ///
  /// [recipients] قد تحوي أكثر من رقم — تُفصل بفاصلة منقوطة، وهي
  /// الصيغة التي يقبلها iOS و Android معاً.
  static Future<bool> sms(
    BuildContext context, {
    required List<String> recipients,
    required String body,
  }) {
    if (recipients.isEmpty) return Future.value(false);

    return _open(
      context,
      Uri(
        scheme: 'sms',
        path: recipients.map(_clean).join(';'),
        queryParameters: {'body': body},
      ),
    );
  }

  static Future<bool> email(BuildContext context, String address) =>
      _open(context, Uri(scheme: 'mailto', path: address));

  /// يفتح محادثة واتساب مع الرقم.
  static Future<bool> whatsapp(BuildContext context, String phone) => _open(
        context,
        Uri.parse('https://wa.me/${_clean(phone).replaceAll('+', '')}'),
      );

  /// رابط موقع على خرائط Google — يصلح للمشاركة عبر أي تطبيق.
  static String mapsLink(double lat, double lng) =>
      'https://maps.google.com/?q=$lat,$lng';

  /// يزيل المسافات والشرطات التي يضيفها المستخدمون عند إدخال الأرقام.
  static String _clean(String phone) =>
      phone.replaceAll(RegExp(r'[\s\-()]'), '');

  /// يحاول الفتح ويعرض رسالة صريحة عند الفشل.
  ///
  /// الفشل وارد: محاكي بلا تطبيق اتصال، أو متصفّح يمنع مخطّط `tel:`.
  /// إخفاؤه يعني أن المستخدم يظن أن مكالمة الطوارئ بدأت وهي لم تبدأ.
  static Future<bool> _open(BuildContext context, Uri uri) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) _failed(context);
      return launched;
    } catch (_) {
      if (context.mounted) _failed(context);
      return false;
    }
  }

  static void _failed(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(L10n.of(context).emergencyOpenFailed)),
      );
  }
}
