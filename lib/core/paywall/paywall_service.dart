import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter_template/config/app_config.dart';

/// Initializes RevenueCat SDK. Call from main.dart after Firebase.initialize.
Future<void> initRevenueCat() async {
  if (!AppConfig.enablePaywall) return;
  const key = AppConfig.revenueCatApiKey;
  if (key.isEmpty || key == 'YOUR_REVENUECAT_API_KEY') return;
  await Purchases.setLogLevel(LogLevel.warn);
  final config = PurchasesConfiguration(key);
  await Purchases.configure(config);
}

/// Notifier that tracks how many times the user has used a gated feature today.
/// Auto-resets on a new calendar day.
class FreeLimitNotifier extends StateNotifier<Map<String, int>> {
  FreeLimitNotifier() : super({});

  final _log = Logger();

  /// Returns true if the feature can be used (under the limit).
  /// Returns false if the limit is hit → caller should show paywall.
  bool consume(String featureKey, {required int limit}) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final compositeKey = '$featureKey::$today';
    final current = state[compositeKey] ?? 0;

    if (current >= limit) {
      _log.d('Free limit hit for $featureKey ($current/$limit)');
      return false;
    }

    state = {...state, compositeKey: current + 1};
    return true;
  }

  int getUsage(String featureKey) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return state['$featureKey::$today'] ?? 0;
  }
}

final freeLimitProvider =
    StateNotifierProvider<FreeLimitNotifier, Map<String, int>>(
        (ref) => FreeLimitNotifier());
