import 'package:in_app_update/in_app_update.dart';
import 'package:logger/logger.dart';

/// Checks for Play Store updates when the app starts.
/// Uses the flexible update flow (non-blocking).
///
/// Call [UpdateService.instance.checkForUpdate()] from main.dart or
/// from the home screen's initState.
class UpdateService {
  UpdateService._();
  static final UpdateService instance = UpdateService._();

  final _log = Logger();

  /// Checks for an available update on the Play Store.
  /// If an update is available, starts the flexible download in the background.
  /// When complete, shows a snackbar-style prompt to install.
  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        _log.i('In-app update available (flexible)');
        await _startFlexibleUpdate();
      } else {
        _log.d('No update available');
      }
    } catch (e) {
      // Fail silently — update check should never crash the app
      _log.w('In-app update check failed', error: e);
    }
  }

  Future<void> _startFlexibleUpdate() async {
    try {
      final result = await InAppUpdate.startFlexibleUpdate();
      _log.i('Flexible update result: $result');

      if (result == AppUpdateResult.success) {
        // Download complete — prompt user to install
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (e) {
      _log.w('Flexible update failed', error: e);
    }
  }

  /// Force an immediate update (blocking).
  /// Use this for critical security/bug-fix releases only.
  Future<void> startImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      _log.e('Immediate update failed', error: e);
    }
  }
}
