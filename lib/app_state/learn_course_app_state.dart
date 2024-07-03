import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/courses/bloqo_course.dart';

class LearnCourseAppState with ChangeNotifier{

  BloqoCourse? _course;
  bool _fromHome = false;

  BloqoCourse? get() {
    return _course;
  }

  void set(BloqoCourse course){
    _course = course;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  bool getComingFromHomePrivilege(){
    return _fromHome;
  }

  void updateComingFromHomePrivilege(bool newValue){
    _fromHome = newValue;
  }

}

BloqoCourse? getLearnCourseFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false).get();
}

void saveLearnCourseToAppState({required BuildContext context, required BloqoCourse course, bool comingFromHome = false}){
  Provider.of<LearnCourseAppState>(context, listen: false).set(course);
  if(comingFromHome) {
    Provider.of<LearnCourseAppState>(context, listen: false).updateComingFromHomePrivilege(true);
  }
}

bool getComingFromHomeLearnPrivilege({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false).getComingFromHomePrivilege();
}

void setComingFromHomeLearnPrivilege({required BuildContext context}){
  Provider.of<LearnCourseAppState>(context, listen: false).updateComingFromHomePrivilege(true);
}

void useComingFromHomeLearnPrivilege({required BuildContext context}){
  Provider.of<LearnCourseAppState>(context, listen: false).updateComingFromHomePrivilege(false);
}