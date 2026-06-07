import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:flutter_template/config/app_config.dart';

/// Manages AdMob initialization and ad loading.
/// Call [AdService.instance.initialize()] from main.dart after Firebase.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  final _log = Logger();

  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;

  bool _bannerLoaded = false;
  bool _rewardedLoaded = false;
  bool _interstitialLoaded = false;

  // ── Initialize ─────────────────────────────────────────────
  Future<void> initialize() async {
    if (!AppConfig.enableAds) return;
    await MobileAds.instance.initialize();
    _log.i('AdMob initialized');
    _loadRewarded();
    _loadInterstitial();
  }

  // ── Banner ─────────────────────────────────────────────────
  /// Creates and loads a banner ad. Returns null if ads are disabled.
  Future<BannerAd?> loadBanner({
    required AdSize size,
    required AdManagerBannerAdListener listener,
  }) async {
    if (!AppConfig.enableAds) return null;

    _bannerAd = BannerAd(
      adUnitId: AppConfig.admobBannerId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerLoaded = true;
          _log.d('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          _bannerLoaded = false;
          _log.w('Banner ad failed: $error');
        },
      ),
    );
    await _bannerAd!.load();
    return _bannerLoaded ? _bannerAd : null;
  }

  BannerAd? get bannerAd => _bannerLoaded ? _bannerAd : null;

  // ── Rewarded ───────────────────────────────────────────────
  void _loadRewarded() {
    if (!AppConfig.enableAds) return;
    RewardedAd.load(
      adUnitId: AppConfig.admobRewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedLoaded = true;
          _log.d('Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          _rewardedLoaded = false;
          _log.w('Rewarded ad failed: $error');
        },
      ),
    );
  }

  /// Shows a rewarded ad. [onRewarded] is called on completion.
  Future<bool> showRewarded({
    required void Function(RewardItem reward) onRewarded,
  }) async {
    if (!_rewardedLoaded || _rewardedAd == null) {
      _log.w('Rewarded ad not ready');
      return false;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedLoaded = false;
        _loadRewarded(); // Pre-load next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedLoaded = false;
        _loadRewarded();
      },
    );

    await _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      onRewarded(reward);
    });
    return true;
  }

  // ── Interstitial ───────────────────────────────────────────
  void _loadInterstitial() {
    if (!AppConfig.enableAds) return;
    InterstitialAd.load(
      adUnitId: AppConfig.admobInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoaded = true;
          _log.d('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          _interstitialLoaded = false;
          _log.w('Interstitial ad failed: $error');
        },
      ),
    );
  }

  Future<bool> showInterstitial() async {
    if (!_interstitialLoaded || _interstitialAd == null) return false;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialLoaded = false;
        _loadInterstitial();
      },
    );
    await _interstitialAd!.show();
    return true;
  }

  void dispose() {
    _bannerAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
  }
}
