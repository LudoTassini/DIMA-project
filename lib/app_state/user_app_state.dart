import 'package:flutter/material.dart';

import '../model/bloqo_user.dart';

class UserAppState with ChangeNotifier{

  BloqoUser? _user;

  BloqoUser? get() {
    return _user;
  }

  void set(BloqoUser user){
    _user = user;
  }

}