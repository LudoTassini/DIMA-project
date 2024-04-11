import 'package:flutter/material.dart';

import 'app_colors.dart';

class BloqoTheme{

  static ThemeData get(){
    const TextTheme textTheme = TextTheme(
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
    );
    FilledButtonThemeData filledButtonThemeData = FilledButtonThemeData(
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
    );
    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme,
      filledButtonTheme: filledButtonThemeData,
      /*colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.fuchsiaRose,
        onPrimary: AppColors.seasalt,
        secondary: AppColors.darkFuchsia,
        onSecondary: AppColors.seasalt,
        error: AppColors.error,
        onError: AppColors.seasalt,
        background: AppColors.seasalt,
        onBackground: AppColors.primaryText,
        surface: AppColors.seasalt,
        onSurface: AppColors.primaryText,
      ),*/
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.seasalt,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        headerHelpStyle: const TextStyle(
          fontSize: 18
        ),
        dayStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
        ),
        weekdayStyle: const TextStyle(
          fontSize: 22,
          color: AppColors.darkFuchsia,
        ),
        headerBackgroundColor: AppColors.russianViolet,
        headerForegroundColor: AppColors.seasalt,
        dayBackgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.russianViolet;
            }
            else {
              return null;
            }
          }
        ),
        dayForegroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.seasalt;
            }
            else {
              return AppColors.russianViolet;
            }
          }
        ),
        todayBorder: BorderSide.none,
        dividerColor: AppColors.russianViolet,
        cancelButtonStyle: filledButtonThemeData.style?.copyWith(
          textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
          foregroundColor: MaterialStateProperty.resolveWith((_) => AppColors.seasalt),
          backgroundColor: MaterialStateProperty.resolveWith((_) => AppColors.error),
          fixedSize: MaterialStateProperty.resolveWith((_) => const Size(double.infinity, double.infinity)),
          padding: MaterialStateProperty.resolveWith((_) => const EdgeInsetsDirectional.fromSTEB(15, 8, 15, 8)),
        ),
        confirmButtonStyle: filledButtonThemeData.style?.copyWith(
          textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
          )),
          foregroundColor: MaterialStateProperty.resolveWith((_) => AppColors.seasalt),
          backgroundColor: MaterialStateProperty.resolveWith((_) => AppColors.russianViolet),
          fixedSize: MaterialStateProperty.resolveWith((_) => const Size(double.infinity, double.infinity)),
          padding: MaterialStateProperty.resolveWith((_) => const EdgeInsetsDirectional.fromSTEB(15, 8, 15, 8)),
        ),
      ),
    );
  }

}