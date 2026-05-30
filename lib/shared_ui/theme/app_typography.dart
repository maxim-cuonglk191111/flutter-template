import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography scale using Inter via Google Fonts.
/// Swap the font family here to rebrand typography across the entire app.
class AppTypography {
  AppTypography._();

  static TextTheme get textTheme => GoogleFonts.interTextTheme(_base);

  static TextTheme get darkTextTheme =>
      GoogleFonts.interTextTheme(_base.apply(bodyColor: Colors.white));

  static const TextTheme _base = TextTheme(
    // Display
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      height: 1.22,
    ),

    // Headline
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.33,
    ),

    // Title
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),

    // Label
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),

    // Body
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
  );
}
