// lib/data/services/admob_service.dart
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  bool _isInitialized = false;

  /// Initialize AdMob SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  /// Get Banner Ad Unit ID
  /// TODO: Replace these with your actual AdMob Unit IDs
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // TODO: Replace with your Android Banner Ad Unit ID
      return 'ca-app-pub-3940256099942544/6300978111'; // Test ID
    } else if (Platform.isIOS) {
      // TODO: Replace with your iOS Banner Ad Unit ID
      return 'ca-app-pub-3940256099942544/2934735716'; // Test ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /// Create a banner ad
  BannerAd createBannerAd({
    required AdSize adSize,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
    required Function(Ad) onAdLoaded,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
      ),
    );
  }
}
