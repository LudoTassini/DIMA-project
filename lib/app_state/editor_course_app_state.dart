import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/courses/bloqo_course.dart';

class EditorCourseAppState with ChangeNotifier{

  BloqoCourse? _course;
  bool _fromHome = false;

  BloqoCourse? _get() {
    return _course;
  }

  void _set(BloqoCourse course){
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

BloqoCourse? getEditorCourseFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._get();
}

void saveEditorCourseToAppState({required BuildContext context, required BloqoCourse course, bool comingFromHome = false}){
  Provider.of<EditorCourseAppState>(context, listen: false)._set(course);
  if(comingFromHome) {
    Provider.of<EditorCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
  }
}

bool getComingFromHomeEditorPrivilegeFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getComingFromHomePrivilege();
}

void setComingFromHomeEditorPrivilegeToAppState({required BuildContext context}){
  Provider.of<EditorCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
}

void useComingFromHomeEditorPrivilegeFromAppState({required BuildContext context}){
  Provider.of<EditorCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(false);
}