import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants.dart';



class AppOpenAdShowManager {
  AppOpenAd? _appOpenAd;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: openAdMobKey,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          debugPrint('Error: $error');
        },
      ),

    );
  }
}