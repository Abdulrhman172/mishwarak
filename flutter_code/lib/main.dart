// ═══════════════════════════════════════════════════════════════
// main.dart - نقطة دخول التطبيق
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE: Firebase disabled — no firebase_options.dart / project configured yet.
  // Re-add firebase_core + `flutterfire configure` when auth/push are needed.

  // شريط الحالة شفاف
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // قفل التطبيق على Portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const ProviderScope(child: MishwarakApp()));
}

class MishwarakApp extends ConsumerWidget {
  const MishwarakApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'مِشوارَك',
      debugShowCheckedModeBanner: false,

      // ═══ الثيم ═══
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // ═══ اللغة والاتجاه ═══
      locale: locale,
      supportedLocales: const [
        Locale('ar', 'YE'), // عربي - اليمن
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ═══ التنقل ═══
      routerConfig: router,

      // ═══ تحسينات ═══
      builder: (context, child) {
        return MediaQuery(
          // منع تكبير الخط من إعدادات النظام
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1).clamp(0.9, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
