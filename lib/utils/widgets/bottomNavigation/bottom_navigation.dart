// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:newsapp/config/colors.dart';
import '../../../l10n/app_localizations.dart';
import 'package:newsapp/config/constants.dart';
import 'package:remixicon/remixicon.dart';

import '../../../config/helper/helper_functions.dart';



class BottomNavigationScaffold extends StatelessWidget {
  final Widget child;

  const BottomNavigationScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          final shouldPop = await _handleBackButton(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: AppColors.greyColor,
                width: MediaQueryHelper.screenWidth(context) * 0.00017,
              ),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          child: GNav(
            activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            color: AppColors.greyColor,
            gap: MediaQuery.of(context).size.width * 0.01,
            textStyle: TextStyle(
              fontFamily: fontType,
            ),
            iconSize: 25,
            padding: EdgeInsets.only(
              left: MediaQueryHelper.screenWidth(context) * 0.04,
              right: MediaQueryHelper.screenWidth(context) * 0.04,
              top: MediaQueryHelper.screenHeight(context) * 0.02,
              bottom: Platform.isIOS
                  ? MediaQueryHelper.screenHeight(context) * 0.025
                  : MediaQuery.of(context).padding.bottom + 10,
            ),
            tabs: [
              GButton(
                icon: _calculateSelectedIndex(context) == 0
                    ? HeroiconsSolid.home
                    : HeroiconsOutline.home,
                text: AppLocalizations.of(context)!.homeTitle,
              ),
              GButton(
                icon: _calculateSelectedIndex(context) == 1
                    ? Remix.compass_discover_fill
                    : Remix.compass_discover_line,
                text: AppLocalizations.of(context)!.discoverTitle,
              ),
              GButton(
                icon: _calculateSelectedIndex(context) == 2
                    ? HeroiconsSolid.videoCamera
                    : HeroiconsOutline.videoCamera,
                text: AppLocalizations.of(context)!.video,
              ),
              GButton(
                icon: _calculateSelectedIndex(context) == 3
                    ? HeroiconsSolid.bookmark
                    : HeroiconsOutline.bookmark,
                text: AppLocalizations.of(context)!.bookmarkTitle,
              ),
              GButton(
                icon: _calculateSelectedIndex(context) == 4
                    ? HeroiconsSolid.user
                    : HeroiconsOutline.user,
                text: AppLocalizations.of(context)!.profile,
              ),
            ],
            selectedIndex: _calculateSelectedIndex(context),
            onTabChange: (index) => _onItemTapped(index, context),
          ),
        ),
      ),
    );
  }

  // Handle back button logic
  Future<bool> _handleBackButton(BuildContext context) async {
    final String currentLocation = GoRouterState.of(context).uri.toString();

    // Check if we're on a main tab page (home pages)
    final List<String> mainTabPages = [
      '/home',
      '/discover',
      '/videoNews',
      '/bookmarks',
      '/profile'
    ];

    if (mainTabPages.contains(currentLocation)) {
      // If on home page, allow app to exit
      if (currentLocation == '/home') {
        return true; // Allow back (exit app)
      } else {
        // If on other main tab pages, go to home
        context.go('/home');
        return false; // Prevent default back behavior
      }
    } else {
      // If on nested page, go back to previous page
      context.pop();
      return false; // Prevent default back behavior
    }
  }

  // Calculate selected index based on current location
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/discover')) return 1;
    if (location.startsWith('/videoNews')) return 2;
    if (location.startsWith('/bookmarks')) return 3;
    if (location.startsWith('/profile')) return 4;

    return 0;
  }

  // Handle bottom navigation tap
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/discover');
        break;
      case 2:
        context.go('/videoNews');
        break;
      case 3:
        context.go('/bookmarks');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}














