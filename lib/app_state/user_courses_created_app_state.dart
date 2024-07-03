import 'package:bloqo/model/bloqo_user_course_created.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UserCoursesCreatedAppState with ChangeNotifier{

  List<BloqoUserCourseCreated>? _userCourses;

  List<BloqoUserCourseCreated>? _get() {
    return _userCourses;
  }

  void _set(List<BloqoUserCourseCreated> userCourses){
    _userCourses = userCourses;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _addUserCourseCreated(BloqoUserCourseCreated userCourseCreated){
    if (_userCourses != null) {
      _userCourses!.add(userCourseCreated);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _deleteUserCourseCreated(BloqoUserCourseCreated userCourseCreated){
    if (_userCourses != null) {
      _userCourses!.remove(userCourseCreated);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

}

void saveUserCoursesCreatedToAppState({required BuildContext context, required List<BloqoUserCourseCreated> courses}){
  Provider.of<UserCoursesCreatedAppState>(context, listen: false)._set(courses);
}

List<BloqoUserCourseCreated>? getUserCoursesCreatedFromAppState({required BuildContext context}){
  return Provider.of<UserCoursesCreatedAppState>(context, listen: false)._get();
}

void addUserCourseCreatedToAppState({required BuildContext context, required BloqoUserCourseCreated userCourseCreated}){
  if(Provider.of<UserCoursesCreatedAppState>(context, listen: false)._get() == null){
    Provider.of<UserCoursesCreatedAppState>(context, listen: false)._set([userCourseCreated]);
  }
  else {
    Provider.of<UserCoursesCreatedAppState>(context, listen: false)
        ._addUserCourseCreated(userCourseCreated);
  }
}

void deleteUserCourseCreatedFromAppState({required BuildContext context, required BloqoUserCourseCreated userCourseCreated}){
  Provider.of<UserCoursesCreatedAppState>(context, listen: false)._deleteUserCourseCreated(userCourseCreated);
}