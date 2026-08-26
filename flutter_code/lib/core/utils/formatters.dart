// ═══════════════════════════════════════════════════════════════
// formatters.dart - تنسيق المبالغ والتواريخ
// ═══════════════════════════════════════════════════════════════
// كانت أسماء الشهور و"اليوم/أمس" ثابتة بالعربية في الكود، فيرى
// مستخدم الإنجليزية واجهةً إنجليزية بتواريخ عربية. الآن تأتي أسماء
// الشهور من `intl` بلغة الواجهة، والكلمات الوصفية من ملفات الترجمة.
library;

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

/// يضيف الفاصلة الألفية: `15300` → `15,300`.
///
/// الأرقام لاتينية في اللغتين: هي المستخدَمة في الأسعار والفواتير
/// في اليمن، والخلط بينها وبين الأرقام العربية-الهندية يربك القراءة.
String formatMoney(int amount) {
  final abs = amount.abs().toString();
  final withCommas = abs.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]},',
  );
  return amount < 0 ? '-$withCommas' : withCommas;
}

/// عدد الأيام بين تاريخ واليوم — 0 اليوم، 1 أمس.
int _daysAgo(DateTime local) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  return today.difference(day).inDays;
}

/// الوقت فقط بنظام 24 ساعة: `09:24`.
String formatTime(DateTime dt) {
  final local = dt.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

/// اسم اليوم بلا وقت: `اليوم` · `أمس` · `4 يوليو` / `Jul 4`.
String formatDayLabel(BuildContext context, DateTime dt) {
  final local = dt.toLocal();
  final l10n = L10n.of(context);
  final days = _daysAgo(local);

  if (days == 0) return l10n.dateToday;
  if (days == 1) return l10n.dateYesterday;

  // `MMMd` يختار ترتيب اليوم والشهر الصحيح لكل لغة.
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.MMMd(locale).format(local);
}

/// تاريخ ووقت معاً: `اليوم · 09:24` أو `4 يوليو · 14:00`.
String formatDateTimeLabel(BuildContext context, DateTime dt) =>
    '${formatDayLabel(context, dt)} · ${formatTime(dt)}';

/// مدّة نسبية مختصرة للإشعارات: `قبل 5 دقائق` / `5 min ago`.
String formatRelative(BuildContext context, DateTime dt) {
  final l10n = L10n.of(context);
  final diff = DateTime.now().difference(dt.toLocal());

  if (diff.inMinutes < 1) return l10n.relativeNow;
  if (diff.inMinutes < 60) return l10n.relativeMinutes(diff.inMinutes);
  if (diff.inHours < 24) return l10n.relativeHours(diff.inHours);
  if (diff.inDays < 30) return l10n.relativeDays(diff.inDays);
  return formatDateTimeLabel(context, dt);
}
