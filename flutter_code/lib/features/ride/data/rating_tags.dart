// ═══════════════════════════════════════════════════════════════
// rating_tags.dart - وسوم التقييم: مفتاح ثابت + نص مترجَم
// ═══════════════════════════════════════════════════════════════
// كانت الوسوم تُخزَّن في `ride_ratings.tags` كنصوص معروضة، فيكتب
// المستخدم العربي "قيادة آمنة" والإنجليزي "Safe driving" في العمود
// نفسه — ولا يمكن بعدها تجميعها ولا الاعتماد عليها في تقييم السائقين.
// المفتاح هو ما يُخزَّن، والنص للعرض فقط.
import '../../../l10n/app_localizations.dart';

class RatingTag {
  /// ما يُخزَّن في القاعدة — ثابت مهما تغيّرت اللغة أو صياغة النص.
  final String key;

  /// ما يُعرض للمستخدم.
  final String label;

  const RatingTag(this.key, this.label);
}

class RatingTags {
  RatingTags._();

  /// وسوم التقييم المرتفع (4 نجوم فأكثر).
  static List<RatingTag> positive(L10n l10n) => [
        RatingTag('safe_driving', l10n.tagSafeDriving),
        RatingTag('clean_car', l10n.tagCleanCar),
        RatingTag('friendly', l10n.tagFriendly),
        RatingTag('on_time', l10n.tagOnTime),
        RatingTag('fast_route', l10n.tagFastRoute),
        RatingTag('good_music', l10n.tagGoodMusic),
      ];

  /// وسوم التقييم المنخفض (أقل من 4 نجوم).
  static List<RatingTag> negative(L10n l10n) => [
        RatingTag('reckless', l10n.tagReckless),
        RatingTag('dirty_car', l10n.tagDirtyCar),
        RatingTag('rude', l10n.tagRude),
        RatingTag('very_late', l10n.tagVeryLate),
      ];

  /// الوسوم المناسبة لتقييم بعينه.
  static List<RatingTag> forRating(L10n l10n, int rating) {
    if (rating == 0) return const [];
    return rating >= 4 ? positive(l10n) : negative(l10n);
  }
}
