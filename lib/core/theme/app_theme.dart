import 'package:crypto_app/core/theme/app_color.dart';
import 'package:crypto_app/core/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.primary,
    fontFamily: AppTextTheme.fontFamily,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    ),

    textTheme: AppTextTheme.darkTextTheme,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      centerTitle: false,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
    ),
  );
}
