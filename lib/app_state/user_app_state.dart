import 'package:flutter/material.dart';

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
}
