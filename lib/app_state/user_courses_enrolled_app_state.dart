import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/bloqo_user_course_enrolled.dart';

class UserCoursesEnrolledAppState with ChangeNotifier{

  List<BloqoUserCourseEnrolled>? _userCourses;

  List<BloqoUserCourseEnrolled>? get() {
    return _userCourses;
  }

  void set(List<BloqoUserCourseEnrolled> userCourses){
    _userCourses = userCourses;
  }

}

void saveUserCoursesEnrolledToAppState({required BuildContext context, required List<BloqoUserCourseEnrolled> courses}){
  Provider.of<UserCoursesEnrolledAppState>(context, listen: false).set(courses);
}