import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ielts/widgets/dialog.dart';
import 'package:ielts/widgets/remote-config.dart';
import 'package:native_ads_flutter/native_ads.dart';

import '../screens/home_screen.dart';

class AdHelper {
  // for initializing ads sdk
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
  }

  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;
  static bool _interstitialAdLoaded = false;
  static bool _rewardedAdLoaded = false;

  static NativeAd? _nativeAd;
  static bool _nativeAdLoaded = false;

  //*****************Interstitial Ad******************

  static void precacheInterstitialAd() {
    log('Precache Interstitial Ad - Id: ${Config.interstitialAd}');

    if (Config.hideAds) return;

    InterstitialAd.load(
      adUnitId: Config.interstitialAd,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          //ad listener
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            _resetInterstitialAd();
            precacheInterstitialAd();
          });
          _interstitialAd = ad;
          _interstitialAdLoaded = true;
        },
        onAdFailedToLoad: (err) {
          _resetInterstitialAd();
          log('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  static void _resetInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _interstitialAdLoaded = false;
  }

  static void showInterstitialAd({required VoidCallback onComplete}) {
    log('Interstitial Ad Id: ${Config.interstitialAd}');

    if (Config.hideAds) {
      onComplete();
      return;
    }
    if (premium_user_google_play) {
      onComplete();
      return;
    }

    if (_interstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd?.show();
      onComplete();
      return;
    }

    MyDialogs.showProgress();

    InterstitialAd.load(
      adUnitId: Config.interstitialAd,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          //ad listener
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            onComplete();
            _resetInterstitialAd();
            precacheInterstitialAd();
          });
          Get.back();
          ad.show();
        },
        onAdFailedToLoad: (err) {
          Get.back();
          log('Failed to load an interstitial ad: ${err.message}');
          onComplete();
        },
      ),
    );
  }

  //*****************Native Ad******************

  static void precacheNativeAd() {
    // log('Precache Native Ad - Id: ${Config.nativeAd}');
    //
    if (Config.hideAds) return;
    if (premium_user_google_play) return;

    _nativeAd = NativeAd(
        adUnitId: Config.nativeAd,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('$NativeAd loaded.');
            _nativeAdLoaded = true;
          },
          onAdFailedToLoad: (ad, error) {
            _resetNativeAd();
            log('$NativeAd failed to load: $error');
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.small))
      ..load();
  }

  static void _resetNativeAd() {
    _nativeAd?.dispose();
    _nativeAd = null;
    _nativeAdLoaded = false;
  }

  static NativeAd? loadNativeAd({required NativeAdController adController}) {
    log('Native Ad Id: ${Config}');

    if (Config.hideAds) return null;
    if (premium_user_google_play) return null;

    if (_nativeAdLoaded && _nativeAd != null) {
      adController.adLoaded.value = true;
      return _nativeAd;
    }

    return NativeAd(
        adUnitId: Config.nativeAd,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('$NativeAd loaded.');
            adController.adLoaded.value = true;
            _resetNativeAd();
            precacheNativeAd();
          },
          onAdFailedToLoad: (ad, error) {
            _resetNativeAd();
            log('$NativeAd failed to load: $error');
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.small))
      ..load();
  }

  //*****************Rewarded Ad******************
  static void precacheRewardedAd() {
    log('Precache Rewarded Ad - Id: ${Config.rewardedAd}');

    if (Config.hideAds) return;
    if (premium_user_google_play) return;

    RewardedAd.load(
      adUnitId: Config.rewardedAd,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          // Ad listener
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            _resetRewardedAd();
            precacheRewardedAd();
          }, onAdFailedToShowFullScreenContent: (ad, error) {
            log('Failed to show rewarded ad: $error');
            _resetRewardedAd();
            precacheRewardedAd();
          });

          _rewardedAd = ad;
          _rewardedAdLoaded = true;
        },
        onAdFailedToLoad: (err) {
          _resetRewardedAd();
          log('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  static void _resetRewardedAd() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _rewardedAdLoaded = false;
  }

  static void showRewardedAd({required VoidCallback onComplete}) {
    log('Rewarded Ad Id: ${Config.rewardedAd}');

    if (Config.hideAds) {
      onComplete();
      return;
    }
    if (premium_user_google_play) {
      onComplete();
      return;
    }

    if (_rewardedAdLoaded && _rewardedAd != null) {
      _rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {});
      onComplete();
      return;
    }

    MyDialogs.showProgress();

    RewardedAd.load(
      adUnitId: Config.rewardedAd,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          // Ad listener
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            onComplete();
            _resetRewardedAd();
            precacheRewardedAd();
          }, onAdFailedToShowFullScreenContent: (ad, error) {
            log('Failed to show rewarded ad: $error');
            onComplete();
            _resetRewardedAd();
            precacheRewardedAd();
          });

          Get.back();
          ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {});
        },
        onAdFailedToLoad: (err) {
          Get.back();
          log('Failed to load a rewarded ad: ${err.message}');
          onComplete();
        },
      ),
    );
  }

  // static void showRewardedAd({required VoidCallback onComplete}) {
  //   log('Rewarded Ad Id: ${Config.rewardedAd}');
  //
  //   if (Config.hideAds) {
  //     print('hide ads');
  //     onComplete();
  //     return;
  //   }
  //
  //   MyDialogs.showProgress();
  //
  //   RewardedAd.load(
  //     adUnitId: Config.rewardedAd,
  //     request: AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdLoaded: ( RewardedAd ad) {
  //         print('Load Ads');
  //         // Get.back();
  //         //reward listener
  //         ad.show(
  //             onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
  //               print("User earned the reward ${rewardItem.amount} ${rewardItem.type}");
  //               onComplete();
  //             });
  //         ad.fullScreenContentCallback =
  //             FullScreenContentCallback(onAdShowedFullScreenContent: (ad) {
  //
  //             },
  //             onAdFailedToShowFullScreenContent: (ad, error) {
  //               Get.back();
  //               log('Failed to show full screen content: $error');
  //               onComplete();
  //         },
  //            onAdDismissedFullScreenContent: (ad) {
  //               ad.dispose();
  //              Get.back();
  //              onComplete();
  //             },
  //             onAdImpression: (ad) {
  //               print('$ad Ad Impression');
  //         }
  //             );
  //
  //       },
  //       onAdFailedToLoad: (err) {
  //         Get.back();
  //         log('Failed to load an interstitial ad: ${err.message}');
  //         // onComplete();
  //       },
  //     ),
  //   );
  // }

/*  static void showRewardedAd({required VoidCallback onComplete}) {
    if (Config.hideAds) return;
    RewardedAd.load(
      adUnitId: Config.rewardedAd,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          log('Load Ads');
          // If you're using Get, uncomment this line
          // Get.back();

          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
              log("User earned the reward ${rewardItem.amount} ${rewardItem.type}");
              onComplete();
            },
          );

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdFailedToShowFullScreenContent: (ad, error) {
              // If you're using Get, uncomment this line
              // Get.back();
              log('Failed to show full screen content: $error');
              onComplete();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              // If you're using Get, uncomment this line
              // Get.back();
              onComplete();
            },
            onAdImpression: (ad) {
              print('$ad Ad Impression');
            },
          );
        },
        onAdFailedToLoad: (err) {
          // If you're using Get, uncomment this line
          // Get.back();
          log('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }*/
}

class NativeAdController extends GetxController {
  NativeAd? ad;
  final adLoaded = false.obs;
}
