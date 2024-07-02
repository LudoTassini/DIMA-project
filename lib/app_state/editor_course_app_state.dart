import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/courses/bloqo_course.dart';

class EditorCourseAppState with ChangeNotifier{

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

BloqoCourse? getEditorCourseFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false).get();
}

void saveEditorCourseToAppState({required BuildContext context, required BloqoCourse course, bool comingFromHome = false}){
  Provider.of<EditorCourseAppState>(context, listen: false).set(course);
  if(comingFromHome) {
    Provider.of<EditorCourseAppState>(context, listen: false).updateComingFromHomePrivilege(true);
  }
}

bool getComingFromHomeEditorPrivilege({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false).getComingFromHomePrivilege();
}

void setComingFromHomeEditorPrivilege({required BuildContext context}){
  Provider.of<EditorCourseAppState>(context, listen: false).updateComingFromHomePrivilege(true);
}

void useComingFromHomeEditorPrivilege({required BuildContext context}){
  Provider.of<EditorCourseAppState>(context, listen: false).updateComingFromHomePrivilege(false);
}