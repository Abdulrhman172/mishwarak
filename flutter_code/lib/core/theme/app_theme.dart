// ═══════════════════════════════════════════════════════════════
// app_theme.dart - ثيمات التطبيق (Light + Dark)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // NOTE: falls back to GoogleFonts until assets/fonts/IBMPlexSansArabic-*.ttf are added.
  static final String _fontFamily = GoogleFonts.ibmPlexSansArabic().fontFamily!;

  // ═══════════════ LIGHT THEME ═══════════════
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: _fontFamily,

    colorScheme: const ColorScheme.light(
      primary: MishwarakColors.primary,
      onPrimary: Colors.white,
      secondary: MishwarakColors.secondary,
      surface: MishwarakColors.lightSurface,
      onSurface: MishwarakColors.lightText,
      error: MishwarakColors.danger,
    ),

    scaffoldBackgroundColor: MishwarakColors.lightBg,

    textTheme: _buildTextTheme(MishwarakColors.lightText),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: MishwarakColors.lightText),
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: MishwarakColors.lightText,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MishwarakColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MishwarakColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: MishwarakColors.lightBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: MishwarakColors.lightBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: MishwarakColors.primary, width: 2),
      ),
    ),

    cardTheme: CardThemeData(
      color: MishwarakColors.lightSurfaceElev,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: MishwarakColors.lightBorder),
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: MishwarakColors.lightSurfaceElev,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
  );

  // ═══════════════ DARK THEME ═══════════════
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: _fontFamily,

    colorScheme: const ColorScheme.dark(
      primary: MishwarakColors.primaryLight,
      onPrimary: Colors.white,
      secondary: MishwarakColors.secondary,
      surface: MishwarakColors.darkSurface,
      onSurface: MishwarakColors.darkText,
      error: MishwarakColors.danger,
    ),

    scaffoldBackgroundColor: MishwarakColors.darkBg,

    textTheme: _buildTextTheme(MishwarakColors.darkText),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: MishwarakColors.darkText),
    ),

    cardTheme: CardThemeData(
      color: MishwarakColors.darkSurfaceElev,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: MishwarakColors.darkBorder),
      ),
    ),
  );

  static TextTheme _buildTextTheme(Color color) => TextTheme(
    // Display - للعناوين الكبيرة
    displayLarge: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: color, letterSpacing: -1.5),
    displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: color, letterSpacing: -1),
    displaySmall: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color, letterSpacing: -0.5),

    // Headline - للعناوين
    headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color),
    headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color),
    headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color),

    // Body
    bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color, height: 1.5),
    bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color, height: 1.5),
    bodySmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: color, height: 1.4),

    // Label
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.5),
  );
}
