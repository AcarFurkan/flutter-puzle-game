import 'dart:io' show Platform;

import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdMod { live, test }

class AdmobTransactions {
  static AdmobTransactions? _instance;

  static AdmobTransactions get instance {
    _instance ??= AdmobTransactions._init();
    return _instance!;
  }

  AdMod adMod = AdMod.live;
  AdmobTransactions._init() {
    banner = bannerAd();
  }
  RewardedAd? rewardedAd;
  late BannerAd banner;
  InterstitialAd? interstitialAd;

  fillRewardedAd() async {
    await RewardedAd.load(
        adUnitId: adMod == AdMod.test ? testRewardedId : liveRewardedId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            rewardedAd = ad;
           },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },
        ));
  }

  fillInterstitialAd() async {
    InterstitialAd.load(
        adUnitId: adMod == AdMod.test ? testInterstitialAd : liveInterstitialAd,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  final String testBunnerId = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/6300978111"
      : "ca-app-pub-3940256099942544/2934735716";
  final String liveBunnerId = Platform.isAndroid
      ? "ca-app-pub-8235301225240061/4236838267"
      : "ca-app-pub-8235301225240061/8591602979";

  final String testInterstitialAd = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/1033173712"
      : "ca-app-pub-3940256099942544/4411468910";
  final String liveInterstitialAd = Platform.isAndroid
      ? "ca-app-pub-8235301225240061/6040497227"
      : "ca-app-pub-8235301225240061/6772529938";

  final String testRewardedId = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/5224354917"
      : "ca-app-pub-3940256099942544/1712485313";
  final String liveRewardedId = Platform.isAndroid
      ? "ca-app-pub-8235301225240061/3222762193"
      : "ca-app-pub-8235301225240061/1520203252";

  BannerAd bannerAd() {
    final BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },

      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );
    return BannerAd(
      adUnitId: adMod == AdMod.test ? testBunnerId : liveBunnerId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: listener,
    );
  }
//  RewardedAd rewardedAdd() {
//
//   return RewardedAd(
//     adUnitId: rewardedBunnerId,
//     size: AdSize.banner,
//     request: AdRequest(),
//     listener: BannerAdListener(),
//   );
// }
}
