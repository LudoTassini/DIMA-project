import 'package:bloqo/model/user_courses/bloqo_user_course_created_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UserCoursesCreatedAppState with ChangeNotifier{

  List<BloqoUserCourseCreatedData>? _userCourses;

  List<BloqoUserCourseCreatedData>? _get() {
    return _userCourses;
  }

  void _set(List<BloqoUserCourseCreatedData> userCourses){
    _userCourses = userCourses;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _addUserCourseCreated(BloqoUserCourseCreatedData userCourseCreated){
    if (_userCourses != null) {
      _userCourses!.add(userCourseCreated);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _deleteUserCourseCreated(BloqoUserCourseCreatedData userCourseCreated){
    if (_userCourses != null) {
      _userCourses!.remove(userCourseCreated);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updateUserCourseCreatedChaptersNumber(String courseId, int newChaptersNum){
    if(_userCourses != null) {
      _userCourses!.where((userCourse) => userCourse.courseId == courseId).first.numChaptersCreated = newChaptersNum;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updateUserCourseCreatedSectionsNumber(String courseId, int of){
    if(_userCourses != null) {
      _userCourses!.where((userCourse) => userCourse.courseId == courseId).first.numSectionsCreated += of;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updateUserCourseCreatedName(String courseId, String newName){
    if(_userCourses != null) {
      _userCourses!.where((userCourse) => userCourse.courseId == courseId).first.courseName = newName;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updateUserCourseCreatedPublishedStatusName(String courseId, bool newStatus){
    if(_userCourses != null) {
      _userCourses!.where((userCourse) => userCourse.courseId == courseId).first.published = newStatus;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

}

void saveUserCoursesCreatedToAppState({required BuildContext context, required List<BloqoUserCourseCreatedData> courses}){
  Provider.of<UserCoursesCreatedAppState>(context, listen: false)._set(courses);
}

List<BloqoUserCourseCreatedData>? getUserCoursesCreatedFromAppState({required BuildContext context}){
  return Provider.of<UserCoursesCreatedAppState>(context, listen: false)._get();
}

void addUserCourseCreatedToAppState({required BuildContext context, required BloqoUserCourseCreatedData userCourseCreated}){
  if(Provider.of<UserCoursesCreatedAppState>(context, listen: false)._get() == null){
    Provider.of<UserCoursesCreatedAppState>(context, listen: false)._set([userCourseCreated]);
  }
  else {
    Provider.of<UserCoursesCreatedAppState>(context, listen: false)
        ._addUserCourseCreated(userCourseCreated);
  }
}

void deleteUserCourseCreatedFromAppState({required BuildContext context, required BloqoUserCourseCreatedData userCourseCreated}){
  Provider.of<UserCoursesCreatedAppState>(context, listen: false)._deleteUserCourseCreated(userCourseCreated);
}

void updateUserCourseCreatedNameInAppState({required BuildContext context, required String courseId, required String newName}){
  Provider.of<UserCoursesCreatedAppState>(context, listen: false)._updateUserCourseCreatedName(courseId, newName);
}

void updateUserCourseCreatedChaptersNumberInAppState({required BuildContext context, required String courseId, required int newChaptersNum}){
  Provider.of<UserCoursesCreatedAppState>(context, listen: false)._updateUserCourseCreatedChaptersNumber(courseId, newChaptersNum);
}

void updateUserCourseCreatedSectionsNumberInAppState({required BuildContext context, required String courseId, required int of}){
  Provider.of<UserCoursesCreatedAppState>(context, listen: false)._updateUserCourseCreatedSectionsNumber(courseId, of);
}

void updateUserCourseCreatedPublishedStatusInAppState({required BuildContext context, required String courseId, required bool published}){
  Provider.of<UserCoursesCreatedAppState>(context, listen: false)._updateUserCourseCreatedPublishedStatusName(courseId, published);
}