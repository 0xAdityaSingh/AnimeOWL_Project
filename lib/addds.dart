import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const String testDevice = 'ca-app-pub-7187079853593886~3954729679';

class AdmobService {
  static InterstitialAd _interstitialAd;

  static String get iOSInterstitialAdUnitID => Platform.isAndroid
      ? 'ca-app-pub-6871076881985583/5883860185'
      : 'ca-app-pub-6871076881985583/5883860185';

  static initialize() {
    if (MobileAds.instance == null) {
      print("initialize:AdMob");
      MobileAds.instance.initialize();
    }
  }

  static InterstitialAd _createInterstitialAd() {
    return InterstitialAd(
      adUnitId: iOSInterstitialAdUnitID,
      request: AdRequest(),
      listener: AdListener(
          onAdLoaded: (Ad ad) => {_interstitialAd.show()},
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('Ad failed to load: $error');
          },
          onAdOpened: (Ad ad) => print('Ad opened.'),
          onAdClosed: (Ad ad) => {_interstitialAd.dispose()},
          onApplicationExit: (Ad ad) => {_interstitialAd.dispose()}),
    );
  }

  static void showInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;

    if (_interstitialAd == null) _interstitialAd = _createInterstitialAd();

    _interstitialAd.load();
  }
}
