// ═══════════════════════════════════════════════════════════════
// formatters.dart - تنسيق المبالغ والتواريخ بالعربية
// ═══════════════════════════════════════════════════════════════
// تنسيق يدوي بدل حزمة intl لتفادي الحاجة لتهيئة الـ locale،
// ولأن التطبيق يعرض بالعربية فقط حالياً.
library;

/// يضيف الفاصلة الألفية: `15300` → `15,300`.
String formatMoney(int amount) {
  final abs = amount.abs().toString();
  final withCommas = abs.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]},',
  );
  return amount < 0 ? '-$withCommas' : withCommas;
}

const _months = [
  'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
  'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
];

/// تاريخ بصيغة مقروءة: `اليوم · 09:24` أو `4 يوليو · 14:00`.
///
/// يستخدم "اليوم/أمس" لآخر يومين لأنها أوضح للمستخدم من التاريخ الكامل.
String formatDateTimeLabel(DateTime dt) {
  final local = dt.toLocal();
  final time = '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  final diff = today.difference(day).inDays;

  if (diff == 0) return 'اليوم · $time';
  if (diff == 1) return 'أمس · $time';
  return '${local.day} ${_months[local.month - 1]} · $time';
}

/// اسم اليوم فقط بلا وقت: `اليوم` · `أمس` · `4 يوليو`.
///
/// يُستخدم كعنوان تجميع في سجل الرحلات.
String formatDayLabel(DateTime dt) {
  final local = dt.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  final diff = today.difference(day).inDays;

  if (diff == 0) return 'اليوم';
  if (diff == 1) return 'أمس';
  return '${local.day} ${_months[local.month - 1]}';
}

/// الوقت فقط: `09:24`.
String formatTime(DateTime dt) {
  final local = dt.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

/// مدّة نسبية مختصرة للإشعارات: `قبل 5 دقائق`.
String formatRelative(DateTime dt) {
  final diff = DateTime.now().difference(dt.toLocal());

  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'قبل ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'قبل ${diff.inHours} ساعة';
  if (diff.inDays < 30) return 'قبل ${diff.inDays} يوم';
  return formatDateTimeLabel(dt);
}
