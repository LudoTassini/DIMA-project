import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user_courses/bloqo_user_course_enrolled_data.dart';

class UserCoursesEnrolledAppState with ChangeNotifier{

  List<BloqoUserCourseEnrolledData>? _userCourses;

  List<BloqoUserCourseEnrolledData>? _get() {
    return _userCourses;
  }

  void _set(List<BloqoUserCourseEnrolledData> userCourses){
    _userCourses = userCourses;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _deleteUserCourseEnrolled(BloqoUserCourseEnrolledData userCourseEnrolled){
    if (_userCourses != null) {
      _userCourses!.remove(userCourseEnrolled);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updateCourse(BloqoUserCourseEnrolledData userCourse) {
    final index = _userCourses!.indexWhere((x) => x.courseId == userCourse.courseId &&
        x.enrolledUserId == userCourse.enrolledUserId);

    if (index != -1) {
      _userCourses![index] = userCourse;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

}

void saveUserCoursesEnrolledToAppState({required BuildContext context, required List<BloqoUserCourseEnrolledData> courses}){
  Provider.of<UserCoursesEnrolledAppState>(context, listen: false)._set(courses);
}

void updateUserCoursesEnrolledToAppState({required BuildContext context, required BloqoUserCourseEnrolledData userCourseEnrolled}){
  Provider.of<UserCoursesEnrolledAppState>(context, listen: false)._updateCourse(userCourseEnrolled);
}

List<BloqoUserCourseEnrolledData>? getUserCoursesEnrolledFromAppState({required BuildContext context}){
  return Provider.of<UserCoursesEnrolledAppState>(context, listen: false)._get();
}

void deleteUserCourseEnrolledFromAppState({required BuildContext context, required BloqoUserCourseEnrolledData userCourseEnrolled}){
  Provider.of<UserCoursesEnrolledAppState>(context, listen: false)._deleteUserCourseEnrolled(userCourseEnrolled);
}