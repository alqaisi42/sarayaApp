// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


import 'colors.dart';

//==================================================== White Theme Color

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: AppColors.whiteColor,
    primary: AppColors.grayishWhiteColor,
    secondary: AppColors.primaryShimmerColor,
    tertiary: AppColors.secondryShimmerColor,
  ),
  iconTheme: IconThemeData(color: Colors.black87),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.black87,
    ),
    bodySmall: TextStyle(
      color: Colors.grey.shade600,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black87,
    unselectedItemColor: Colors.grey,
    selectedLabelStyle: TextStyle(color: Colors.black87),
    unselectedLabelStyle: TextStyle(color: Colors.grey),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      // backgroundColor: AppColors.redColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.darkPrimaryColor,
    selectionColor: AppColors.lightColor.withValues(alpha: 0.3),
    selectionHandleColor: AppColors.blueclr,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.transparent,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade500),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.darkScondryColor),
    ),
  ),
);


//==================================================== Dark Theme Color

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: AppColors.darkPrimaryColor,
    primary: AppColors.darkScondryColor,
    secondary: AppColors.darkPrimaryColor,
    tertiary: AppColors.darkScondryColor,
  ),
  iconTheme: IconThemeData(color: Colors.white),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      color: Colors.grey.shade500,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey.shade700,
    selectedLabelStyle: TextStyle(color: Colors.white70),
    unselectedLabelStyle: TextStyle(color: Colors.grey),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      // backgroundColor: AppColors.redColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.whiteColor,           // Cursor color
    selectionColor: AppColors.lightColor.withValues(alpha:0.3),  // Background color of selected text
    selectionHandleColor: AppColors.blueclr,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.transparent,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade500),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.lightColor, width: 0.2),
    ),
  ),
);
