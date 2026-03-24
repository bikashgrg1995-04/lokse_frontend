import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 🔤 AppTextStyles — full typography system.
/// Use these everywhere instead of inline TextStyle definitions.
abstract class AppTextStyles {
  // ── Display ───────────────────────────────────────────
  static const TextStyle display = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w800,
    letterSpacing: 3,
    height: 1,
    color: AppColors.white,
  );

  // ── Headings ──────────────────────────────────────────
  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.grey900,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.grey900,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
    height: 1.4,
  );

  // ── Body ──────────────────────────────────────────────
  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.grey800,
    height: 1.6,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey800,
    height: 1.5,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.grey700,
    height: 1.5,
  );

  // ── Label ─────────────────────────────────────────────
  static const TextStyle labelLg = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.grey800,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMd = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.grey700,
    letterSpacing: 0.1,
  );

  static const TextStyle labelSm = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.grey500,
    letterSpacing: 0.2,
  );

  static const TextStyle labelXs = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.grey400,
    letterSpacing: 0.2,
  );

  // ── Caption ───────────────────────────────────────────
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey500,
    height: 1.4,
  );

  // ── Button ────────────────────────────────────────────
  static const TextStyle buttonLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // ── On-dark (white) variants ──────────────────────────
  static const TextStyle h2OnDark = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle bodyOnDark = TextStyle(
    fontSize: 14,
    color: AppColors.white,
    height: 1.5,
  );

  static const TextStyle captionOnDark = TextStyle(
    fontSize: 12,
    color: Color(0x99FFFFFF),
    height: 1.4,
  );

  // ── Stat / number ─────────────────────────────────────
  static const TextStyle statValue = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    height: 1,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 11,
    color: AppColors.grey500,
    fontWeight: FontWeight.w400,
  );

  // ── Quiz ──────────────────────────────────────────────
  static const TextStyle questionText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.grey900,
  );

  static const TextStyle optionText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.grey800,
  );

  static const TextStyle timerText = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  // ── Convenience ───────────────────────────────────────
  static TextStyle colored(TextStyle base, Color color) =>
      base.copyWith(color: color);

  static TextStyle onDark(TextStyle base) =>
      base.copyWith(color: AppColors.white);

  static TextStyle muted(TextStyle base) =>
      base.copyWith(color: AppColors.grey400);
}
