// lib/app_colors.dart

import 'package:flutter/material.dart';





class AppColors {
  final BuildContext? context;

  AppColors([this.context]);


  MaterialColor get primarySwatch => const MaterialColor(
    0xFF0F385A,
    <int, Color>{
      50: Color(0xFFE6EBEF),
      100: Color(0xFFC0CDD9),
      200: Color(0xFF97ABBF),
      300: Color(0xFF6D89A5), // 👈 This is storiesTitle
      400: Color(0xFF4D6F91),
      500: Color(0xFF0F385A),
      600: Color(0xFF0D3252),
      700: Color(0xFF0A2B48),
      800: Color(0xFF08243F),
      900: Color(0xFF04172E),
    },
  );

  Color get primaryColor => primarySwatch;
  Color get storiesTitle => primarySwatch[300]!;

  bool get isDark => context != null && Theme.of(context!).brightness == Brightness.dark;




  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color grayishWhiteColor = Color(0xFFF7FAFC);


  static const Color darkPrimaryColor = Color(0xFF0D1117);
  static const Color darkScondryColor = Color(0xFF161B22);


  static const Color primaryShimmerColor = Color(0xFFE0E0E0);
  static const Color secondryShimmerColor = Color(0xFFCCCBCB);

  static const Color greyColor = Colors.grey;
  static const Color blueGrey = Colors.blueGrey;

  static const Color blueclr = Colors.blue;
  static const Color lightColor = Colors.white;


}

