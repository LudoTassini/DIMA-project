import 'package:flutter/material.dart';

class NavigationAppState with ChangeNotifier{

  int _currentMainPageIndex = 0;

  int get() {
    return _currentMainPageIndex;
  }

  void set(int newMainPageIndex){
    _currentMainPageIndex = newMainPageIndex;
    notifyListeners();
  }

}