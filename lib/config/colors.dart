// lib/app_colors.dart

import 'package:flutter/material.dart';





class AppColors {
  final BuildContext? context;

  AppColors([this.context]);


  MaterialColor get primaryColor => Colors.blue;
  Color get storiesTitle => primaryColor[300]!;

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

