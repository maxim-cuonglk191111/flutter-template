// ============================================================
// app_config.dart — THE ONLY FILE YOU NEED TO CHANGE
// when spawning a new app from this template.
// Version: 1.1
// ============================================================

import 'package:flutter/material.dart';

class AppConfig {
  AppConfig._();

  // ----------------------------------------------------------
  // 1. APP IDENTITY
  // ----------------------------------------------------------
  /// The display name shown on the device and in the Play Store.
  static const String appName = 'Flutter Template';

  /// Your app's package name. Must match AndroidManifest + Firebase.
  static const String packageName = 'com.template.flutter_template';

  /// App version string shown in Settings → About.
  static const String appVersion = '1.1.0';

  // ----------------------------------------------------------
  // 2. BRANDING COLORS (Material 3 seed color system)
  // Change primarySeed → entire app palette auto-regenerates.
  // ----------------------------------------------------------
  static const int primarySeed = 0xFF6C63FF;   // Indigo-violet
  static const int secondarySeed = 0xFF00BFA5; // Teal

  // ----------------------------------------------------------
  // 3. RESPONSIVE SIZING (flutter_screenutil)
  // Base design canvas. Use .sp / .w / .h everywhere in UI.
  // 390×844 = iPhone 14 size (good cross-platform baseline).
  // ----------------------------------------------------------
  static const double designWidth = 390;
  static const double designHeight = 844;
  static const double designTextScaleFactor = 1.0;

  // ----------------------------------------------------------
  // 4. LOCALIZATION (easy_localization)
  // ----------------------------------------------------------
  static const Locale defaultLocale = Locale('en');
  static const List<Locale> supportedLocales = [
    Locale('en'), // English (default)
    Locale('vi'), // Vietnamese
  ];
  static const String l10nPath = 'l10n';
  static const String l10nFallbackLocale = 'en';

  // ----------------------------------------------------------
  // 5. FREE LIMITS (overridable via Remote Config in production)
  // ----------------------------------------------------------
  static const int freeAiMessagesPerDay = 5;
  static const int freeContentItems = 10;

  // ----------------------------------------------------------
  // 6. MONETIZATION
  // ----------------------------------------------------------
  static const String revenueCatEntitlement = 'premium';

  static const String revenueCatApiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'YOUR_REVENUECAT_API_KEY',
  );

  // ----------------------------------------------------------
  // 7. ADS (AdMob) — test IDs pre-configured for development
  // ----------------------------------------------------------
  static const String admobBannerId = String.fromEnvironment(
    'ADMOB_BANNER_ID',
    defaultValue: 'ca-app-pub-3940256099942544/6300978111',
  );

  static const String admobRewardedId = String.fromEnvironment(
    'ADMOB_REWARDED_ID',
    defaultValue: 'ca-app-pub-3940256099942544/5224354917',
  );

  static const String admobInterstitialId = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ID',
    defaultValue: 'ca-app-pub-3940256099942544/1033173712',
  );

  // ----------------------------------------------------------
  // 8. AI MODULE
  // Prefer injecting via Remote Config → SecureStorage at runtime
  // rather than hardcoding or using --dart-define for production.
  // ----------------------------------------------------------
  static const String openAiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );

  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Base URL for Firebase Functions AI proxy.
  /// Set in .env (local) or CI/CD secrets (production).
  static const String firebaseFunctionsBaseUrl = String.fromEnvironment(
    'FIREBASE_FUNCTIONS_BASE_URL',
    defaultValue: 'https://us-central1-your-project.cloudfunctions.net',
  );

  // ----------------------------------------------------------
  // 9. FEATURE FLAGS
  // These are compile-time defaults; Remote Config overrides at runtime.
  // ----------------------------------------------------------
  static const bool enableAiChat = false;
  static const bool enableAds = true;
  static const bool enablePaywall = true;
  static const bool enableInAppUpdate = true;
  static const bool enableRemoteConfig = true;

  // ----------------------------------------------------------
  // 10. LEGAL / SUPPORT
  // ----------------------------------------------------------
  static const String privacyPolicyUrl = 'https://yoursite.com/privacy-policy';
  static const String termsOfServiceUrl = 'https://yoursite.com/terms';
  static const String supportEmail = 'support@yourapp.com';
}
