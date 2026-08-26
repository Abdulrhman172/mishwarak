// ═══════════════════════════════════════════════════════════════
// new_screens_test.dart - الشاشات المُضافة والأعطال المُصلَحة
// ═══════════════════════════════════════════════════════════════
// كل اختبار هنا يحرس سلوكاً كان مكسوراً: شاشة غير موجودة، أو زر
// يدّعي فعلاً لا يفعله، أو سعر يختلف بين موضعين في الشاشة نفسها.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mishwarak/core/providers/locale_provider.dart';
import 'package:mishwarak/core/providers/theme_provider.dart';
import 'package:mishwarak/core/theme/app_theme.dart';
import 'package:mishwarak/features/booking/data/fare_calculator.dart';
import 'package:mishwarak/features/booking/models/vehicle_type.dart';
import 'package:mishwarak/features/help/help_screen.dart';
import 'package:mishwarak/features/notifications/data/notification_repository.dart';
import 'package:mishwarak/features/promos/promos_screen.dart';
import 'package:mishwarak/features/rewards/rewards_screen.dart';
import 'package:mishwarak/features/rewards/vip_screen.dart';
import 'package:mishwarak/features/ride/data/rating_tags.dart';
import 'package:mishwarak/features/settings/settings_screen.dart';
import 'package:mishwarak/l10n/app_localizations.dart';

/// يغلّف الشاشة بثيم التطبيق واللغة المطلوبة.
Widget _wrap(Widget screen, {Locale locale = const Locale('ar', 'YE')}) =>
    ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        locale: locale,
        supportedLocales: L10n.supportedLocales,
        localizationsDelegates: L10n.localizationsDelegates,
        home: screen,
      ),
    );

void main() {
  Future<void> pumpPhone(
    WidgetTester tester,
    Widget screen, {
    Locale locale = const Locale('ar', 'YE'),
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_wrap(screen, locale: locale));
    await tester.pumpAndSettle();
  }

  // ═══════════════════════════════════════════════════════════════
  // الشاشات المُضافة
  // ═══════════════════════════════════════════════════════════════

  group('الإعدادات', () {
    testWidgets('تعرض خياري اللغة وأوضاع المظهر الثلاثة', (tester) async {
      await pumpPhone(tester, const SettingsScreen());

      expect(find.text('اللغة'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);

      expect(find.text('حسب النظام'), findsOneWidget);
      expect(find.text('فاتح'), findsOneWidget);
      expect(find.text('داكن'), findsOneWidget);
    });

    testWidgets('اختيار "داكن" يغيّر وضع الثيم فعلاً', (tester) async {
      // الثيم الداكن وموفّره كانا مبنيَّين بلا أي شاشة تستدعيهما.
      late WidgetRef ref;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            locale: const Locale('ar', 'YE'),
            supportedLocales: L10n.supportedLocales,
            localizationsDelegates: L10n.localizationsDelegates,
            home: Consumer(
              builder: (context, r, _) {
                ref = r;
                return const SettingsScreen();
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(ref.read(themeModeProvider), ThemeMode.system);

      await tester.tap(find.text('داكن'));
      await tester.pumpAndSettle();

      expect(ref.read(themeModeProvider), ThemeMode.dark);
    });

    testWidgets('اختيار English يبدّل لغة التطبيق', (tester) async {
      // الترجمة الإنجليزية كانت كاملة وغير قابلة للوصول.
      late WidgetRef ref;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            locale: const Locale('ar', 'YE'),
            supportedLocales: L10n.supportedLocales,
            localizationsDelegates: L10n.localizationsDelegates,
            home: Consumer(
              builder: (context, r, _) {
                ref = r;
                return const SettingsScreen();
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(ref.read(localeProvider).languageCode, 'ar');

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(ref.read(localeProvider).languageCode, 'en');
    });
  });

  group('العروض والنقاط والمساعدة', () {
    testWidgets('شاشة الكوبونات تعرض حالتها الفارغة بلا انهيار',
        (tester) async {
      await pumpPhone(tester, const PromosScreen());

      expect(find.text('الكوبونات والعروض'), findsOneWidget);
      expect(find.text('لا توجد عروض متاحة حالياً.'), findsOneWidget);
    });

    testWidgets('شاشة النقاط تعرض المستويات الثلاثة', (tester) async {
      await pumpPhone(tester, const RewardsScreen());

      expect(find.text('فضّي'), findsOneWidget);
      expect(find.text('ذهبي'), findsOneWidget);
      expect(find.text('بلاتيني'), findsOneWidget);
    });

    testWidgets('شاشة VIP تقول صراحةً إن الاشتراك غير متاح', (tester) async {
      // المهم ألا تعرض زر شراء لميزة بلا خلفية.
      await pumpPhone(tester, const VipScreen());

      expect(find.textContaining('غير متاح في منطقتك'), findsOneWidget);
    });

    testWidgets('المساعدة تعرض الأسئلة وتفتح الإجابة عند الضغط',
        (tester) async {
      await pumpPhone(tester, const HelpScreen());

      expect(find.text('كيف أطلب رحلة؟'), findsOneWidget);
      // الإجابة مطوية قبل الضغط
      expect(find.textContaining('اختر وجهتك، ثم نوع المركبة'), findsNothing);

      await tester.tap(find.text('كيف أطلب رحلة؟'));
      await tester.pumpAndSettle();

      expect(find.textContaining('اختر وجهتك، ثم نوع المركبة'), findsOneWidget);
    });
  });

  group('الترجمة', () {
    testWidgets('الشاشات تُعرض بالإنجليزية عند اختيارها', (tester) async {
      await pumpPhone(
        tester,
        const SettingsScreen(),
        locale: const Locale('en', 'US'),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      // ولا يتسرّب نص عربي إلى الواجهة الإنجليزية
      expect(find.text('المظهر'), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // الأعطال المُصلَحة
  // ═══════════════════════════════════════════════════════════════

  group('وسوم التقييم', () {
    test('تُخزَّن كمفاتيح ثابتة لا كنصوص مترجَمة', () {
      // النص المعروض يتغيّر بلغة المُقيِّم؛ المفتاح لا يتغيّر، وإلا
      // امتلأ عمود `tags` بخليط لا يُجمَّع.
      final arabic = _FakeL10nAr();
      final english = _FakeL10nEn();

      final arKeys = RatingTags.positive(arabic).map((t) => t.key).toList();
      final enKeys = RatingTags.positive(english).map((t) => t.key).toList();

      expect(arKeys, enKeys);
      expect(arKeys, contains('safe_driving'));

      // النصوص المعروضة تختلف بينما المفاتيح ثابتة.
      expect(
        RatingTags.positive(arabic).first.label,
        isNot(RatingTags.positive(english).first.label),
      );
    });

    test('التقييم المرتفع يعطي وسوماً إيجابية والمنخفض سلبية', () {
      final l10n = _FakeL10nAr();

      expect(RatingTags.forRating(l10n, 0), isEmpty);
      expect(
        RatingTags.forRating(l10n, 5).map((t) => t.key),
        contains('safe_driving'),
      );
      expect(
        RatingTags.forRating(l10n, 2).map((t) => t.key),
        contains('reckless'),
      );
    });
  });

  group('حساب الأجرة', () {
    test('الإجمالي المعروض في البطاقة هو نفسه الذي يُطلب به', () {
      // كانت البطاقة تعرض `fare.total` والزر يعرض `vehicle.price`،
      // فيرى الراكب سعرين مختلفين في الشاشة نفسها.
      const vehicle = VehicleType(
        id: 'comfort',
        category: VehicleCategory.comfort,
        nameAr: 'مريح',
        nameEn: 'Comfort',
        descriptionAr: 'سيارة أحدث',
        descriptionEn: 'Newer car',
        seats: 4,
        etaMinutes: 5,
        price: 3800,
        pricePerKm: 180,
      );

      final fare = FareCalculator.estimate(vehicle: vehicle, distanceKm: 7.5);

      expect(fare.baseFare, 3800);
      expect(fare.distanceFare, 1350); // 180 × 7.5
      expect(fare.total, 5150);
      // الإجمالي يتجاوز السعر الأساسي — وهو بالضبط سبب العطل السابق.
      expect(fare.total, greaterThan(vehicle.price));
    });
  });

  group('نصوص المركبة', () {
    test('تتبع لغة الواجهة وترجع للّغة الأخرى عند غياب الترجمة', () {
      const vehicle = VehicleType(
        id: 'women',
        category: VehicleCategory.women,
        nameAr: 'سائقة للنساء',
        nameEn: 'Women only',
        descriptionAr: 'سائقة خبيرة',
        descriptionEn: '',
        seats: 4,
        etaMinutes: 9,
        price: 3200,
        badgeAr: 'حصري',
        badgeEn: 'Exclusive',
      );

      expect(vehicle.name('ar'), 'سائقة للنساء');
      expect(vehicle.name('en'), 'Women only');
      expect(vehicle.badge('en'), 'Exclusive');

      // الوصف الإنجليزي فارغ في القاعدة → نرجع للعربي بدل فراغ.
      expect(vehicle.description('en'), 'سائقة خبيرة');
    });

    test('الشارة الفارغة تعود null لا نصاً فارغاً', () {
      const vehicle = VehicleType(
        id: 'eco',
        category: VehicleCategory.economy,
        nameAr: 'اقتصادي',
        nameEn: 'Economy',
        descriptionAr: '4 ركاب',
        descriptionEn: '4 seats',
        seats: 4,
        etaMinutes: 3,
        price: 2500,
      );

      expect(vehicle.badge('ar'), isNull);
      expect(vehicle.badge('en'), isNull);
    });
  });

  group('الإشعارات', () {
    test('تبني نصّها من payload لا من العمود المخزَّن', () {
      // `title`/`subtitle` يُكتبان على الخادم بلغة واحدة.
      final notif = AppNotification(
        id: 'n1',
        type: 'ride_completed',
        title: 'اكتملت رحلتك',
        subtitle: 'كريتر ← خور مكسر',
        payload: const {'from': 'Crater', 'to': 'Khormaksar'},
        isRead: false,
        createdAt: DateTime.now(),
      );

      expect(
        notif.localizedSubtitle((from, to) => '$from → $to'),
        'Crater → Khormaksar',
      );
    });

    test('ترجع للنص المخزَّن حين لا توجد بيانات', () {
      final notif = AppNotification(
        id: 'n2',
        type: 'promo',
        title: 'عرض',
        subtitle: 'خصم 30%',
        isRead: false,
        createdAt: DateTime.now(),
      );

      expect(
        notif.localizedSubtitle((from, to) => '$from → $to'),
        'خصم 30%',
      );
    });
  });
}

// ─────────────── بدائل L10n للاختبارات الوحدوية ───────────────
// نحتاج نصّي الوسوم فقط، فلا داعي لتحميل شجرة ويدجت كاملة.

class _FakeL10nAr extends _FakeL10nBase {
  _FakeL10nAr() : super('ar');
  @override
  String get tagSafeDriving => 'قيادة آمنة';
  @override
  String get tagCleanCar => 'سيارة نظيفة';
  @override
  String get tagFriendly => 'ودود';
  @override
  String get tagOnTime => 'في الموعد';
  @override
  String get tagFastRoute => 'طريق سريع';
  @override
  String get tagGoodMusic => 'موسيقى جيدة';
  @override
  String get tagReckless => 'قيادة متهورة';
  @override
  String get tagDirtyCar => 'سيارة غير نظيفة';
  @override
  String get tagRude => 'غير مهذّب';
  @override
  String get tagVeryLate => 'تأخّر كثيراً';
}

class _FakeL10nEn extends _FakeL10nBase {
  _FakeL10nEn() : super('en');
  @override
  String get tagSafeDriving => 'Safe driving';
  @override
  String get tagCleanCar => 'Clean car';
  @override
  String get tagFriendly => 'Friendly';
  @override
  String get tagOnTime => 'On time';
  @override
  String get tagFastRoute => 'Fast route';
  @override
  String get tagGoodMusic => 'Good music';
  @override
  String get tagReckless => 'Reckless driving';
  @override
  String get tagDirtyCar => 'Dirty car';
  @override
  String get tagRude => 'Rude';
  @override
  String get tagVeryLate => 'Very late';
}

/// يرث من [L10n] ليقبله [RatingTags]؛ بقية المفاتيح لا تُستدعى هنا.
class _FakeL10nBase extends L10n {
  _FakeL10nBase(super.locale);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} غير مطلوبة للاختبار');
}
