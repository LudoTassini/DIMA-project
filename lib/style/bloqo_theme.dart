import 'package:flutter/material.dart';

import 'app_colors.dart';

class BloqoTheme{

  static ThemeData get(){
    return ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: 'Readex Pro'
          ),
          displayMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: 'Readex Pro'
          ),
          displaySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontFamily: 'Readex Pro'
          ),
          bodyLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.normal,
            fontFamily: 'Readex Pro'
          ),
          bodyMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: 'Readex Pro'
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontFamily: 'Readex Pro'
          ),
          labelMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Readex Pro',
            color: AppColors.russianViolet
          ),
        ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Readex Pro',
              color: AppColors.seasalt
          ),
          elevation: 3,
          padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          fixedSize: const Size(double.infinity, 50)
        )
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryText,
        onPrimary: AppColors.seasalt,
        secondary: AppColors.secondaryText,
        onSecondary: AppColors.seasalt,
        error: AppColors.error,
        onError: AppColors.seasalt,
        background: AppColors.seasalt,
        onBackground: AppColors.primaryText,
        surface: AppColors.seasalt,
        onSurface: AppColors.primaryText,
      )
    );
  }

}