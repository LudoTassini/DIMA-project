import 'package:bloqo/model/bloqo_user_course_created.dart';
import 'package:flutter/material.dart';

class UserCoursesCreatedAppState with ChangeNotifier{

  List<BloqoUserCourseCreated>? _userCourses;

  List<BloqoUserCourseCreated>? get() {
    return _userCourses;
  }

  void set(List<BloqoUserCourseCreated> userCourses){
    _userCourses = userCourses;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void addUserCourseCreated(BloqoUserCourseCreated userCourseCreated){
    if (_userCourses != null) {
      _userCourses!.add(userCourseCreated);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

}