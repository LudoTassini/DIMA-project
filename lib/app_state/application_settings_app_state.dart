import 'package:bloqo/utils/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/bloqo_theme.dart';

class ApplicationSettingsAppState with ChangeNotifier{

  Locale _locale = const Locale("en");
  BloqoAppTheme _theme = LilacOrchidTheme();

  Locale _getLocale() => _locale;

  BloqoAppTheme _getTheme() => _theme;

  Future<void> _setLocale(Locale locale) async {
    _locale = locale;
    await saveLanguageCode(newLanguageCode: locale.languageCode);
    notifyListeners();
  }

  Future<void> _setTheme(BloqoAppTheme theme) async {
    _theme = theme;
    await saveAppTheme(newTheme: theme.type.toString());
    notifyListeners();
  }

}

Locale getLanguageFromAppState({required BuildContext context}){
  return Provider.of<ApplicationSettingsAppState>(context, listen: false)._getLocale();
}

void updateLanguageInAppState({required BuildContext context, required String newLanguageCode}){
  Provider.of<ApplicationSettingsAppState>(context, listen: false)._setLocale(Locale(newLanguageCode));
}

BloqoAppTheme getAppThemeFromAppState({required BuildContext context}){
  return Provider.of<ApplicationSettingsAppState>(context, listen: false)._getTheme();
}

void updateAppThemeInAppState({required BuildContext context, required BloqoAppTheme newTheme}){
  Provider.of<ApplicationSettingsAppState>(context, listen: false)._setTheme(newTheme);
}