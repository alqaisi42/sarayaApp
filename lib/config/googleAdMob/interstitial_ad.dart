

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants.dart';




class InterstitialAdWidget extends StatefulWidget {
  final VoidCallback? onAdDismissed;

  const InterstitialAdWidget({super.key, this.onAdDismissed});

  @override
  InterstitialAdWidgetState createState() => InterstitialAdWidgetState();
}

class InterstitialAdWidgetState extends State<InterstitialAdWidget> {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdMobKey,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              widget.onAdDismissed?.call();
              _loadInterstitialAd(); // Load the next ad
              setState(() {
                _isAdLoaded = false;
              });
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              log("Interstitial ad failed to show: $error");
              ad.dispose();
              _loadInterstitialAd();
            },
          );
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          log("Interstitial ad failed to load: $error");
          setState(() {
            _isAdLoaded = false;
          });
        },
      ),
    );
  }

  // Method to show the ad
  void showAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd?.show();
    } else {
      log("Interstitial ad not ready yet");
      _loadInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }
}