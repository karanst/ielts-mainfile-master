import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static NativeAd? _nativeAd;
  static bool _nativeAdIsLoaded = false;

  static final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110' // Replace with your ad unit ID
      : 'ca-app-pub-3940256099942544/3986624511'; // Replace with your ad unit ID

  static void loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('NativeAd loaded.');
          _nativeAdIsLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
      request: AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.teal,
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.cyan,
          backgroundColor: Colors.red,
          style: NativeTemplateFontStyle.monospace,
          size: 16.0,
        ),
        // Define other styles as needed
      ),
    )..load();
  }

  static Widget nativeAdContainer() {
    return _nativeAdIsLoaded
        ? Container(
            child: AdWidget(ad: _nativeAd!),
            alignment: Alignment.center,
            height: 170,
            color: Colors.black12,
          )
        : SizedBox();
  }
}
