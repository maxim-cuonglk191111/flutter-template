import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

/// Typed wrapper around Firebase Analytics.
/// All event tracking goes through this service.
/// Extend with new typed methods — don't call FirebaseAnalytics directly.
class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final _log = Logger();

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ── Onboarding ─────────────────────────────────────────────
  Future<void> logOnboardingStarted() =>
      _track('onboarding_started');

  Future<void> logOnboardingCompleted() =>
      _track('onboarding_completed');

  Future<void> logOnboardingSkipped({required int slideIndex}) =>
      _track('onboarding_skipped', params: {'slide_index': slideIndex});

  // ── Auth ───────────────────────────────────────────────────
  Future<void> logSignIn({required String method}) =>
      _analytics.logLogin(loginMethod: method);

  Future<void> logSignOut() => _track('sign_out');

  // ── Paywall ────────────────────────────────────────────────
  Future<void> logPaywallShown({String? source}) =>
      _track('paywall_shown', params: {'source': source ?? 'unknown'});

  Future<void> logPaywallConverted({required String productId}) =>
      _track('paywall_converted', params: {'product_id': productId});

  Future<void> logPaywallDismissed() => _track('paywall_dismissed');

  // ── Ads ────────────────────────────────────────────────────
  Future<void> logRewardedAdShown() => _track('rewarded_ad_shown');

  Future<void> logRewardedAdCompleted() =>
      _track('rewarded_ad_completed');

  Future<void> logInterstitialAdShown() =>
      _track('interstitial_ad_shown');

  // ── Features ───────────────────────────────────────────────
  Future<void> logFeatureUsed({required String featureName}) =>
      _track('feature_used', params: {'feature_name': featureName});

  Future<void> logFreeLimitHit({required String featureName}) =>
      _track('free_limit_hit', params: {'feature_name': featureName});

  // ── Settings ───────────────────────────────────────────────
  Future<void> logThemeToggled({required bool isDark}) =>
      _track('theme_toggled', params: {'is_dark': isDark});

  // ── User Properties ────────────────────────────────────────
  Future<void> setUserPremium({required bool isPremium}) async {
    await _analytics.setUserProperty(
      name: 'is_premium',
      value: isPremium.toString(),
    );
  }

  // ── Internal helper ────────────────────────────────────────
  Future<void> _track(
    String name, {
    Map<String, Object>? params,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: params);
    } catch (e) {
      _log.w('Analytics: failed to log $name', error: e);
    }
  }
}
