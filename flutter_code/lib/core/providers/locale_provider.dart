// ═══════════════════════════════════════════════════════════════
// locale_provider.dart - إدارة اللغة (عربي/إنجليزي)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar', 'YE')) {
    _load();
  }

  static const _key = 'locale';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'ar';
    state = code == 'en' ? const Locale('en', 'US') : const Locale('ar', 'YE');
  }

  Future<void> setLocale(String code) async {
    state = code == 'en' ? const Locale('en', 'US') : const Locale('ar', 'YE');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }

  Future<void> toggle() async {
    await setLocale(state.languageCode == 'ar' ? 'en' : 'ar');
  }
}
