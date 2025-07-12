import 'package:flutter/material.dart';
import 'package:newsapp/config/constants.dart';

import '../../l10n/app_localizations.dart';

import '../../config/helper/helper_functions.dart';

class MaintenanceModeScreen extends StatelessWidget {
  const MaintenanceModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:EdgeInsets.symmetric(horizontal: MediaQueryHelper.screenWidth(context) * 0.05),
              child: Image.asset(
                'assets/img/underMaintenance.png',
                height: MediaQueryHelper.screenHeight(context) * 0.5,
                width: MediaQueryHelper.screenWidth(context),
                fit: BoxFit.contain,
              ),
            ),
            Text(AppLocalizations.of(context)!.underMaintenance,style: TextStyle(fontSize: 22,fontFamily: fontType),),
            Text(AppLocalizations.of(context)!.sorryTheappisundermaintenance,style: TextStyle(fontSize: 16,color: Colors.grey.shade500,fontFamily: fontType),),
          ],),
    );
  }
}
