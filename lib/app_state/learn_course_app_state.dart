import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bloqo_user_course_enrolled.dart';
import '../model/courses/bloqo_course.dart';

class LearnCourseAppState with ChangeNotifier{

  BloqoUserCourseEnrolled? _course;
  bool _fromHome = false;

  BloqoUserCourseEnrolled? _get() {
    return _course;
  }

  void _set(BloqoUserCourseEnrolled course){
    _course = course;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  bool _getComingFromHomePrivilege(){
    return _fromHome;
  }

  void _updateComingFromHomePrivilege(bool newValue){
    _fromHome = newValue;
  }

}

BloqoUserCourseEnrolled? getLearnCourseFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._get();
}

void saveLearnCourseToAppState({required BuildContext context, required BloqoUserCourseEnrolled course, bool comingFromHome = false}){
  Provider.of<LearnCourseAppState>(context, listen: false)._set(course);
  if(comingFromHome) {
    Provider.of<LearnCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
  }
}

bool getComingFromHomeLearnPrivilegeFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getComingFromHomePrivilege();
}

void setComingFromHomeLearnPrivilegeToAppState({required BuildContext context}){
  Provider.of<LearnCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
}

void useComingFromHomeLearnPrivilegeFromAppState({required BuildContext context}){
  Provider.of<LearnCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(false);
}