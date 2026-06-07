import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter_template/config/app_config.dart';
import 'package:flutter_template/core/paywall/paywall_provider.dart';
import 'package:flutter_template/shared_ui/theme/app_colors.dart';

/// A banner ad widget that:
/// - Hides itself for premium users
/// - Shows nothing if ads are disabled in AppConfig
/// - Renders the AdMob banner after loading
class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    if (!AppConfig.enableAds) return;

    final banner = BannerAd(
      adUnitId: AppConfig.admobBannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
              _adLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    await banner.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider);

    // Hide for premium users or if ads are globally off
    if (isPremium || !AppConfig.enableAds) return const SizedBox.shrink();

    if (!_adLoaded || _bannerAd == null) {
      // Placeholder while loading
      return Container(
        height: 50,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.adBackgroundDark
            : AppColors.adBackground,
      );
    }

    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.adBackgroundDark
          : AppColors.adBackground,
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
