import 'package:flutter/material.dart';

/// 🎨 AppColors — single source of truth for every color in Lokse.
/// Never hardcode hex values anywhere else in the codebase.
abstract class AppColors {
  // ── Brand ────────────────────────────────────────────────
  static const Color primary = Color(0xFF1E3EBF);
  static const Color primaryLight = Color(0xFF4F6EF7);
  static const Color primaryDark = Color(0xFF0F2354);
  static const Color primarySurface = Color(0xFFEEF1FB);

  // ── Difficulty / Game ─────────────────────────────────
  static const Color easy = Color(0xFF22C55E);
  static const Color easyDark = Color(0xFF16A34A);
  static const Color easySurface = Color(0xFFDCFCE7);

  static const Color medium = Color(0xFFF59E0B);
  static const Color mediumDark = Color(0xFFD97706);
  static const Color mediumSurface = Color(0xFFFEF3C7);

  static const Color hard = Color(0xFFEF4444);
  static const Color hardDark = Color(0xFFDC2626);
  static const Color hardSurface = Color(0xFFFEE2E2);

  static const Color boss = Color(0xFF8B5CF6);
  static const Color bossDark = Color(0xFF7C3AED);
  static const Color bossSurface = Color(0xFFEDE9FE);

  // ── Semantic ──────────────────────────────────────────
  static const Color success = Color(0xFF059669);
  static const Color successSurface = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSurface = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSurface = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0369A1);
  static const Color infoSurface = Color(0xFFE0F2FE);

  // ── Coin / Reward ──────────────────────────────────────
  static const Color coin = Color(0xFFF59E0B);
  static const Color coinDark = Color(0xFFD97706);
  static const Color coinSurface = Color(0xFFFEF3C7);
  static const Color coinText = Color(0xFF92400E);
  static const Color xp = Color(0xFF8B5CF6);

  // ── Neutral ────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ── Page backgrounds ──────────────────────────────────
  static const Color scaffold = Color(0xFFF4F6FB);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color mapBg = Color(0xFF1B2B6B);

  // ── Splash ────────────────────────────────────────────
  static const Color splashTop = Color(0xFF0A1628);
  static const Color splashMid = Color(0xFF0F2354);
  static const Color splashBottom = Color(0xFF1E3EBF);

  // ── Subject colors ────────────────────────────────────
  static const Color subjectGk = Color(0xFF1E3EBF);
  static const Color subjectGkSurface = Color(0xFFEEF1FB);
  static const Color subjectNepali = Color(0xFF059669);
  static const Color subjectNepaliSurface = Color(0xFFECFDF5);
  static const Color subjectConstitution = Color(0xFF7C3AED);
  static const Color subjectConstitutionSurface = Color(0xFFF5F3FF);
  static const Color subjectMath = Color(0xFFD97706);
  static const Color subjectMathSurface = Color(0xFFFFFBEB);
  static const Color subjectReasoning = Color(0xFFDB2777);
  static const Color subjectReasoningSurface = Color(0xFFFDF2F8);
  static const Color subjectEnglish = Color(0xFF0369A1);
  static const Color subjectEnglishSurface = Color(0xFFF0F9FF);

  // ── Gradient helpers ──────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [splashTop, splashMid, Color(0xFF1A3A8A), splashBottom],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static const LinearGradient mapGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [mapBg, Color(0xFF23316E), Color(0xFF1A3050)],
  );

  // ── Card border ───────────────────────────────────────
  static Color cardBorder = const Color(0xFF000000).withOpacity(0.07);
}
