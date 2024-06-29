import 'package:flutter/material.dart';

import 'bloqo_colors.dart';

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
      bodyLarge: TextStyle( // date picker input style
          fontSize: 20,
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
          color: BloqoColors.russianViolet
      ),
      titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Readex Pro',
      ),
    );
    FilledButtonThemeData filledButtonThemeData = FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Readex Pro',
            color: BloqoColors.seasalt
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
      datePickerTheme: DatePickerThemeData(
        backgroundColor: BloqoColors.seasalt,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        headerHelpStyle: const TextStyle(
          fontSize: 18
        ),
        headerHeadlineStyle: const TextStyle(
            fontSize: 30
        ),
        dayStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
        ),
        weekdayStyle: const TextStyle(
          fontSize: 22,
          color: BloqoColors.darkFuchsia,
        ),
        yearStyle: const TextStyle(
          fontSize: 22,
        ),
        headerBackgroundColor: BloqoColors.russianViolet,
        headerForegroundColor: BloqoColors.seasalt,
        dayBackgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return BloqoColors.russianViolet;
            }
            else {
              return null;
            }
          }
        ),
        dayForegroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return BloqoColors.seasalt;
            }
            else {
              return BloqoColors.russianViolet;
            }
          }
        ),
        yearBackgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return BloqoColors.russianViolet;
              }
              else {
                return null;
              }
            }
        ),
        yearForegroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return BloqoColors.seasalt;
              }
              else {
                return BloqoColors.russianViolet;
              }
            }
        ),
        todayBorder: BorderSide.none,
        dividerColor: BloqoColors.russianViolet,
        cancelButtonStyle: filledButtonThemeData.style?.copyWith(
          textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
          foregroundColor: MaterialStateProperty.resolveWith((_) => BloqoColors.seasalt),
          backgroundColor: MaterialStateProperty.resolveWith((_) => BloqoColors.error),
          fixedSize: MaterialStateProperty.resolveWith((_) => const Size(double.infinity, double.infinity)),
          padding: MaterialStateProperty.resolveWith((_) => const EdgeInsetsDirectional.fromSTEB(15, 8, 15, 8)),
        ),
        confirmButtonStyle: filledButtonThemeData.style?.copyWith(
          textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
          )),
          foregroundColor: MaterialStateProperty.resolveWith((_) => BloqoColors.seasalt),
          backgroundColor: MaterialStateProperty.resolveWith((_) => BloqoColors.russianViolet),
          fixedSize: MaterialStateProperty.resolveWith((_) => const Size(double.infinity, double.infinity)),
          padding: MaterialStateProperty.resolveWith((_) => const EdgeInsetsDirectional.fromSTEB(15, 8, 15, 8)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: BloqoColors.russianViolet,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: textTheme.labelMedium,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: textTheme.displaySmall?.copyWith(
          overflow: TextOverflow.ellipsis
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: BloqoColors.russianViolet,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: textTheme.labelMedium,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        menuStyle: MenuStyle(
          surfaceTintColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
        )
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) => states.contains(MaterialState.selected)
              ? const TextStyle(
              color: BloqoColors.russianViolet,
              fontWeight: FontWeight.w500,
              fontSize: 15
          )
              : const TextStyle(
              color: BloqoColors.seasalt,
              fontWeight: FontWeight.w500,
              fontSize: 15
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: textTheme.displayMedium
      ),
      tabBarTheme: TabBarTheme(
        labelColor: BloqoColors.seasalt,
        unselectedLabelColor: BloqoColors.seasalt,
        labelStyle: textTheme.displayMedium!.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
        unselectedLabelStyle: textTheme.displayMedium!.copyWith(
          fontSize: 18
        ),
        dividerColor: Colors.transparent,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: BloqoColors.darkFuchsia,
            width: 3.0
          ),
        )
      )
    );
  }

}