import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

/// Wrapper around flutter_secure_storage.
/// Use this for ANY sensitive data: auth tokens, API keys, user IDs.
/// Do NOT use SharedPreferences or Hive for sensitive values.
///
/// Android: stores in Keystore.
/// iOS: stores in Keychain.
class SecureStorageService {
  SecureStorageService._();
  static final SecureStorageService instance = SecureStorageService._();

  final _log = Logger();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // ── Generic read/write/delete ──────────────────────────────

  Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      _log.e('SecureStorage write failed: $key', error: e);
    }
  }

  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      _log.e('SecureStorage read failed: $key', error: e);
      return null;
    }
  }

  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      _log.e('SecureStorage delete failed: $key', error: e);
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      _log.e('SecureStorage deleteAll failed', error: e);
    }
  }

  // ── Typed helpers ──────────────────────────────────────────

  static const _keyUserId = 'secure_user_id';
  static const _keyRevenueCatId = 'secure_rc_user_id';
  static const _keyOpenAiKey = 'secure_openai_key';
  static const _keyGeminiKey = 'secure_gemini_key';

  Future<void> saveUserId(String uid) =>
      write(key: _keyUserId, value: uid);

  Future<String?> getUserId() => read(key: _keyUserId);

  Future<void> saveRevenueCatId(String rcId) =>
      write(key: _keyRevenueCatId, value: rcId);

  Future<String?> getRevenueCatId() => read(key: _keyRevenueCatId);

  /// Save AI API key retrieved at runtime (e.g., from Firebase Remote Config).
  /// Do NOT call this with a hardcoded string.
  Future<void> saveOpenAiKey(String key) =>
      write(key: _keyOpenAiKey, value: key);

  Future<String?> getOpenAiKey() => read(key: _keyOpenAiKey);

  Future<void> saveGeminiKey(String key) =>
      write(key: _keyGeminiKey, value: key);

  Future<String?> getGeminiKey() => read(key: _keyGeminiKey);

  /// Call on sign-out — clears all user-scoped secrets.
  Future<void> clearUserData() async {
    await delete(key: _keyUserId);
    await delete(key: _keyRevenueCatId);
  }
}
