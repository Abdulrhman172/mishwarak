// ═══════════════════════════════════════════════════════════════
// screens_render_test.dart - تتأكد أن كل شاشة تُبنى وتعرض محتواها
// دون استثناءات (overflow، أخطاء بناء، ويدجت مفقود).
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mishwarak/core/theme/app_theme.dart';
import 'package:mishwarak/features/booking/vehicle_selection_screen.dart';
import 'package:mishwarak/features/history/history_screen.dart';
import 'package:mishwarak/features/notifications/notifications_screen.dart';
import 'package:mishwarak/features/onboarding/onboarding_screen.dart';
import 'package:mishwarak/features/profile/profile_screen.dart';
import 'package:mishwarak/features/ride/rating_screen.dart';
import 'package:mishwarak/features/wallet/wallet_screen.dart';

/// يغلّف الشاشة بثيم التطبيق واتجاه RTL على مقاس هاتف.
Widget _wrap(Widget screen) => MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('ar', 'YE'),
      home: Directionality(textDirection: TextDirection.rtl, child: screen),
    );

void main() {
  // مقاس هاتف واقعي حتى تُكتشف مشاكل الـ overflow فعلياً
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<void> pumpPhone(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(1170, 2532); // iPhone 13 Pro
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_wrap(screen));
    await tester.pumpAndSettle();
  }

  testWidgets('شاشة اختيار المركبة تعرض الأنواع والسعر', (tester) async {
    await pumpPhone(tester, const VehicleSelectionScreen());

    expect(find.text('اختر مركبتك'), findsOneWidget);
    expect(find.text('اقتصادي'), findsOneWidget);
    expect(find.text('مريح'), findsOneWidget);
    expect(find.text('سائقة للنساء'), findsOneWidget);
    // شارة "حصري" الخاصة بمركبة النساء
    expect(find.text('حصري'), findsOneWidget);
  });

  testWidgets('شاشة التقييم: الوسوم تظهر بعد اختيار النجوم', (tester) async {
    await pumpPhone(tester, const RatingScreen());

    expect(find.text('وصلت بسلامة!'), findsOneWidget);
    expect(find.text('الإجمالي'), findsOneWidget);
    // قبل التقييم لا توجد وسوم ولا إكرامية
    expect(find.text('ما الذي أعجبك؟'), findsNothing);

    // 5 نجوم → وسوم إيجابية + إكرامية
    await tester.tap(find.byIcon(Icons.star_border_rounded).last);
    await tester.pumpAndSettle();
    expect(find.text('ما الذي أعجبك؟'), findsOneWidget);
    expect(find.text('قيادة آمنة'), findsOneWidget);
    expect(find.text('أضف إكرامية للسائق'), findsOneWidget);
  });

  testWidgets('شاشة التقييم: تقييم منخفض يعرض وسوماً سلبية', (tester) async {
    await pumpPhone(tester, const RatingScreen());

    // أول نجمة = تقييم 1
    await tester.tap(find.byIcon(Icons.star_border_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('ما الذي أزعجك؟'), findsOneWidget);
    expect(find.text('قيادة متهورة'), findsOneWidget);
    // لا إكرامية للتقييم المنخفض
    expect(find.text('أضف إكرامية للسائق'), findsNothing);
  });

  testWidgets('المحفظة تعرض الرصيد وطرق الدفع والمعاملات', (tester) async {
    await pumpPhone(tester, const WalletScreen());

    expect(find.text('الرصيد الحالي'), findsOneWidget);
    expect(find.text('طرق الدفع'), findsOneWidget);
    expect(find.text('نقدي'), findsOneWidget);
    expect(find.text('آخر المعاملات'), findsOneWidget);
    expect(find.text('شحن المحفظة'), findsOneWidget);
  });

  testWidgets('سجل الرحلات يعرض الإحصائيات والرحلات', (tester) async {
    await pumpPhone(tester, const HistoryScreen());

    expect(find.text('رحلاتي'), findsOneWidget);
    expect(find.text('47'), findsOneWidget); // عدد الرحلات
    expect(find.text('جامعة عدن'), findsWidgets);
    expect(find.text('ملغاة'), findsOneWidget); // الرحلة الملغاة
  });

  testWidgets('الملف الشخصي يعرض البيانات والنقاط', (tester) async {
    await pumpPhone(tester, const ProfileScreen());

    expect(find.text('أحمد الشيباني'), findsWidgets);
    expect(find.text('نقاطك المتاحة'), findsOneWidget);
    expect(find.text('العناوين المحفوظة'), findsOneWidget);
    expect(find.text('جهات الطوارئ'), findsOneWidget);
  });

  testWidgets('الإشعارات: "تحديد الكل مقروء" يزيل نقاط غير المقروء',
      (tester) async {
    await pumpPhone(tester, const NotificationsScreen());

    expect(find.text('كوبون خصم 30%'), findsOneWidget);

    final markAll = find.text('تحديد الكل مقروء');
    expect(tester.widget<TextButton>(
      find.ancestor(of: markAll, matching: find.byType(TextButton)),
    ).onPressed, isNotNull);

    await tester.tap(markAll);
    await tester.pumpAndSettle();

    // بعد التحديد يصبح الزر معطّلاً (لا يوجد غير مقروء)
    expect(tester.widget<TextButton>(
      find.ancestor(of: markAll, matching: find.byType(TextButton)),
    ).onPressed, isNull);
  });

  testWidgets('التعريف بالتطبيق: التنقل بين الشرائح', (tester) async {
    await pumpPhone(tester, const OnboardingScreen());

    expect(find.text('اطلب مشوارك بضغطة زر'), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('أسعار شفافة قبل الرحلة'), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('أمانك أولويتنا'), findsOneWidget);
    // آخر شريحة → يتغيّر نص الزر
    expect(find.text('يلا نبدأ'), findsOneWidget);
  });
}
