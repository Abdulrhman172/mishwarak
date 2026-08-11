import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mishwarak/main.dart';

void main() {
  testWidgets('App boots and shows the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MishwarakApp()));
    expect(find.text('مِشوارَك'), findsOneWidget);
  });
}
