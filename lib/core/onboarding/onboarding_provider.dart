import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingDone = 'onboarding_completed';

/// Tracks whether onboarding has been completed.
/// Persisted via SharedPreferences.
class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_kOnboardingDone) ?? false;
  }

  Future<void> complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingDone, true);
    state = true;
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, bool>(
        (ref) => OnboardingNotifier());
