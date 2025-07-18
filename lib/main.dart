import 'dart:convert';
import 'dart:developer';

import 'package:app_links/app_links.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../l10n/app_localizations.dart';
import 'package:newsapp/routes/app_routes.dart';
import 'package:newsapp/screens/videoNews/videoNewsBloc/video_newsall_bloc.dart';
import 'bloc/chatBotBloc/chatbot_bloc.dart';
import 'config/openai/openai_service.dart';
import 'utils/widgets/chatbot_float_button.dart';
import 'bloc/authBloc/auth_bloc.dart';
import 'bloc/blocRepository/weather_repo.dart';
import 'bloc/bookmark/bookmark_article_bloc.dart';
import 'bloc/bookmarkBloc/bookmark_bloc.dart';
import 'bloc/categoryNewsBloc/category_bloc.dart';
import 'bloc/channelBloc/channel_bloc.dart';
import 'bloc/channelPageBloc/channel_page_bloc.dart';
import 'bloc/channelsAllBloc/channel_all_bloc.dart';
import 'bloc/channelsPreferenceBloc/channel_preference_bloc.dart';
import 'bloc/commentsCountBloc/comment_count_bloc.dart';
import 'bloc/commentsReplyBloc/comments_reply_bloc.dart';
import 'bloc/contactUsBloc/contactus_bloc.dart';
import 'bloc/deleteCommentBloc/delete_comment_bloc.dart';
import 'bloc/deleteUserBloc/delete_user_bloc.dart';
import 'bloc/detailPageBloc/details_page_bloc.dart';
import 'bloc/deviceFCMBloc/device_fcm_bloc.dart';
import 'bloc/discoverBloc/discover_bloc.dart';
import 'bloc/editCommentBloc/edit_comment_bloc.dart';
import 'bloc/emojiBloc/emojireact_user_bloc.dart';
import 'bloc/emojiPostBloc/emoji_post_bloc.dart';
import 'bloc/fevoritesBloc/fevorites_bloc.dart';
import 'bloc/followAndUnfollowBloc/follow_and_unfollow_bloc.dart';
import 'bloc/followedChannelsPostBloc/followed_channels_post_bloc.dart';
import 'bloc/fontSizeBloc/font_size_bloc.dart';
import 'bloc/forgatePasswordBloc/forgot_password_bloc.dart';
import 'bloc/fullScreenModeBloc/full_screen_mode_bloc.dart';
import 'bloc/generateSignatureBloc/generate_signature_bloc.dart';
import 'bloc/getCommentsBloc/get_comments_bloc.dart';
import 'bloc/getReacUserDataBloc/get_react_user_data_bloc.dart';
import 'bloc/getSettingsBloc/get_settings_bloc.dart';
import 'bloc/getUserProfileBloc/get_user_profile_bloc.dart';
import 'bloc/languageBloc/language_switcher_bloc.dart';
import 'bloc/languageBloc/language_switcher_state.dart';
import 'bloc/locationCoordinatesBloc/location_coordinates_bloc.dart';
import 'bloc/memberShipPlanBloc/membership_bloc.dart';
import 'bloc/multiLanguageGetBloc/multi_lang_bloc.dart';
import 'bloc/multiNewsPostslangBloc/multi_news_post_bloc.dart';
import 'bloc/newsPage_bloc/newspage_bloc.dart';
import 'bloc/newsTopicsBloc/news_topic_bloc.dart';
import 'bloc/notificationBloc/notification_bloc.dart';
import 'bloc/notificationReadBloc/notification_read_bloc.dart';
import 'bloc/paymentSettingsBloc/paymentsettings_bloc.dart';
import 'bloc/popularHomeNewsBloc/popular_news_home_bloc.dart';
import 'bloc/popularNewsAllBloc/popular_newsall_bloc.dart';
import 'bloc/postCommentsBloc/post_comments_bloc.dart';
import 'bloc/recommendationNewAllBloc/recommendation_newsall_bloc.dart';
import 'bloc/recommendationNewsBloc/recommendation_bloc.dart';
import 'bloc/reportCommentBloc/report_comment_bloc.dart';
import 'bloc/searchResultBloc/search_result_bloc.dart';
import 'bloc/sliderBloc/slider_bloc.dart';
import 'bloc/storiesAllBloc/stories_all_bloc.dart';
import 'bloc/storiesBloc/stories_bloc.dart';
import 'bloc/storiesTopicsBloc/stories_topics_bloc.dart';
import 'bloc/stripeBloc/generate_stripe_link_bloc.dart';
import 'bloc/subscriptionCountBloc/subscription_count_bloc.dart';
import 'bloc/suggestionBloc/suggestion_bloc.dart';
import 'bloc/themeBloc/theme_switcher_bloc.dart';
import 'bloc/totalReactionBloc/total_reaction_bloc.dart';
import 'bloc/transactionBloc/transaction_bloc.dart';
import 'bloc/updateuserProfileBloc/update_userprofile_bloc.dart';
import 'bloc/userChannelFollowListBloc/user_channelfollow_bloc.dart';
import 'bloc/verifyPaymentBloc/verify_payment_bloc.dart';
import 'bloc/viewCountBloc/view_count_bloc.dart';
import 'bloc/weatherBloc/weather_bloc.dart';

import 'config/googleAdMob/open_ad.dart';
import 'config/helper/helper_functions.dart';
import 'config/hiveLocalStorage/hive_storage.dart';
import 'config/theme.dart';
import 'firebase_options.dart';

import 'notification_service.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ✅ Avoid duplicate initialization error
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  final payload = {
    'title': message.data['title'] ?? message.notification?.title ?? '',
    'body': message.data['body'] ?? message.notification?.body ?? '',
    'slug': message.data['slug'] ?? '',
    'type': message.data['type'] ?? '',
    'notification_id': message.data['notification_id'] ?? '',
    "image": message.data['image'],
    "channelLogo": message.data['channel_logo'],
    "channelName": message.data['channel_name']
  };

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  AndroidNotificationDetails androidDetails;

  if (message.data['image'] != null && message.data['image'].isNotEmpty) {
    final imagePath = await FirebaseMessagingService().downloadAndSaveImage(
        message.data['image'],
        'notification_img.jpg'
    );

    String channelLogoPath = '';
    if (message.data['channel_logo'] != null && message.data['channel_logo'].isNotEmpty) {
      channelLogoPath = await FirebaseMessagingService().downloadAndSaveImage(
          message.data['channel_logo'],
          'channelLogo_img.jpg'
      );
    }

    if (imagePath.isNotEmpty) {
      androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: channel.importance,
        priority: Priority.high,
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(imagePath),
          largeIcon: channelLogoPath.isNotEmpty ? FilePathAndroidBitmap(channelLogoPath) : null,
          contentTitle: message.data['channel_name'] ?? '',
          summaryText: message.notification?.body,
          htmlFormatContent: true,
          htmlFormatContentTitle: true,
        ),
      );
    } else {
      androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: channel.importance,
        priority: Priority.high,
        styleInformation: message.data['channel_name'] != null && message.data['channel_name'].isNotEmpty
            ? BigTextStyleInformation(
          payload['body'] ?? '',
          contentTitle: message.data['channel_name'] ?? '',
          summaryText: message.notification?.body,
        )
            : null,
      );
    }
  } else {
    androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      importance: channel.importance,
      priority: Priority.high,
      styleInformation: message.data['channel_name'] != null && message.data['channel_name'].isNotEmpty
          ? BigTextStyleInformation(
        payload['body'] ?? '',
        contentTitle: message.data['channel_name'] ?? '',
        summaryText: message.notification?.body,
      )
          : null,
    );
  }

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    payload['title'],
    payload['body'],
    NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    ),
    payload: jsonEncode(payload),
  );
}



void _handleNotificationTap(String? slug) {
  if (slug != null) {

    router.go('/home');
    Future.delayed(const Duration(milliseconds: 100), () {
      router.push('/detailpage/$slug');
    });
  }
}




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await HiveStorage().openBox(HiveStorage().themeBoxName);
  await HiveStorage().openBox(HiveStorage().tokenBoxName);
  await HiveStorage().openBox(HiveStorage().languageBoxName);
  await HiveStorage().openBox(HiveStorage().fontSizeKey);
  await HiveStorage().openBox(HiveStorage().freePlanFeaturesKey);
  await HiveStorage().openBox(HiveStorage().selectedLanguageKey);
  await HiveStorage().openBox(HiveStorage().lastFreePlanUpdateKey);
  await HiveStorage().openBox(HiveStorage().firstLaunchKey);
  await HiveStorage().openBox(HiveStorage().languageCodeMapKey);
  await HiveStorage().openBox(HiveStorage().endDateBoxName);
  await HiveStorage().openBox(HiveStorage().lastEndDateBoxName);
  await HiveStorage().openBox(HiveStorage().isAdFreeBocKey);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  // MobileAds.instance.initialize();
  // final messagingService = FirebaseMessagingService();
  // messagingService.initialize();

  final appLinks = AppLinks();



  void handleDeepLink(Uri uri) {
    if (uri.scheme == 'newshunt') {
      router.go('/home');
    }
  }




  Future<void> initDeepLinkListener() async {

    final initialLink = await appLinks.getInitialLink();
    if (initialLink != null) {
      handleDeepLink(initialLink);
    }

    // Remove asterisks
    appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    });
  }

  await initDeepLinkListener();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationAppLaunchDetails? launchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (launchDetails?.didNotificationLaunchApp == true) {
    final String? payload = launchDetails?.notificationResponse?.payload;

    if (payload?.isNotEmpty ?? false) {
      try {
        final Map<String, dynamic> payloadMap = jsonDecode(payload!);

        // Ensure 'slug' is retrieved correctly
        final String? articleSlug = payloadMap['slug'];

        if (articleSlug != null && articleSlug.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleNotificationTap(articleSlug); // Navigate using slug
          });
        }
      } catch (e) {
        log('Error parsing launch payload: $e');
        log('Payload received: $payload');
      }
    }
  }



  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);





  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final articleSlug = message.data['body'] as String?;
    if (articleSlug != null) {
      _handleNotificationTap(articleSlug);
    }
  });


  // final HiveStorage hiveStorage = HiveStorage();
  // final bool isAdFree = await hiveStorage.getAdFreeStatus();

  // if (isAdFree == false) {
  //   final AppOpenAdShowManager appOpenAdManager = AppOpenAdShowManager();
  //   appOpenAdManager.loadAd();
  // }

  runApp(MyApp());
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


class MyApp extends StatefulWidget {

  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();
  String? _fcmToken;
  final List<Locale> supportedLocales = languagesCode.map((lang) => Locale(lang['code']!)).toList();

  @override
  void initState() {
    super.initState();
    initializeNotification();
  }

  Future<void> initializeNotification() async {
    final token = await _firebaseMessagingService.getToken();
    setState(() {
      _fcmToken = token;
    });
    log('FCM Token: $_fcmToken');
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => BookmarkArticleBloc()),
        BlocProvider(create: (context) => LanguageBloc.instance),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => SliderBloc()),
        BlocProvider(create: (context) => PopularBloc()),
        BlocProvider(create: (context) => PopularNewsAllBloc()),
        BlocProvider(create: (context) => ChannelBloc()),
        BlocProvider(create: (context) => FevoritesBloc()),
        BlocProvider(create: (context) => RecommendationBloc()),
        BlocProvider(create: (context) => NewsTopicBloc()),
        BlocProvider(create: (context) => DetailspageBloc()),
        BlocProvider(create: (context) => CategoryBloc()),
        BlocProvider(create: (context) => BookmarkBloc()),
        BlocProvider(create: (context) => DiscoverBloc()),
        BlocProvider(create: (context) => SuggestionBloc()),
        BlocProvider(create: (context) => SearchResultBloc()),
        BlocProvider(create: (context) => FollowandunfollowBloc()),
        BlocProvider(create: (context) => CommentsPostBloc()),
        BlocProvider(create: (context) => GetCommentsBloc()),
        BlocProvider(create: (context) => CommentsReplyBloc()),
        BlocProvider(create: (context) => ChannelPageBloc()),
        BlocProvider(create: (context) => NewsPageBloc()),
        BlocProvider(create: (context) => GetSettingsBloc()),
        BlocProvider(create: (context) => UpdateUserProfileBloc()),
        BlocProvider(create: (context) => ForgatePasswordBloc()),
        BlocProvider(create: (context) => ChannelsAllBloc()),
        BlocProvider(create: (context) => ChannelsAllBloc()),
        BlocProvider(create: (context) => UserChannelfollowBloc()),
        BlocProvider(create: (context) => NewsTopicBloc()),
        BlocProvider(create: (context) => GetUserProfileBloc()),
        BlocProvider(create: (context) => DeleteCommentBloc()),
        BlocProvider(create: (context) => EditCommentBloc()),
        BlocProvider(create: (context) => RecommendationAllBloc()),
        BlocProvider(create: (context) => ViewCountBloc()),
        BlocProvider(create: (context) => LocationBloc()),
        BlocProvider(create: (context) => DeleteUserBloc()),
        BlocProvider(create: (context) => WeatherBloc(repository: WeatherRepository())),
        BlocProvider(create: (context) => NotificationBloc()),
        BlocProvider(create: (context) => CommentCountBloc()),
        BlocProvider(create: (context) => ReportCommentBloc()),
        BlocProvider(create: (context) => DeviceFCMBloc()),
        BlocProvider(create: (context) => FollowedChannelsPostBloc()),
        BlocProvider(create: (context) => ChannelsPreferenceBloc()),
        BlocProvider(create: (context) => NotificationReadBloc()),
        BlocProvider(create: (context) => EmojiReactUserBloc()),
        BlocProvider(create: (context) => EmojiPostBloc()),
        BlocProvider(create: (context) => GetReactUserDataBloc()),
        BlocProvider(create: (context) => TotalReactionCountBloc()),
        BlocProvider(create: (context) => StoriesBloc()),
        BlocProvider(create: (context) => StoriesTopicsBloc()),
        BlocProvider(create: (context) => StoriesAllBloc()),
        BlocProvider(create: (context) => FullScreenBloc()),
        BlocProvider(create: (context) => ContactUsBloc()),
        BlocProvider(create: (context) => MultiLangBloc()),
        BlocProvider(create: (context) => MultiNewsPostBloc()),
        BlocProvider(create: (context) => FontSizeBloc()),
        BlocProvider(create: (context) => MembershipBloc()),
        BlocProvider(create: (context) => GenerateStripeLinkBloc()),
        BlocProvider(create: (context) => TransactionBloc()),
        BlocProvider(create: (context) => PaymentSettingsBloc()),
        BlocProvider(create: (context) => GenerateSignatureBloc()),
        BlocProvider(create: (context) => VerifyPaymentBloc()),
        BlocProvider(create: (context) => SubscriptionCountBloc()),
        BlocProvider(create: (context) => VideoNewsBloc()),
        BlocProvider(create: (context) => ChatBotBloc(OpenAIService())),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (context, themeState) {
            return BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, languageState) {
                return MaterialApp.router(
                  key: navigatorKey,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  locale: languageState.locale,
                  supportedLocales: supportedLocales,
                  debugShowCheckedModeBanner: false,
                  routerConfig: router,
                  theme: lightMode,
                  darkTheme: darkMode,
                  themeMode: themeState,
                  // builder: (context, child) {
                  //   return Stack(
                  //     children: [
                  //       child!,
                  //       Positioned(
                  //         bottom: 16,
                  //         right: 16,
                  //         child: ChatBotFloatButton(),
                  //       ),
                  //     ],
                  //   );
                  // },
                );
              },
            );
          },
        )

      )
    );
  }
}
