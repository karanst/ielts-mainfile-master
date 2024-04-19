// import 'dart:developer';
//
// import 'package:firebase_remote_config/firebase_remote_config.dart';
//
// class Config{
//   static const _defualtValues= {
//     "native_ads": "ca-app-pub-3940256099942544~145800251",
//     "interstitial_ads": "ca-app-pub-3940256099942544/1033173712",
//     "show_ads": true
//   };
//   static final _config=FirebaseRemoteConfig.instance;
//   static Future<void> initConfig()async{
//     final remoteConfig = FirebaseRemoteConfig.instance;
//     await remoteConfig.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(minutes: 1),
//       minimumFetchInterval: const Duration(minutes: 30),
//     ));
//
//
//     await _config.setDefaults(_defualtValues);
//     await _config.fetchAndActivate();
//     log('Remote Config Data: ${_config.getBool('show_ads')}');
//
//     _config.onConfigUpdated.listen((event) async {
//       await _config.activate();
//       log('updated: ${_config.getBool('show_ads')}');
//
//       // Use the new config values here.
//     });
//   }
//   static bool get _showAd=>_config.getBool('show_ads');
//   static String get interstitialAds=>_config.getString('interstitial_ads');
//
//   static bool get hideAds=>!_showAd;
// }

import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  static final _config = FirebaseRemoteConfig.instance;
  // static const rewardedAd = 'ca-app-pub-3940256099942544/5224354917';
  static const _defaultValues = {
    "interstitial_ad": "ca-app-pub-3940256099942544/1033173712",
    "native_ad": "ca-app-pub-3940256099942544/2247696110",
    "rewarded_ad": "",
    "show_ads": true
  };

  static Future<void> initConfig() async {
    await _config.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 30)));

    await _config.setDefaults(_defaultValues);
    await _config.fetchAndActivate();
    log('Remote Config Data: ${_config.getBool('show_ads')}');

    _config.onConfigUpdated.listen((event) async {
      await _config.activate();
      log('Updated: ${_config.getBool('show_ads')}');
    });
  }

  static bool get _showAd => _config.getBool('show_ads');

  //ad ids
  static String get nativeAd => _config.getString('native_ad');
  static String get interstitialAd => _config.getString('interstitial_ad');
  static String get rewardedAd => _config.getString('rewarded_ad');

  static bool get hideAds => !_showAd;
}
