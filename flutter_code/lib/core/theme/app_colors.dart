// ═══════════════════════════════════════════════════════════════
// app_colors.dart - نظام الألوان الكامل لتطبيق مشوارك
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

/// نظام الألوان الأساسي - النسخة A (Classic Refined - Careem-inspired)
class MishwarakColors {
  MishwarakColors._();

  // ─────────── Primary Palette ───────────
  static const Color primary = Color(0xFF00A651);      // أخضر مشوارك
  static const Color primaryDark = Color(0xFF008A44);
  static const Color primaryLight = Color(0xFF00C853);

  // ─────────── Secondary ───────────
  static const Color secondary = Color(0xFF004E89);
  static const Color accent = Color(0xFFFFC300);       // ذهبي للنقاط

  // ─────────── Semantic ───────────
  static const Color success = Color(0xFF10B981);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ─────────── Light Theme ───────────
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F8FA);
  static const Color lightSurfaceElev = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF0F1420);
  static const Color lightTextMuted = Color(0xFF6B7280);
  static const Color lightTextLight = Color(0xFF9CA3AF);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // ─────────── Dark Theme ───────────
  static const Color darkBg = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF141826);
  static const Color darkSurfaceElev = Color(0xFF1C2233);
  static const Color darkText = Color(0xFFF5F7FA);
  static const Color darkTextMuted = Color(0xFF9AA3B2);
  static const Color darkBorder = Color(0xFF252B3B);

  // ─────────── Map Colors ───────────
  static const Color mapBgLight = Color(0xFFE8EEF3);
  static const Color mapBgDark = Color(0xFF1A2030);
  static const Color mapRoadLight = Color(0xFFFFFFFF);
  static const Color mapRoadDark = Color(0xFF2A3245);

  // ─────────── Gradients ───────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFFFF9800)],
  );
}
