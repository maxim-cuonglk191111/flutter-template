
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_template/core/auth/auth_provider.dart';
import 'package:flutter_template/core/onboarding/onboarding_provider.dart';
import 'package:flutter_template/core/auth/auth_screen.dart';
import 'package:flutter_template/core/onboarding/onboarding_screen.dart';
import 'package:flutter_template/core/settings/settings_screen.dart';
import 'package:flutter_template/features/dashboard/home_screen.dart';
import 'package:flutter_template/features/splash/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // Listen to auth & onboarding state to drive redirects
  final authState = ref.watch(authStateProvider);
  final onboardingDone = ref.watch(onboardingProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final location = state.matchedLocation;

      // While auth is loading, stay on splash
      if (authState.isLoading) return '/splash';

      final isLoggedIn = authState.valueOrNull != null;

      // Not logged in flow
      if (!isLoggedIn) {
        if (!onboardingDone && location != '/onboarding') {
          return '/onboarding';
        }
        if (onboardingDone && location != '/auth') {
          return '/auth';
        }
        return null;
      }

      // Logged in — redirect away from auth screens
      if (location == '/splash' ||
          location == '/onboarding' ||
          location == '/auth') {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (_, __) => const AuthScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
    ],
  );
});
