import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bloqo_user_data.dart';

class UserAppState with ChangeNotifier{

  BloqoUserData? _user;

  BloqoUserData? _get() {
    return _user;
  }

  void _set(BloqoUserData user){
    _user = user;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _addFollowing(String newId){
    if(_user != null){
      _user!.following.add(newId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _removeFollowing(String oldId){
    if(_user != null){
      _user!.following.remove(oldId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updateFullName(String newFullName){
    if (_user != null) {
      _user!.fullName = newFullName;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updateIsFullNameVisible(bool newFullNameVisible){
    if (_user != null) {
      _user!.isFullNameVisible = newFullNameVisible;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updatePictureUrl(String newUrl){
    if (_user != null) {
      _user!.pictureUrl = newUrl;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

}

void saveUserToAppState({required BuildContext context, required BloqoUserData user}){
  Provider.of<UserAppState>(context, listen: false)._set(user);
}

BloqoUserData? getUserFromAppState({required BuildContext context}){
  return Provider.of<UserAppState>(context, listen: false)._get();
}

void updateUserFullNameInAppState({required BuildContext context, required String newFullName}){
  Provider.of<UserAppState>(context, listen: false)._updateFullName(newFullName);
}

void updateUserFullNameVisibilityInAppState({required BuildContext context, required bool newFullNameVisible}){
  Provider.of<UserAppState>(context, listen: false)._updateIsFullNameVisible(newFullNameVisible);
}

void updateUserPictureUrlInAppState({required BuildContext context, required String newUrl}){
  Provider.of<UserAppState>(context, listen: false)._updatePictureUrl(newUrl);
}

void addFollowingToUserAppState({required BuildContext context, required String newFollowing}){
  Provider.of<UserAppState>(context, listen: false)._addFollowing(newFollowing);
}

void removeFollowingFromUserAppState({required BuildContext context, required String oldFollowing}){
  Provider.of<UserAppState>(context, listen: false)._removeFollowing(oldFollowing);
}