import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:flutter_template/config/app_config.dart';

/// Firebase Remote Config service.
/// Allows changing free limits, feature flags, paywall copy
/// without shipping a new app update.
class RemoteConfigService {
  RemoteConfigService._();
  static final RemoteConfigService instance = RemoteConfigService._();

  final _remoteConfig = FirebaseRemoteConfig.instance;
  final _log = Logger();

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await _remoteConfig.setDefaults({
        _kFreeAiMessages: AppConfig.freeAiMessagesPerDay,
        _kFreeContentItems: AppConfig.freeContentItems,
        _kEnableAiChat: AppConfig.enableAiChat,
        _kEnableAds: AppConfig.enableAds,
        _kEnablePaywall: AppConfig.enablePaywall,
        _kForceUpdate: false,
      });
      await _remoteConfig.fetchAndActivate();
      _log.i('Remote Config fetched');
    } catch (e) {
      _log.w('Remote Config failed, using defaults', error: e);
    }
  }

  static const _kFreeAiMessages = 'free_ai_messages_per_day';
  static const _kFreeContentItems = 'free_content_items';
  static const _kEnableAiChat = 'enable_ai_chat';
  static const _kEnableAds = 'enable_ads';
  static const _kEnablePaywall = 'enable_paywall';
  static const _kForceUpdate = 'force_update';

  int get freeAiMessagesPerDay => _remoteConfig.getInt(_kFreeAiMessages);
  int get freeContentItems => _remoteConfig.getInt(_kFreeContentItems);
  bool get enableAiChat => _remoteConfig.getBool(_kEnableAiChat);
  bool get enableAds => _remoteConfig.getBool(_kEnableAds);
  bool get enablePaywall => _remoteConfig.getBool(_kEnablePaywall);
  bool get forceUpdate => _remoteConfig.getBool(_kForceUpdate);
}

final remoteConfigProvider =
    Provider<RemoteConfigService>((ref) => RemoteConfigService.instance);

final freeAiLimitProvider = Provider<int>(
  (ref) => ref.watch(remoteConfigProvider).freeAiMessagesPerDay,
);
