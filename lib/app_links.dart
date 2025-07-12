import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';



class AppLinksDeepLink {
  AppLinksDeepLink._privateConstructor();
  static final AppLinksDeepLink instance = AppLinksDeepLink._privateConstructor();

  late final AppLinks appLinks = AppLinks();
  StreamSubscription? _linkSubscription;
  bool _isHandlingDeepLink = false;
  Uri? _lastProcessedLink;
  bool _initialLinkProcessed = false;

  Future<void> initDeepLinks(BuildContext context) async {
    try {
      final appLink = await appLinks.getInitialLink();
      if (appLink != null && context.mounted && !_initialLinkProcessed) {
        _initialLinkProcessed = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigateToDeepLink(appLink, context);
        });
      }

      // Listen to incoming deep links while app is running
      _linkSubscription = appLinks.uriLinkStream.listen(
            (uri) {
          if (context.mounted && uri != _lastProcessedLink) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              navigateToDeepLink(uri, context);
              _lastProcessedLink = null;
            });
          }
        },
        onError: (err) {
          debugPrint('Deep Link Error: $err');
        },
      );
    } catch (e) {
      debugPrint('Deep Link Initialization Error: $e');
    }
  }

  void navigateToDeepLink(Uri uri, BuildContext context) {
    // Prevent duplicate navigation
    if (_isHandlingDeepLink) return;
    _isHandlingDeepLink = true;
    _lastProcessedLink = uri;

    try {
      if (uri.scheme == 'newshunt') {
        if (uri.pathSegments.isNotEmpty) {
          final slug = uri.pathSegments.last;
          if (uri.path.startsWith('/posts')) {
            GoRouter.of(context).push('/detailpage/$slug');
          } else {
            GoRouter.of(context).push('/customNewsPage/$slug');
          }
        }
      }
    } catch (e) {
      debugPrint('Navigation Error: $e');
    } finally {
      _isHandlingDeepLink = false;
      _lastProcessedLink = null;
    }
  }

  void resetDeepLinkState() {
    _lastProcessedLink = null;
    _isHandlingDeepLink = false;
  }

  void dispose() {
    _linkSubscription?.cancel();
    resetDeepLinkState();
  }
}






