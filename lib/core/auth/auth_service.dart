import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

/// Handles all Firebase Auth operations.
/// Supports: Google Sign-In, Anonymous login, Sign-out.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _log = Logger();

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;
  bool get isAnonymous => currentUser?.isAnonymous ?? false;

  // ── Google Sign-In ─────────────────────────────────────────
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _log.e('Google sign-in failed', error: e);
      rethrow;
    }
  }

  // ── Anonymous Login ────────────────────────────────────────
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      _log.e('Anonymous sign-in failed', error: e);
      rethrow;
    }
  }

  // ── Link Anonymous → Google ────────────────────────────────
  /// Call this when an anonymous user chooses to upgrade to a Google account.
  Future<UserCredential?> linkAnonymousWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.currentUser?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        // Google account already has a Firebase user — just sign in instead.
        return signInWithGoogle();
      }
      _log.e('Link anonymous→Google failed', error: e);
      rethrow;
    }
  }

  // ── Sign Out ───────────────────────────────────────────────
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
