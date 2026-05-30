import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

/// Handles Firebase Cloud Messaging setup.
/// Call [NotificationService.instance.initialize()] from main.dart.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _log = Logger();

  Future<void> initialize() async {
    // 1. Request permission (Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    _log.i('FCM permission: ${settings.authorizationStatus}');

    // 2. Get token
    final token = await _messaging.getToken();
    _log.i('FCM token: $token');
    // TODO: Send token to your backend or save to Firestore

    // 3. Foreground message handler
    FirebaseMessaging.onMessage.listen((message) {
      _log.d('FCM foreground: ${message.notification?.title}');
      // TODO: Show in-app notification banner
      _handleMessage(message);
    });

    // 4. Background/terminated tap handler
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _log.d('FCM opened from background: ${message.notification?.title}');
      _handleMessage(message);
    });

    // 5. Terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _log.d('FCM app opened from terminated: ${initialMessage.notification?.title}');
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) {
    // TODO: Navigate to relevant screen based on message.data
    // Example: if (message.data['type'] == 'promo') router.push('/paywall');
  }

  Future<String?> getToken() => _messaging.getToken();
}
