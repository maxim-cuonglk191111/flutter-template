import 'package:flutter/material.dart';
import 'package:flutter_template/config/app_config.dart';

/// All color constants for the app.
/// Change [primarySeed] in AppConfig → full palette updates automatically.
class AppColors {
  AppColors._();

  // ── Brand seeds ────────────────────────────────────────────
  static const Color primarySeed = Color(AppConfig.primarySeed);
  static const Color secondarySeed = Color(AppConfig.secondarySeed);

  // ── Neutral palette ────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Light surface shades
  static const Color surface = Color(0xFFF8F8FF);
  static const Color surfaceVariant = Color(0xFFEFEFF8);
  static const Color outline = Color(0xFFCACAD8);

  // Dark surface shades
  static const Color surfaceDark = Color(0xFF0F0F1A);
  static const Color surfaceVariantDark = Color(0xFF1C1C2E);
  static const Color outlineDark = Color(0xFF3A3A52);

  // ── Semantic colors ────────────────────────────────────────
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // ── Premium / Paywall palette ──────────────────────────────
  static const Color premiumGold = Color(0xFFFFD700);
  static const Color premiumGoldDark = Color(0xFFB8860B);
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9C88FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Ad background ─────────────────────────────────────────
  static const Color adBackground = Color(0xFFF0F0FA);
  static const Color adBackgroundDark = Color(0xFF1A1A2E);
}
