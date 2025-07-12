
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Model/auth model/auth_response_model.dart';
import '../../Model/stories_model.dart';
import '../../bloc/bookmark/bookmark_article_bloc.dart';
import '../../bloc/getSettingsBloc/get_settings_bloc.dart';
import '../../notification_service.dart';
import '../../../l10n/app_localizations.dart';

import '../colors.dart';
import '../constants.dart';
import '../hiveLocalStorage/hive_storage.dart';



String fcmToken = "";
String userDeviceId = "";
String? userProfile;
String? userName;
double longitude = 0;
double latitude = 0;
int? userID = 0;
String? authError = "";
String? userToken = "";
String userMobileNumber = "";

class MediaQueryHelper {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}


const ConnectivityResult connectivityCheck = ConnectivityResult.none;
final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();



Future<void> shareApp(appName,packageName,context) async {

  try {
    String shareText;
    String url;

    if (Platform.isAndroid) {
      url = '$androidLink$packageName';
      shareText = 'Check out $appName on Google Play Store:\n$url';
    } else if (Platform.isIOS) {
      url = '$iosLink$appStoreId';
      shareText = 'Check out $appName on App Store:\n$url';
    } else {
      throw Exception('Unsupported platform');
    }

    await Share.share(
      shareText,
      subject: 'Check out $appName!',
    );
  } catch (e) {
    debugPrint('Error sharing app: $e');

    CustomFloatingSnackBar.showCustomSnackBar(context, e.toString(), 0);
  }
}

Future<void> rateApp(String packageName, String appStoreId) async {
  final InAppReview inAppReview = InAppReview.instance;



  try {
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    } else {
      String url = Platform.isAndroid
          ? '$androidLink$packageName'
          : '$iosLink$appStoreId';

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    }
  } catch (e) {
    String url = Platform.isAndroid
        ? '$androidLink$packageName'
        : '$iosLink$appStoreId';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}


String formatNumber(int number) {
  if (number >= 1000000000) {
    double value = number / 1000000000;
    return '${value.toStringAsFixed(1)}B';
  } else if (number >= 1000000) {
    double value = number / 1000000;
    return '${value.toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    double value = number / 1000;
    return '${value.toStringAsFixed(1)}k';
  } else {
    return number.toString();
  }
}



class ImageUtils {
  static const String defaultImage = 'assets/img/logo.png';

  static ImageProvider networkImageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      return AssetImage(defaultImage);
    }

    try {
      Uri.parse(imageUrl);
      return NetworkImage(imageUrl);
    } catch (e) {
      return AssetImage(defaultImage);
    }
  }

  static Widget networkImage(
      String? imageUrl, {
        BoxFit fit = BoxFit.cover,
        double? width,
        double? height,
      }) {
    const fallbackUrl = 'https://pbs.twimg.com/profile_images/1882135977969262592/PTzP40KK_400x400.jpg';

    if (imageUrl == null || imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      return Image.network(
        fallbackUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            defaultImage,
            fit: fit,
            width: width,
            height: height,
          );
        },
      );
    }

    return Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Image.network(
          fallbackUrl,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, _, __) {
            return Image.asset(
              defaultImage,
              fit: fit,
              width: width,
              height: height,
            );
          },
        );
      },
    );
  }

}


class TextToSpeechHelper {
  static FlutterTts? _flutterTts;
  static bool _isComplete = false;
  static String _currentLanguage = 'en-US';

  static Future<void> initialize() async {
    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setLanguage(_currentLanguage);
      await _flutterTts?.setSpeechRate(0.5);
      await _flutterTts?.setPitch(1.0);

      // Add completion listener
      _flutterTts?.setCompletionHandler(() {
        _isComplete = true;
      });
    } catch (e) {
      log('TTS Initialization Error: $e');
    }
  }

  static Future<void> setLanguage(String languageCode) async {
    switch (languageCode) {
    // English variants
      case 'en':
        _currentLanguage = 'en-US';
        break;
      case 'en_GB':
        _currentLanguage = 'en-GB';
        break;
      case 'en_AU':
        _currentLanguage = 'en-AU';
        break;
      case 'en_CA':
        _currentLanguage = 'en-CA';
        break;
      case 'en_IN':
        _currentLanguage = 'en-IN';
        break;
      case 'en_IE':
        _currentLanguage = 'en-IE';
        break;
      case 'en_NZ':
        _currentLanguage = 'en-NZ';
        break;
      case 'en_ZA':
        _currentLanguage = 'en-ZA';
        break;

    // Spanish variants
      case 'es':
        _currentLanguage = 'es-ES';
        break;
      case 'es_MX':
        _currentLanguage = 'es-MX';
        break;
      case 'es_AR':
        _currentLanguage = 'es-AR';
        break;
      case 'es_CO':
        _currentLanguage = 'es-CO';
        break;
      case 'es_CL':
        _currentLanguage = 'es-CL';
        break;

    // French variants
      case 'fr':
        _currentLanguage = 'fr-FR';
        break;
      case 'fr_CA':
        _currentLanguage = 'fr-CA';
        break;
      case 'fr_BE':
        _currentLanguage = 'fr-BE';
        break;
      case 'fr_CH':
        _currentLanguage = 'fr-CH';
        break;

    // Portuguese variants
      case 'pt':
        _currentLanguage = 'pt-PT';
        break;
      case 'pt_BR':
        _currentLanguage = 'pt-BR';
        break;

    // German variants
      case 'de':
        _currentLanguage = 'de-DE';
        break;
      case 'de_AT':
        _currentLanguage = 'de-AT';
        break;
      case 'de_CH':
        _currentLanguage = 'de-CH';
        break;

    // Italian variants
      case 'it':
        _currentLanguage = 'it-IT';
        break;
      case 'it_CH':
        _currentLanguage = 'it-CH';
        break;

    // Chinese variants
      case 'zh':
        _currentLanguage = 'zh-CN'; // Mandarin (Simplified)
        break;
      case 'zh_TW':
        _currentLanguage = 'zh-TW'; // Traditional
        break;
      case 'zh_HK':
        _currentLanguage = 'zh-HK'; // Hong Kong
        break;

    // Arabic variants
      case 'ar':
        _currentLanguage = 'ar-AE'; // UAE
        break;
      case 'ar_SA':
        _currentLanguage = 'ar-SA'; // Saudi Arabia
        break;
      case 'ar_EG':
        _currentLanguage = 'ar-EG'; // Egypt
        break;

    // Indian languages
      case 'hi':
        _currentLanguage = 'hi-IN'; // Hindi
        break;
      case 'bn':
        _currentLanguage = 'bn-IN'; // Bengali
        break;
      case 'ta':
        _currentLanguage = 'ta-IN'; // Tamil
        break;
      case 'te':
        _currentLanguage = 'te-IN'; // Telugu
        break;
      case 'mr':
        _currentLanguage = 'mr-IN'; // Marathi
        break;
      case 'gu':
        _currentLanguage = 'gu-IN'; // Gujarati
        break;
      case 'kn':
        _currentLanguage = 'kn-IN'; // Kannada
        break;
      case 'ml':
        _currentLanguage = 'ml-IN'; // Malayalam
        break;
      case 'pa':
        _currentLanguage = 'pa-IN'; // Punjabi
        break;

    // Other Asian languages
      case 'ja':
        _currentLanguage = 'ja-JP'; // Japanese
        break;
      case 'ko':
        _currentLanguage = 'ko-KR'; // Korean
        break;
      case 'th':
        _currentLanguage = 'th-TH'; // Thai
        break;
      case 'vi':
        _currentLanguage = 'vi-VN'; // Vietnamese
        break;
      case 'id':
        _currentLanguage = 'id-ID'; // Indonesian
        break;
      case 'ms':
        _currentLanguage = 'ms-MY'; // Malay
        break;
      case 'fil':
        _currentLanguage = 'fil-PH'; // Filipino
        break;

    // European languages
      case 'ru':
        _currentLanguage = 'ru-RU'; // Russian
        break;
      case 'pl':
        _currentLanguage = 'pl-PL'; // Polish
        break;
      case 'nl':
        _currentLanguage = 'nl-NL'; // Dutch
        break;
      case 'nl_BE':
        _currentLanguage = 'nl-BE'; // Dutch (Belgium)
        break;
      case 'sv':
        _currentLanguage = 'sv-SE'; // Swedish
        break;
      case 'no':
        _currentLanguage = 'no-NO'; // Norwegian
        break;
      case 'da':
        _currentLanguage = 'da-DK'; // Danish
        break;
      case 'fi':
        _currentLanguage = 'fi-FI'; // Finnish
        break;
      case 'el':
        _currentLanguage = 'el-GR'; // Greek
        break;
      case 'cs':
        _currentLanguage = 'cs-CZ'; // Czech
        break;
      case 'hu':
        _currentLanguage = 'hu-HU'; // Hungarian
        break;
      case 'ro':
        _currentLanguage = 'ro-RO'; // Romanian
        break;
      case 'sk':
        _currentLanguage = 'sk-SK'; // Slovak
        break;
      case 'hr':
        _currentLanguage = 'hr-HR'; // Croatian
        break;
      case 'uk':
        _currentLanguage = 'uk-UA'; // Ukrainian
        break;
      case 'bg':
        _currentLanguage = 'bg-BG'; // Bulgarian
        break;

    // Middle Eastern languages
      case 'ur':
        _currentLanguage = 'ur-PK'; // Urdu
        break;
      case 'fa':
        _currentLanguage = 'fa-IR'; // Persian/Farsi
        break;
      case 'he':
        _currentLanguage = 'he-IL'; // Hebrew
        break;
      case 'tr':
        _currentLanguage = 'tr-TR'; // Turkish
        break;

    // Latin American Spanish variants
      case 'es_PE':
        _currentLanguage = 'es-PE'; // Peru
        break;
      case 'es_VE':
        _currentLanguage = 'es-VE'; // Venezuela
        break;
      case 'es_EC':
        _currentLanguage = 'es-EC'; // Ecuador
        break;
      case 'es_CR':
        _currentLanguage = 'es-CR'; // Costa Rica
        break;
      case 'es_UY':
        _currentLanguage = 'es-UY'; // Uruguay
        break;

    // African languages
      case 'sw':
        _currentLanguage = 'sw-KE'; // Swahili
        break;
      case 'zu':
        _currentLanguage = 'zu-ZA'; // Zulu
        break;
      case 'af':
        _currentLanguage = 'af-ZA'; // Afrikaans
        break;
      case 'am':
        _currentLanguage = 'am-ET'; // Amharic
        break;

    // Default to US English if language code not found
      default:
        _currentLanguage = 'en-US';
        break;
    }

    if (_flutterTts == null) {
      await initialize();
    }

    await _flutterTts?.setLanguage(_currentLanguage);
  }

  static Future<void> speak(String text, Function(bool) onStateChange) async {
    if (_flutterTts == null) {
      await initialize();
    }

    try {
      _isComplete = false;
      await _flutterTts?.speak(text);

      // Start listening for completion
      Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (_isComplete) {
          onStateChange(false);  // Update isReading state
          timer.cancel();
        }
      });
    } catch (e) {
      log('TTS Speaking Error: $e');
      onStateChange(false);  // Update state in case of error
    }
  }

  static Future<void> stop() async {
    await _flutterTts?.stop();
    _isComplete = true;
  }

  // Call this when navigating away
  static Future<void> dispose() async {
    await stop();
    _flutterTts?.stop();
    _flutterTts = null;
  }
}



class CustomFloatingSnackBar {

  static void showCustomSnackBar(BuildContext context, String message,int errorType) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 8,
      backgroundColor: Colors.transparent,
      content: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: errorType == 1 ? Colors.lightGreen : AppColors().primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                message,

                style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: fontType),
                maxLines: 3, // Limit to 3 lines
                overflow: TextOverflow.ellipsis, // Add ellipsis if the text exceeds 3 lines
              ),
            ),
            // SizedBox(width: 8), // Spacing between text and icon
            // Icon(Icons.info, color: Colors.white),
          ],
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}



final List<Map<String, String>> languagesCode = [
  {'code': 'en', 'name': 'English'},
  {'code': 'hi', 'name': 'हिंदी'},
  {'code': 'ar', 'name': 'Arabic'},
  {'code': 'bn', 'name': 'Bengali'},
];


//=============================================================================== Font Size


enum FontSize {
  extraSmall,
  small,
  medium,
  large,
  extraLarge;

  String get name {
    switch (this) {
      case FontSize.extraSmall:
        return 'Extra Small';
      case FontSize.small:
        return 'Small';
      case FontSize.medium:
        return 'Medium';
      case FontSize.large:
        return 'Large';
      case FontSize.extraLarge:
        return 'Extra Large';
    }
  }

  double get size {
    switch (this) {
      case FontSize.extraSmall:
        return 12;
      case FontSize.small:
        return 14;
      case FontSize.medium:
        return 16;
      case FontSize.large:
        return 18;
      case FontSize.extraLarge:
        return 25;
    }
  }

  static FontSize fromString(String value) {
    switch (value) {
      case 'Extra Small':
        return FontSize.extraSmall;
      case 'Small':
        return FontSize.small;
      case 'Medium':
        return FontSize.medium;
      case 'Large':
        return FontSize.large;
      case 'Extra Large':
        return FontSize.extraLarge;
      default:
        return FontSize.medium;
    }
  }

  // 👇 Localized name based on context
  String getLocalizedName(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (this) {
      case FontSize.extraSmall:
        return loc.extraSmall;
      case FontSize.small:
        return loc.small;
      case FontSize.medium:
        return loc.medium;
      case FontSize.large:
        return loc.large;
      case FontSize.extraLarge:
        return loc.extraLarge;
    }
  }
}



class LimitReachedPopup extends StatelessWidget {
  final String type;
  final VoidCallback? onActionPressed;
  final BuildContext context;
  final bool hasActivePlan;

  const LimitReachedPopup({
    super.key,
    required this.type,
    this.onActionPressed,
    required this.context,
    this.hasActivePlan = true,
  });

  String _getLimitMessage() {
    if (hasActivePlan) {
      if (type.toLowerCase() == 'story') {
        return AppLocalizations.of(context)!.youReachTheStoryLimit;
      } else {
        return AppLocalizations.of(context)!.youReachThePostLimit;
      }
    } else {
      switch (type.toLowerCase()) {
        case 'article':
          return AppLocalizations.of(context)!.youreachedPostLimitBuyPlan;
        case 'story':
          return AppLocalizations.of(context)!.youreachedStoriesLimitBuyPlan;
        default:
          return AppLocalizations.of(context)!.youreachedPostLimitBuyPlan;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.surface,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.red.shade400,
                size: 32,
              ),
            ),
            SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.limitReached,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: fontType,
                color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
              ),
            ),
            SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
            Text(
              _getLimitMessage(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: fontType,
                color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
              ),
            ),
            SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),

            if (!hasActivePlan)
              ElevatedButton(
                onPressed: () async {
                  if(context.mounted){
                    Navigator.of(context).pop();
                  }

                  Future.microtask(() {
                    if(context.mounted){
                      GoRouter.of(context).push('/membershipScreen');
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.oKGotIt,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              )
            else

              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.close,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors().primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}




Future<void> storeFreePlanDataHive({
  String? articleLimit,
  String? storyLimit,
  bool? isActivePlan,
  String? articleCount,
  String? storyCount,
}) async {
  final features = {
    if (articleLimit != null) 'articleLimit': articleLimit,
    if (storyLimit != null) 'storyLimit': storyLimit,
    if (isActivePlan != null) 'isActivePlan': isActivePlan,
    if (articleCount != null) 'articleCount': articleCount,
    if (storyCount != null) 'storyCount': storyCount,
  };

  log("plan values $features");

  await HiveStorage().storeFreePlanFeatures(features);
}

Future<void> checkLimitAndNavigate(BuildContext context, String slug, [String? fromRelated]) async {
  if (context.mounted) {
    if (fromRelated == 'fromRelated') {
      GoRouter.of(context).pushReplacement("/detailPage/$slug");
    } else {
      GoRouter.of(context).push("/detailPage/$slug");
    }
  }
}


// Future<void> checkLimitAndNavigate(BuildContext context, String slug, [String? fromRelated]) async {
//   final getSettingsBloc = context.read<GetSettingsBloc>();
//   final String? freeTrialPostLimit = getSettingsBloc.freeTrialPostLimit();
//
//
//
//   if (freeTrialPostLimit != "-1") {
//     final features = await HiveStorage().getFreePlanFeatures();
//
//     // Check if user has an active plan
//     final bool isActivePlan = features?['isActivePlan'] ?? false;
//
//     if (isActivePlan) {
//       // For users with active subscription
//       final String? maxArticles = features?['articleLimit'];
//       final String? usedArticles = features?['articleCount'];
//
//       if (maxArticles != null && usedArticles != null) {
//         final BigInt? maxLimit = BigInt.tryParse(maxArticles);
//         final BigInt? usedCount = BigInt.tryParse(usedArticles);
//
//         if (maxLimit != null && usedCount != null && usedCount >= maxLimit) {
//           // User has reached their plan's article limit
//           if (context.mounted) {
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (BuildContext context) {
//                 return LimitReachedPopup(
//                   context: context,
//                   type: 'article',
//                   hasActivePlan: true,
//                 );
//               },
//             );
//           }
//           return; // Exit without navigation
//         }
//       }
//     } else {
//       // For free users
//       final String? articleLimitStr = features?['articleLimit'];
//
//       final BigInt? articleLimit = BigInt.tryParse(articleLimitStr ?? '');
//
//       if (articleLimit == null || articleLimit <= BigInt.zero) {
//         if (context.mounted) {
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return LimitReachedPopup(
//                 context: context,
//                 type: 'article',
//                 hasActivePlan: false,
//               );
//             },
//           );
//         }
//         return; // Exit without navigation
//       }
//
//       // Update the remaining free article count
//       final BigInt updateVal = articleLimit - BigInt.one;
//       await HiveStorage().updateFreePlanFeatures({
//         'articleLimit': updateVal.toString(),
//       });
//     }
//   }
//
//
//   if (context.mounted) {
//     if (fromRelated == 'fromRelated') {
//       GoRouter.of(context).pushReplacement("/detailPage/$slug");
//     } else {
//       GoRouter.of(context).push("/detailPage/$slug");
//     }
//   }
// }


// Future<void> checkStoryLimitAndNavigate(BuildContext context, int index, List<Stories> allStories) async {
//   final getSettingsBloc = context.read<GetSettingsBloc>();
//   final String? freeTrialStoryLimit = getSettingsBloc.freeTrialStoryLimit();
//
//   if (freeTrialStoryLimit != "-1") {
//     final features = await HiveStorage().getFreePlanFeatures();
//     final bool isActivePlan = features?['isActivePlan'] ?? false;
//
//     if (isActivePlan) {
//       // For users with active subscription
//       final String? maxStories = features?['storyLimit'];
//       final String? usedStories = features?['storyCount'];
//
//       if (maxStories != null && usedStories != null) {
//         final int maxLimit = int.parse(maxStories);
//         final int usedCount = int.parse(usedStories);
//
//         if (usedCount >= maxLimit) {
//           if (context.mounted) {
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (BuildContext context) {
//                 return LimitReachedPopup(
//                   context: context,
//                   type: 'story',
//                   hasActivePlan: true,
//                 );
//               },
//             );
//           }
//           return;
//         }
//       }
//     } else {
//       // For free users
//       final String? storyLimitStr = features?['storyLimit'];
//       if (storyLimitStr == null || int.parse(storyLimitStr) <= 0) {
//         if (context.mounted) {
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return LimitReachedPopup(
//                 context: context,
//                 type: 'story',
//                 hasActivePlan: false,
//               );
//             },
//           );
//         }
//         return;
//       }
//
//       // Decrease the limit
//       final updateVal = int.parse(storyLimitStr) - 1;
//       await HiveStorage().updateFreePlanFeatures({
//         'storyLimit': updateVal.toString(),
//       });
//     }
//   }
//
//   // Single navigation point
//   if (context.mounted) {
//     GoRouter.of(context).push(
//       '/story',
//       extra: {
//         'initialPage': index,
//         'stories': allStories,
//       },
//     );
//   }
// }

Future<void> checkStoryLimitAndNavigate(BuildContext context, int index, List<Stories> allStories) async {
  if (context.mounted) {
    GoRouter.of(context).push(
      '/story',
      extra: {
        'initialPage': index,
        'stories': allStories,
      },
    );
  }
}


// Future<void> checkStoryLimitAndNavigate(BuildContext context, int index, List<Stories> allStories) async {
//   final getSettingsBloc = context.read<GetSettingsBloc>();
//   final String? freeTrialStoryLimit = getSettingsBloc.freeTrialStoryLimit();
//
//   if(freeTrialStoryLimit != "-1"){
//     final features = await HiveStorage().getFreePlanFeatures();
//
//
//     final bool isActivePlan = features?['isActivePlan'] ?? false;
//
//     if (isActivePlan) {
//       // For users with active subscription
//       final String? maxStories = features?['storyLimit'];
//       final String? usedStories = features?['storyCount'];
//
//       if (maxStories != null && usedStories != null) {
//         final int maxLimit = int.parse(maxStories);
//         final int usedCount = int.parse(usedStories);
//
//         if (usedCount >= maxLimit) {
//           // User has reached their plan's story limit
//           // DO NOT clear plan features here - removed the clearPlanFeatures call
//           if (context.mounted) {
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (BuildContext context) {
//                 return LimitReachedPopup(
//                   context: context,
//                   type: 'story',
//                   hasActivePlan: true,
//                 );
//               },
//             );
//           }
//           return;
//         }
//       }
//     } else {
//       // For free users
//       final String? storyLimitStr = features?['storyLimit'];
//       if (storyLimitStr == null || int.parse(storyLimitStr) <= 0) {
//         if (context.mounted) {
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return LimitReachedPopup(
//                 context: context,
//                 type: 'story',
//                 hasActivePlan: false,
//               );
//             },
//           );
//         }
//         return;
//       }
//
//       // Decrease the limit
//       final updateVal = int.parse(storyLimitStr) - 1;
//       await HiveStorage().updateFreePlanFeatures({
//         'storyLimit': updateVal.toString(),
//       });
//     }
//
//     // Navigate to the story page
//     if (context.mounted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => StoryPage(
//             initialPage: index,
//             stories: allStories,
//           ),
//         ),
//       );
//     }
//   }
//   if (context.mounted) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StoryPage(
//           initialPage: index,
//           stories: allStories,
//         ),
//       ),
//     );
//   }
//
// }



class LocationService {

  final locationSettings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10,
  );

  Future<Position> getCurrentLocation() async {bool serviceEnabled;LocationPermission permission;serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled');
  }


  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
        'Location permissions are permanently denied, cannot request permissions.');
  }


  return await Geolocator.getCurrentPosition(
    locationSettings: locationSettings,
  );
  }


  Future<Position?> getLastKnownLocation() async {
    return await Geolocator.getLastKnownPosition();
  }


  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }
}

Future<void> deviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    userDeviceId = androidInfo.id;
  }
  if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    userDeviceId = iosInfo.identifierForVendor!;

  }

}


Future<void> getFcmtoken() async {

  final token = await _firebaseMessagingService.getToken();
  fcmToken = token!;
  log('FCM Token: $fcmToken ${"vsvsvcdxccx"}');
}


Future<void> getUserId() async {
  final AuthResponse? authResponse = await HiveStorage().getToken();
  if (authResponse != null && authResponse.data?.token != null) {
    userID = authResponse.data?.user!.id!;
  } else {
    userID = 0;
    log('Token not found or not available');
  }
}




class BookmarkUtils {

  /// Toggle bookmark status for a post
  static Future<void> toggleBookmark(BuildContext context, String postSlug) async {
    final bookmarkBloc = context.read<BookmarkArticleBloc>();
    final state = bookmarkBloc.state;

    if (state is BookmarkArticleAll) {
      if (state.slugs.contains(postSlug)) {
        // Remove bookmark
        bookmarkBloc.add(BookmarkArticleRemove(
            context: context,
            slug: postSlug,
            slugType: "bookmark"
        ));
      } else {
        // Add bookmark
        bookmarkBloc.add(BookmarkArticleAdd(
            slug: postSlug,
            context: context,
            slugType: "bookmark"
        ));
      }
    }
  }

  /// Check if a post is bookmarked
  static bool isBookmarked(BuildContext context, String postSlug) {
    final state = context.read<BookmarkArticleBloc>().state;
    if (state is BookmarkArticleAll) {
      return state.slugs.contains(postSlug);
    }
    return false;
  }

  /// Get appropriate bookmark icon based on bookmark status
  static IconData getBookmarkIcon(BuildContext context, String postSlug) {
    return isBookmarked(context, postSlug)
        ? HeroiconsSolid.bookmark
        : HeroiconsOutline.bookmark;
  }

  /// Get appropriate bookmark icon color based on bookmark status
  static Color getBookmarkIconColor(BuildContext context, String postSlug) {
    return isBookmarked(context, postSlug)
        ? AppColors().primaryColor
        : AppColors().primaryColor;
  }

  /// Get bookmark text based on bookmark status
  static String getBookmarkText(BuildContext context, String postSlug) {
    return isBookmarked(context, postSlug)
        ? AppLocalizations.of(context)!.removeBookmark
        : AppLocalizations.of(context)!.bookmarkPost;
  }

  /// Share a post
  static void sharePost(String postSlug) {
    final String appLink = '$baseUrl/posts/$postSlug';
    Share.share(appLink);
  }

  /// Show bookmark and share bottom sheet
  static void showBookmarkShareSheet(BuildContext context, String postSlug) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: BlocBuilder<BookmarkArticleBloc, BookmarkArticleState>(
            builder: (context, state) {
              state as BookmarkArticleAll;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(
                      getBookmarkIcon(context, postSlug),
                      color: getBookmarkIconColor(context, postSlug),
                    ),
                    title: Text(
                      getBookmarkText(context, postSlug),
                      style: TextStyle(fontFamily: fontType),
                    ),
                    onTap: () async {
                      await toggleBookmark(context, postSlug);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: Colors.green,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.share,
                      style: TextStyle(fontFamily: fontType),
                    ),
                    onTap: () {
                      sharePost(postSlug);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Simple bookmark button widget that can be used anywhere
  static Widget bookmarkButton(BuildContext context, String postSlug, {
    double size = 24.0,
    VoidCallback? onPressed,
  }) {
    return BlocBuilder<BookmarkArticleBloc, BookmarkArticleState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: onPressed ?? () => toggleBookmark(context, postSlug),
          child: Icon(
            getBookmarkIcon(context, postSlug),
            size: size,
            color: getBookmarkIconColor(context, postSlug),
          ),
        );
      },
    );
  }

  /// Simple share button widget that can be used anywhere
  static Widget shareButton(String postSlug, {
    double size = 24.0,
    Color? color,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed ?? () => sharePost(postSlug),
      child: Icon(
        Icons.share,
        size: size,
        color: color ?? Colors.grey.shade600,
      ),
    );
  }
}