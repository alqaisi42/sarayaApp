import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';



import 'package:app_settings/app_settings.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newsapp/routes/app_routes.dart';


import 'package:path_provider/path_provider.dart';

import 'config/hiveLocalStorage/hive_storage.dart';








class GlobalKeys {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  void initialize() {
    if (_isInitialized) return;
    _isInitialized = true;
    notificationPermission();
    _initLocalNotification();
    firebaseInit();
    onTokenRefresh();
  }

  Future<void> _initLocalNotification() async {
    final androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosInitializationSettings = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (response) {
          if (response.payload != null) {
            try {
              final payloadMap = json.decode(response.payload!) as Map<String, dynamic>;
              final slug = payloadMap['slug'];
              log("Payload data key: $slug");
              _handleNotificationTap(slug);
            } catch (e) {
              log('Error parsing notification payload: $e');
              log('Payload received: $response');
            }
          }
        }
    );
  }

  void _handleNotificationTap(String? slug) {
    if (slug != null && slug.contains('-') && slug.isNotEmpty) {
      router.push('/detailpage/$slug');
    } else {
      router.go('/home');
    }
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) async {
      log('Got foreground message:');
      log('Title: ${message.notification?.title}');
      log('Body: ${message.notification?.body}');
      log('Data Slug: ${message.data}');

      final payload = {
        "title": message.notification?.title ?? message.data['title'],
        "body": message.notification?.body ?? message.data['body'],
        "slug": message.data['slug'],
        "type": message.data['type'],
        "notification_id": message.data['notification_id'],
        "image": message.data['image'],
        "channelLogo": message.data['channel_logo'],
        "channelName": message.data['channel_name']
      };

      final jsonPayload = jsonEncode(payload);

      if (message.notification != null) {
        await showNotification(message, jsonPayload);
      } else if (message.data.isNotEmpty) {
        await showNotification(RemoteMessage(
          data: payload,
          notification: RemoteNotification(
            title: payload['title'],
            body: payload['body'],
          ),
        ), jsonPayload);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message, String jsonPayload) async {
    try {
      const String channelId = 'high_importance_channel';
      const String channelName = 'High Importance Notifications';

      final AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        playSound: true,
        showBadge: true,
        enableVibration: true,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      String? imageUrl = message.data['image'];
      String? channelImageUrl = message.data['channel_logo'];
      String? publisherName = message.data['channel_name'];

      // iOS notification details
      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      AndroidNotificationDetails androidDetails;

      // Handle image notifications with proper error handling
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final bigPicture = await downloadAndSaveImage(imageUrl, 'notification_img.jpg')
              .timeout(Duration(seconds: 10)); // Add timeout for foreground

          String channelLogo = '';
          if (channelImageUrl != null && channelImageUrl.isNotEmpty) {
            channelLogo = await downloadAndSaveImage(channelImageUrl, 'channel_logo.jpg')
                .timeout(Duration(seconds: 5));
          }

          if (bigPicture.isNotEmpty) {
            // Successfully downloaded image
            final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicture),
              largeIcon: channelLogo.isNotEmpty ? FilePathAndroidBitmap(channelLogo) : null,
              contentTitle: publisherName,
              summaryText: message.notification?.body,
              htmlFormatContent: true,
              htmlFormatContentTitle: true,
            );

            androidDetails = AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              priority: Priority.high,
              ticker: 'ticker',
              icon: '@mipmap/ic_launcher',
              styleInformation: bigPictureStyleInformation,
            );
          } else {
            // Image download failed, use text notification
            androidDetails = _createTextNotification(channel, publisherName, message.notification?.body);
          }
        } catch (e) {
          log('Error downloading image in foreground: $e');
          // Fallback to text notification
          androidDetails = _createTextNotification(channel, publisherName, message.notification?.body);
        }
      } else {
        // No image, create text notification
        androidDetails = _createTextNotification(channel, publisherName, message.notification?.body);
      }

      final NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        details,
        payload: jsonPayload,
      );
    } catch (e) {
      log('Error showing notification: $e');
    }
  }

  // Helper method to create consistent text notifications
  AndroidNotificationDetails _createTextNotification(AndroidNotificationChannel channel, String? publisherName, String? body) {
    return AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      styleInformation: publisherName != null && publisherName.isNotEmpty
          ? BigTextStyleInformation(
        body ?? '',
        contentTitle: publisherName,
        summaryText: body,
      )
          : null,
    );
  }

  Future<String> downloadAndSaveImage(String url, String fileName) async {
    try {
      // Add validation for URL
      if (url.isEmpty || !url.startsWith('http')) {
        log('Invalid URL provided: $url');
        return '';
      }

      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';

      Dio dio = Dio();

      // Add timeout and better error handling
      dio.options.connectTimeout = Duration(seconds: 10);
      dio.options.receiveTimeout = Duration(seconds: 15);

      await dio.download(url, filePath);

      // Verify file exists and has content
      final file = File(filePath);
      if (await file.exists() && await file.length() > 0) {
        log('Image downloaded successfully: $fileName');
        return filePath;
      } else {
        log('Downloaded file is empty or doesn\'t exist: $fileName');
        return '';
      }
    } catch (e) {
      log('Error downloading image $fileName: $e');
      return '';
    }
  }

  // Rest of your methods remain the same...
  Future<void> notificationPermission() async {
    final HiveStorage hiveStorage = HiveStorage();
    final String notificationBoxName = 'notificationBox';
    final String hasAskedForPermissionKey = 'has_asked_for_notification_permission';

    final box = await hiveStorage.openBox(notificationBoxName);
    final bool hasAskedBefore = box.get(hasAskedForPermissionKey, defaultValue: false);

    if (hasAskedBefore) {
      log("Already asked for notification permission before - not asking again");
      return;
    }

    await box.put(hasAskedForPermissionKey, true);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        criticalAlert: true,
        provisional: true,
        carPlay: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("Notification permissions granted for Android");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log("Notification permissions granted for iOS");
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      log("Notification permissions denied");
    }
  }

  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        int retryCount = 0;
        const maxRetries = 5;

        while (apnsToken == null && retryCount < maxRetries) {
          log('APNs token not available yet, waiting... (attempt ${retryCount + 1}/$maxRetries)');
          await Future.delayed(Duration(seconds: 1));
          apnsToken = await _firebaseMessaging.getAPNSToken();
          retryCount++;
        }

        if (apnsToken != null) {
          log('APNs Token obtained: ${apnsToken.substring(0, 20)}...');
        } else {
          log('Warning: APNs token still not available after $maxRetries attempts');
        }
      }

      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        log('FCM Token obtained successfully: ${fcmToken.substring(0, 20)}...');
        return fcmToken;
      } else {
        log('FCM token is null');
        return null;
      }
    } catch (e) {
      log("Error fetching FCM token: $e");

      if (e.toString().contains('apns-token-not-set')) {
        log('APNs token error detected. This usually resolves after app permissions are properly granted.');
        await Future.delayed(Duration(seconds: 2));
        try {
          return await _firebaseMessaging.getToken();
        } catch (retryError) {
          log('Retry also failed: $retryError');
        }
      }
      return null;
    }
  }

  void onTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      log('Token Refreshed: ${token.substring(0, 20)}...');
    });
  }

  Future<bool> isAPNSTokenAvailable() async {
    if (!Platform.isIOS) return true;

    try {
      final apnsToken = await _firebaseMessaging.getAPNSToken();
      return apnsToken != null;
    } catch (e) {
      log('Error checking APNs token: $e');
      return false;
    }
  }

  Future<String?> getTokenSafely() async {
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        log('Notification permissions not granted');
        return null;
      }

      if (Platform.isIOS) {
        await Future.delayed(Duration(seconds: 1));
      }

      return await getToken();
    } catch (e) {
      log('Error in getTokenSafely: $e');
      return null;
    }
  }
}

//
// class FirebaseMessagingService {
//   static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
//   factory FirebaseMessagingService() => _instance;
//   FirebaseMessagingService._internal();
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   bool _isInitialized = false;
//
//   void initialize() {
//     if (_isInitialized) return;
//     _isInitialized = true;
//     notificationPermission();
//     _initLocalNotification();
//     firebaseInit();
//     onTokenRefresh();
//   }
//
//   Future<void> _initLocalNotification() async {
//     final androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final iosInitializationSettings = DarwinInitializationSettings();
//
//     final initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iosInitializationSettings,
//     );
//
//     await _flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse: (response) {
//           if (response.payload != null) {
//             try {
//               final payloadMap = json.decode(response.payload!) as Map<String, dynamic>;
//               final slug = payloadMap['slug'];
//               log("Payload data key: $slug");
//               _handleNotificationTap(slug);
//             } catch (e) {
//               log('Error parsing notification payload: $e');
//               log('Payload received: $response');
//             }
//           }
//         }
//     );
//   }
//
//   void _handleNotificationTap(String? slug) {
//     if (slug != null && slug.contains('-')) {
//       router.push('/detailpage/$slug');
//     } else {
//       router.go('/home');
//     }
//   }
//
//   void firebaseInit() {
//     FirebaseMessaging.onMessage.listen((message) async {
//       log('Got foreground message:');
//       log('Title: ${message.notification?.title}');
//       log('Body: ${message.notification?.body}');
//       log('Data Slug: ${message.data}');
//
//       final payload = {
//         "title": message.notification?.title ?? message.data['title'],
//         "body": message.notification?.body ?? message.data['body'],
//         "slug": message.data['slug'],
//         "type": message.data['type'],
//         "notification_id": message.data['notification_id'],
//         "image": message.data['image'],
//         "channelLogo": message.data['channel_logo'],
//         "channelName": message.data['channel_name']
//       };
//
//       final jsonPayload = jsonEncode(payload);
//
//       if (message.notification != null) {
//         await showNotification(message, jsonPayload);
//       } else if (message.data.isNotEmpty) {
//         await showNotification(RemoteMessage(
//           data: payload,
//           notification: RemoteNotification(
//             title: payload['title'],
//             body: payload['body'],
//           ),
//         ), jsonPayload);
//       }
//     });
//   }
//
//   Future<void> showNotification(RemoteMessage message, String jsonPayload) async {
//     try {
//       const String channelId = 'high_importance_channel';
//       const String channelName = 'High Importance Notifications';
//
//       final AndroidNotificationChannel channel = AndroidNotificationChannel(
//         channelId,
//         channelName,
//         description: 'This channel is used for important notifications.',
//         importance: Importance.max,
//         playSound: true,
//         showBadge: true,
//         enableVibration: true,
//       );
//
//       await _flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//
//       String? imageUrl = message.data['image'];
//       String? channelImageUrl = message.data['channelLogo'];
//       String? publiserName = message.data['channelName'];
//
//       AndroidNotificationDetails androidDetails;
//
//       final bigPicture = await downloadAndSaveImage(imageUrl.toString(), 'notification_img.jpg');
//       final channelLogo = await downloadAndSaveImage(channelImageUrl.toString(), 'channel_logo.jpg');
//
//       final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
//         FilePathAndroidBitmap(imageUrl != null && imageUrl.isNotEmpty ? bigPicture : ""),
//         largeIcon: FilePathAndroidBitmap(channelLogo),
//         contentTitle: publiserName,
//         summaryText: message.notification?.body,
//       );
//
//       androidDetails = AndroidNotificationDetails(
//         channel.id,
//         channel.name,
//         channelDescription: channel.description,
//         importance: Importance.high,
//         priority: Priority.high,
//         ticker: 'ticker',
//         icon: '@mipmap/ic_launcher',
//         styleInformation: bigPictureStyleInformation,
//       );
//
//       final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         interruptionLevel: InterruptionLevel.active,
//       );
//
//       final NotificationDetails details = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );
//
//       await _flutterLocalNotificationsPlugin.show(
//         message.hashCode,
//         message.notification!.title,
//         message.notification!.body,
//         details,
//         payload: jsonPayload,
//       );
//     } catch (e) {
//       log('Error showing notification: $e');
//     }
//   }
//
//   Future<String> downloadAndSaveImage(String url, String fileName) async {
//     try {
//       final Directory directory = await getApplicationDocumentsDirectory();
//       final String filePath = '${directory.path}/$fileName';
//
//       Dio dio = Dio();
//       await dio.download(url, filePath);
//
//       return filePath;
//     } catch (e) {
//       return '';
//     }
//   }
//
//   Future<void> notificationPermission() async {
//     final HiveStorage hiveStorage = HiveStorage();
//     final String notificationBoxName = 'notificationBox';
//     final String hasAskedForPermissionKey = 'has_asked_for_notification_permission';
//
//     // Check if we've already asked before
//     final box = await hiveStorage.openBox(notificationBoxName);
//     final bool hasAskedBefore = box.get(hasAskedForPermissionKey, defaultValue: false);
//
//     // If we've already asked before, don't proceed
//     if (hasAskedBefore) {
//       log("Already asked for notification permission before - not asking again");
//       return;
//     }
//
//     // Mark that we've asked
//     await box.put(hasAskedForPermissionKey, true);
//
//     // Original code below this point
//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         announcement: true,
//         criticalAlert: true,
//         provisional: true,
//         carPlay: true);
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       log("Notification permissions granted for Android");
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       log("Notification permissions granted for iOS");
//     } else {
//       AppSettings.openAppSettings(type: AppSettingsType.notification);
//       log("Notification permissions denied");
//     }
//   }
//
//   // Updated getToken method with APNs token handling
//   Future<String?> getToken() async {
//     try {
//       // For iOS, ensure APNs token is available first
//       if (Platform.isIOS) {
//         String? apnsToken = await _firebaseMessaging.getAPNSToken();
//         int retryCount = 0;
//         const maxRetries = 5;
//
//         // Wait for APNs token with retry logic
//         while (apnsToken == null && retryCount < maxRetries) {
//           log('APNs token not available yet, waiting... (attempt ${retryCount + 1}/$maxRetries)');
//           await Future.delayed(Duration(seconds: 1));
//           apnsToken = await _firebaseMessaging.getAPNSToken();
//           retryCount++;
//         }
//
//         if (apnsToken != null) {
//           log('APNs Token obtained: ${apnsToken.substring(0, 20)}...');
//         } else {
//           log('Warning: APNs token still not available after $maxRetries attempts');
//           // Continue anyway, sometimes FCM token can still be obtained
//         }
//       }
//
//       // Get FCM token
//       final fcmToken = await _firebaseMessaging.getToken();
//       if (fcmToken != null) {
//         log('FCM Token obtained successfully: ${fcmToken.substring(0, 20)}...');
//         return fcmToken;
//       } else {
//         log('FCM token is null');
//         return null;
//       }
//     } catch (e) {
//       log("Error fetching FCM token: $e");
//
//       // If it's the specific APNs error, provide more context
//       if (e.toString().contains('apns-token-not-set')) {
//         log('APNs token error detected. This usually resolves after app permissions are properly granted.');
//         // Optionally, you could retry after a delay
//         await Future.delayed(Duration(seconds: 2));
//         try {
//           return await _firebaseMessaging.getToken();
//         } catch (retryError) {
//           log('Retry also failed: $retryError');
//         }
//       }
//       return null;
//     }
//   }
//
//   void onTokenRefresh() {
//     _firebaseMessaging.onTokenRefresh.listen((String token) {
//       log('Token Refreshed: ${token.substring(0, 20)}...');
//       // You can save this new token to your backend here
//     });
//   }
//
//   // Additional helper method to check if APNs token is available
//   Future<bool> isAPNSTokenAvailable() async {
//     if (!Platform.isIOS) return true; // Not needed on Android
//
//     try {
//       final apnsToken = await _firebaseMessaging.getAPNSToken();
//       return apnsToken != null;
//     } catch (e) {
//       log('Error checking APNs token: $e');
//       return false;
//     }
//   }
//
//   // Method to get token with better error handling
//   Future<String?> getTokenSafely() async {
//     try {
//       // First check if permissions are granted
//       final settings = await _firebaseMessaging.getNotificationSettings();
//       if (settings.authorizationStatus != AuthorizationStatus.authorized &&
//           settings.authorizationStatus != AuthorizationStatus.provisional) {
//         log('Notification permissions not granted');
//         return null;
//       }
//
//       // For iOS, wait a bit longer for APNs token
//       if (Platform.isIOS) {
//         await Future.delayed(Duration(seconds: 1));
//       }
//
//       return await getToken();
//     } catch (e) {
//       log('Error in getTokenSafely: $e');
//       return null;
//     }
//   }
// }









