import 'dart:ui';

import '../model/bloqo_user_data.dart';
import '../model/user_courses/bloqo_user_course_created_data.dart';
import '../model/user_courses/bloqo_user_course_enrolled_data.dart';

class BloqoStartupInformation{

  final bool isLoggedIn;
  final Locale locale;

  final BloqoUserData? user;
  final List<BloqoUserCourseEnrolledData>? userCoursesEnrolled;
  final List<BloqoUserCourseCreatedData>? userCoursesCreated;

  BloqoStartupInformation({
    required this.isLoggedIn,
    required this.locale,
    this.user,
    this.userCoursesEnrolled,
    this.userCoursesCreated
  });

}