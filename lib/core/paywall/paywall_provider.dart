import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter_template/config/app_config.dart';
import 'package:flutter_template/core/analytics/analytics_service.dart';

/// Notifier that tracks the user's premium entitlement.
class PaywallNotifier extends StateNotifier<bool> {
  PaywallNotifier() : super(false) {
    _init();
  }

  final _log = Logger();

  Future<void> _init() async {
    await checkEntitlement();
  }

  Future<void> checkEntitlement() async {
    try {
      final info = await Purchases.getCustomerInfo();
      state = info.entitlements.all[AppConfig.revenueCatEntitlement]
              ?.isActive ??
          false;
      await AnalyticsService.instance.setUserPremium(isPremium: state);
    } catch (e) {
      _log.w('Could not fetch entitlement', error: e);
      state = false;
    }
  }

  Future<bool> purchase(Package package) async {
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      final isPremium =
          result.customerInfo.entitlements.all[AppConfig.revenueCatEntitlement]?.isActive ??
              false;
      state = isPremium;
      if (isPremium) {
        await AnalyticsService.instance
            .logPaywallConverted(productId: package.storeProduct.identifier);
        await AnalyticsService.instance.setUserPremium(isPremium: true);
      }
      return isPremium;
    } on PurchasesErrorCode catch (e) {
      _log.e('Purchase failed', error: e);
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      final isPremium =
          info.entitlements.all[AppConfig.revenueCatEntitlement]?.isActive ??
              false;
      state = isPremium;
      return isPremium;
    } catch (e) {
      _log.e('Restore failed', error: e);
      return false;
    }
  }
}

final paywallProvider =
    StateNotifierProvider<PaywallNotifier, bool>((ref) => PaywallNotifier());

/// Shorthand: is user currently premium?
final isPremiumProvider = Provider<bool>((ref) => ref.watch(paywallProvider));
