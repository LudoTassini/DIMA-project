import 'package:bloqo/utils/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationSettingsAppState with ChangeNotifier{

  Locale _locale = const Locale("en");

  Locale _getLocale() => _locale;

  Future<void> _setLocale(Locale locale) async {
    _locale = locale;
    await saveLanguageCode(newLanguageCode: locale.languageCode);
    notifyListeners();
  }

}

Locale getLanguageFromAppState({required BuildContext context}){
  return Provider.of<ApplicationSettingsAppState>(context, listen: false)._getLocale();
}

void updateLanguageInAppState({required BuildContext context, required String newLanguageCode}){
  Provider.of<ApplicationSettingsAppState>(context, listen: false)._setLocale(Locale(newLanguageCode));
}