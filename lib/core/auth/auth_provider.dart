import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the current Firebase Auth user as a stream.
/// Null = signed out.
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Convenience provider: is the user currently signed in?
final isSignedInProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  return user != null;
});

/// Convenience provider: is the user anonymous?
final isAnonymousProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  return user?.isAnonymous ?? false;
});
