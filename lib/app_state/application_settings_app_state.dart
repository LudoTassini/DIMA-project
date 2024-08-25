import 'package:bloqo/utils/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/themes/bloqo_theme.dart';
import '../style/themes/purple_orchid_theme.dart';

class ApplicationSettingsAppState with ChangeNotifier{

  bool _fromTest = false;

  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;
  late FirebaseStorage _storage;

  Locale _locale = const Locale("en");
  BloqoAppTheme _theme = PurpleOrchidTheme();

  Locale _getLocale() => _locale;

  BloqoAppTheme _getTheme() => _theme;

  bool _getFromTest() => _fromTest;

  FirebaseFirestore _getFirestore() => _firestore;

  FirebaseAuth _getAuth() => _auth;

  FirebaseStorage _getStorage() => _storage;

  Future<void> _setLocale(Locale locale) async {
    _locale = locale;
    if(!_fromTest) {
      await saveLanguageCode(newLanguageCode: locale.languageCode);
    }
    notifyListeners();
  }

  Future<void> _setTheme(BloqoAppTheme theme) async {
    _theme = theme;
    if(!_fromTest) {
      await saveAppTheme(newTheme: theme.type.toString());
    }
    notifyListeners();
  }

  void _setTestMode() {
    _fromTest = true;
  }

  void _setFirestore(FirebaseFirestore firestore){
    _firestore = firestore;
  }

  void _setAuth(FirebaseAuth auth){
    _auth = auth;
  }

  void _setStorage(FirebaseStorage storage){
    _storage = storage;
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

bool getFromTestFromAppState({required BuildContext context}){
  return Provider.of<ApplicationSettingsAppState>(context, listen: false)._getFromTest();
}

void updateFromTestInAppState({required BuildContext context}){
  Provider.of<ApplicationSettingsAppState>(context, listen: false)._setTestMode();
}

FirebaseFirestore getFirestoreFromAppState({required BuildContext context}){
  return Provider.of<ApplicationSettingsAppState>(context, listen: false)._getFirestore();
}

void updateFirestoreInAppState({required BuildContext context, required FirebaseFirestore firestore}){
  Provider.of<ApplicationSettingsAppState>(context, listen: false)._setFirestore(firestore);
}

FirebaseAuth getAuthFromAppState({required BuildContext context}){
  return Provider.of<ApplicationSettingsAppState>(context, listen: false)._getAuth();
}

void updateAuthInAppState({required BuildContext context, required FirebaseAuth auth}){
  Provider.of<ApplicationSettingsAppState>(context, listen: false)._setAuth(auth);
}

FirebaseStorage getStorageFromAppState({required BuildContext context}){
  return Provider.of<ApplicationSettingsAppState>(context, listen: false)._getStorage();
}

void updateStorageInAppState({required BuildContext context, required FirebaseStorage storage}){
  Provider.of<ApplicationSettingsAppState>(context, listen: false)._setStorage(storage);
}