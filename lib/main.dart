import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template/app.dart';
import 'package:flutter_template/config/app_config.dart';
import 'package:flutter_template/core/ads/ad_service.dart';
import 'package:flutter_template/core/notifications/notification_service.dart';
import 'package:flutter_template/core/paywall/paywall_service.dart';
import 'package:flutter_template/core/remote_config/remote_config_service.dart';
import 'package:flutter_template/core/update/update_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── 1. Load environment variables (.env for local dev) ─────
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env file not found — expected in production (CI/CD uses secrets)
    debugPrint('[dotenv] No .env file found — using CI/CD environment');
  }

  // ── 2. easy_localization ────────────────────────────────────
  await EasyLocalization.ensureInitialized();

  // ── 3. Firebase ─────────────────────────────────────────────
  await Firebase.initializeApp();

  // ── 4. Crashlytics ──────────────────────────────────────────
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // ── 5. Remote Config (fetch before runApp for first-frame accuracy) ─
  if (AppConfig.enableRemoteConfig) {
    await RemoteConfigService.instance.initialize();
  }

  // ── 6. AdMob ────────────────────────────────────────────────
  await AdService.instance.initialize();

  // ── 7. RevenueCat ───────────────────────────────────────────
  await initRevenueCat();

  // ── 8. Notifications ────────────────────────────────────────
  await NotificationService.instance.initialize();

  // ── 9. ScreenUtil (pre-init with default size for early use) ─
  // Full init happens inside ScreenUtilInit widget in app.dart.

  runApp(
    EasyLocalization(
      supportedLocales: AppConfig.supportedLocales,
      path: AppConfig.l10nPath,
      fallbackLocale: const Locale(AppConfig.l10nFallbackLocale),
      startLocale: AppConfig.defaultLocale,
      child: const ProviderScope(
        child: App(),
      ),
    ),
  );

  // ── 10. In-App Update check (after runApp so UI is ready) ───
  if (AppConfig.enableInAppUpdate) {
    await UpdateService.instance.checkForUpdate();
  }
}
