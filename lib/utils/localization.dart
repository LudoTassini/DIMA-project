import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations? getAppLocalizations(BuildContext context){
  return AppLocalizations.of(context);
}

Iterable<LocalizationsDelegate> getLocalizationDelegates(){
  return AppLocalizations.localizationsDelegates;
}

Iterable<Locale> getSupportedLocales(){
  return AppLocalizations.supportedLocales;
}