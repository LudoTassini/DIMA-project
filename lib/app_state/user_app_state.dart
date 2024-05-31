import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bloqo_user.dart';

class UserAppState with ChangeNotifier{

  BloqoUser? _user;

  BloqoUser? get() {
    return _user;
  }

  void set(BloqoUser user){
    _user = user;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void updateFullName(String newFullName){
    if (_user != null) {
      _user!.fullName = newFullName;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void updateIsFullNameVisible(bool newFullNameVisible){
    if (_user != null) {
      _user!.isFullNameVisible = newFullNameVisible;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void updatePictureUrl(String newUrl){
    if (_user != null) {
      _user!.pictureUrl = newUrl;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}

void saveUserToAppState({required BuildContext context, required BloqoUser user}){
  Provider.of<UserAppState>(context, listen: false).set(user);
}