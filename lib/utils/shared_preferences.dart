import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

const String sharedLogged = "USER_IS_LOGGED";
const String sharedUserEmail = "USER";
const String sharedUserID = "USER_ID";
const String sharedPassword = "PASSWORD";
const String languageCode = "LANGUAGE_CODE";
const String appTheme = "APP_THEME";

Future<Locale?> readLanguageCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? locale = prefs.getString(languageCode);
  return locale != null ? Locale(locale) : null;
}

Future<String?> readAppTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? theme = prefs.getString(appTheme);
  return theme;
}

Future<void> saveLanguageCode({required String newLanguageCode}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(languageCode, newLanguageCode);
}

Future<void> saveAppTheme({required String newTheme}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(appTheme, newTheme);
}

Future<String> getUserIdFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getString(sharedUserID) == null){
    throw Exception();
  }
  else {
    return prefs.getString(sharedUserID)!;
  }
}

Future<void> addUserSharedPreferences({required String id, required String email, required String password}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(sharedLogged, true);
  await prefs.setString(sharedUserEmail, email);
  await prefs.setString(sharedUserID, id);
  await prefs.setString(sharedPassword, password);
}

Future<void> deleteSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(sharedLogged);
  await prefs.remove(sharedUserEmail);
  await prefs.remove(sharedUserID);
  await prefs.remove(sharedPassword);
  await prefs.remove(languageCode);
}