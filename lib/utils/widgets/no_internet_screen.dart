import 'package:flutter/material.dart';
import 'package:newsapp/config/constants.dart';

import '../../l10n/app_localizations.dart';

import '../../config/helper/helper_functions.dart';

class NoInternetScreen extends StatelessWidget {

  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset(
                'assets/img/noInternetConnection.jpg',
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.02,),
            Text(AppLocalizations.of(context)!.noInternet,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontFamily: fontType),),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: MediaQueryHelper.screenWidth(context) * 0.02),
              child: Text(AppLocalizations.of(context)!.pleaseCheckYourMobileDataOrWifiConnection,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,fontFamily: fontType),),
            ),
          ],
        ),
      ),
    );
  }
}
