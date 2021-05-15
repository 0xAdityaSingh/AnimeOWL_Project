import 'dart:io';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

// const String testDevice = 'ca-app-pub-7187079853593886~3954729679';

// class AdmobService {
//   static InterstitialAd _interstitialAd;

//   static String get iOSInterstitialAdUnitID => Platform.isAndroid
//       ? 'ca-app-pub-8319329448396880/7310608023'
//       : 'ca-app-pub-8319329448396880/7310608023';

//   static initialize() {
//     if (MobileAds.instance == null) {
//       print("initialize:AdMob");
//       MobileAds.instance.initialize();
//     }
//   }

//   static InterstitialAd _createInterstitialAd() {
//     return InterstitialAd(
//       adUnitId: iOSInterstitialAdUnitID,
//       request: AdRequest(),
//       listener: AdListener(
//           onAdLoaded: (Ad ad) => {_interstitialAd.show()},
//           onAdFailedToLoad: (Ad ad, LoadAdError error) {
//             print('Ad failed to load: $error');
//           },
//           onAdOpened: (Ad ad) => print('Ad opened.'),
//           onAdClosed: (Ad ad) => {_interstitialAd.dispose()},
//           onApplicationExit: (Ad ad) => {_interstitialAd.dispose()}),
//     );
//   }

//   static void showInterstitialAd() {
//     _interstitialAd?.dispose();
//     _interstitialAd = null;

//     if (_interstitialAd == null) _interstitialAd = _createInterstitialAd();

//     _interstitialAd.load();
//   }
// }

class FBAd {
  static bool _isInterstitialAdLoaded = false;
  static void initialize() {
    FacebookAudienceNetwork.init();
  }

  static void loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId:
          "308963377253159_308963677253129", //"IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617" YOUR_PLACEMENT_ID
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          loadInterstitialAd();
        }
      },
    );
  }

  static showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstial Ad not yet loaded!");
  }
}
