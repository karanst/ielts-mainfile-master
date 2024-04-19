// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
// import 'package:flutter/material.dart';
//
// class FacebookAdsManager {
//   static final _remoteConfig = FirebaseRemoteConfig.instance;
//   static  Future<void> init() async {
//     await _remoteConfig.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(seconds: 10),
//       minimumFetchInterval: Duration.zero,
//     ));
//
//     await _remoteConfig.fetchAndActivate();
//   }
//
//   String get interstitialAdPlacementId =>
//       _remoteConfig.getString('1418545492107933_1418550925440723');
//
//   String get rewardedAdPlacementId =>
//       _remoteConfig.getString('1418545492107933_1418551362107346');
//
//   String get nativeAdPlacementId =>
//       _remoteConfig.getString('1418545492107933_1418551248774024 ');
//
//   Future<void> showInterstitialAd() async {
//     await FacebookInterstitialAd.loadInterstitialAd(
//       placementId: interstitialAdPlacementId,
//       listener: (result, value) {
//         if (result == InterstitialAdResult.LOADED)
//           FacebookInterstitialAd.showInterstitialAd();
//       },
//     );
//   }
//
//   Future<void> showRewardedAd() async {
//     await FacebookRewardedVideoAd.loadRewardedVideoAd(
//       placementId: rewardedAdPlacementId,
//       listener: (result, value) {
//         if (result == RewardedVideoAdResult.LOADED)
//           FacebookRewardedVideoAd.showRewardedVideoAd();
//       },
//     );
//   }
//
//   Widget buildNativeAd() {
//     return FacebookNativeAd(
//       placementId: nativeAdPlacementId,
//       adType: NativeAdType.NATIVE_BANNER_AD,
//       bannerAdSize: NativeBannerAdSize.HEIGHT_100,
//       width: double.infinity,
//       backgroundColor: Colors.blue,
//       titleColor: Colors.white,
//       descriptionColor: Colors.white,
//       buttonColor: Colors.deepPurple,
//       buttonTitleColor: Colors.white,
//       buttonBorderColor: Colors.white,
//       listener: (result, value) {
//         print("Native Banner Ad: $result --> $value");
//       },
//     );
//   }
// }

import 'dart:developer';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

/*
class MyAds {
  MyAds() {
    FacebookAudienceNetwork.init(
        testingId: '86c09266-b06c-4f8b-8431-d3f6cd7616f2'
    );
  }

  void showRewardedAd() {
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: "VID_HD_9_16_39S_APP_INSTALL#YOUR_PLACEMENT_ID",
      listener: (result, value) {
        if (result == RewardedVideoAdResult.LOADED) {
          FacebookRewardedVideoAd.showRewardedVideoAd();
        }
      },
    );
  }

  void showInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          FacebookInterstitialAd.showInterstitialAd();
        }
      },
    );
  }

  void buildBannerAd() {
    FacebookBannerAd(
      placementId: "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID",
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        print("Banner Ad: $result --> $value");
      },
    );
  }

  Widget buildNativeAd() {
    return FacebookNativeAd(
        placementId: "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID",
        adType: NativeAdType.NATIVE_BANNER_AD,
        bannerAdSize: NativeBannerAdSize.HEIGHT_100,
        width: double.infinity,
        backgroundColor: Colors.blue,
        titleColor: Colors.white,
        descriptionColor: Colors.white,
        buttonColor: Colors.deepPurple,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
        listener: (result, value) {
          print("Native Banner Ad: $result --> $value");
        }
    );
  }
}*/

class MyAds {
  static final _remoteConfig = FirebaseRemoteConfig.instance;

  MyAds() {
    FacebookAudienceNetwork.init(testingId: '244295511708118');
    // Initialize Remote Config
    initRemoteConfig();
  }

  static Future<void> initRemoteConfig() async {
    await _remoteConfig.setDefaults(<String, dynamic>{
      'rewarded_placement_id':
          'VID_HD_9_16_39S_APP_INSTALL#244295511708118_244306728373663',
      'interstitial_placement_id':
          'IMG_16_9_APP_INSTALL#244295511708118_244306625040340',
      'banner_placement_id':
          'IMG_16_9_APP_INSTALL#244295511708118_244305078373828',
      'native_placement_id':
          'IMG_16_9_APP_INSTALL#244295511708118_244307471706922',
      "show_facebook_ads": true
    });

    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 30)));
    await _remoteConfig.fetchAndActivate();
    log('Remote Config Data: ${_remoteConfig.getBool('show_facebook_ads')}');

    _remoteConfig.onConfigUpdated.listen((event) async {
      await _remoteConfig.activate();
      log('Updated: ${_remoteConfig.getBool('show_facebook_ads')}');
    });
  }

  static bool get _showAd => _remoteConfig.getBool('show_facebook_ads');
  String get rewardedPlacementId =>
      _remoteConfig.getString('rewarded_placement_id');
  String get interstitialPlacementId =>
      _remoteConfig.getString('interstitial_placement_id');
  String get bannerPlacementId =>
      _remoteConfig.getString('banner_placement_id');
  String get nativePlacementId =>
      _remoteConfig.getString('native_placement_id');
  static bool get hideAds => !_showAd;

  void showRewardedAd() {
    // log('Precache Interstitial Ad - Id: ${MyAds}');
    if (MyAds.hideAds) return;
    if (premium_user_google_play) return;
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: 'IMG_16_9_APP_INSTALL#244295511708118_244306728373663',
      listener: (result, value) {
        log("reworded: $result --> $value");
        if (result == RewardedVideoAdResult.LOADED) {
          FacebookRewardedVideoAd.showRewardedVideoAd();
        }
      },
    );
  }

  void showInterstitialAd() {
    if (MyAds.hideAds) return;
    if (premium_user_google_play) return;
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: interstitialPlacementId,
      listener: (result, value) {
        log("Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          FacebookInterstitialAd.showInterstitialAd();
        }
      },
    );
  }

  Widget buildBannerAd() {
    if (MyAds.hideAds) {
      return SizedBox();
    }
    if (premium_user_google_play) {
      return SizedBox();
    }

    return FacebookBannerAd(
      placementId: 'IMG_16_9_APP_INSTALL#244295511708118_244305078373828',
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        if (result == BannerAdResult.LOADED) {
          print('Banner Ad Error: $value'); // Log the error message
        }
        print("Banner Ad: $result --> $value");
      },
    );
  }

  Widget buildNativeAd() {
    if (MyAds.hideAds) {
      return SizedBox();
    }
    if (premium_user_google_play) {
      return SizedBox();
    }
    return FacebookNativeAd(
      placementId: 'IMG_16_9_APP_INSTALL#244295511708118_244307471706922',
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.white,
      titleColor: Colors.black,
      descriptionColor: Colors.black,
      buttonColor: Colors.blue,
      buttonTitleColor: Colors.black,
      buttonBorderColor: Colors.black,
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 1000,
    );
  }
}
