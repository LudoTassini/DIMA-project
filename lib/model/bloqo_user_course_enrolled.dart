import 'package:cloud_firestore/cloud_firestore.dart';

class BloqoUserCourseEnrolled {
  final DocumentReference course;
  final String courseAuthor;
  final String courseName;
  int numSectionsCompleted;
  final int totNumSections;
  String sectionName;
  DocumentReference sectionToComplete;
  final String userEmail;

  BloqoUserCourseEnrolled({
    required this.course,
    required this.courseAuthor,
    required this.courseName,
    required this.numSectionsCompleted,
    required this.totNumSections,
    required this.sectionName,
    required this.sectionToComplete,
    required this.userEmail,
  });

  factory BloqoUserCourseEnrolled.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();

    return BloqoUserCourseEnrolled(
      course: data!['course'],
      courseAuthor: data['course_author'],
      courseName: data['course_name'],
      numSectionsCompleted: data['num_sections_completed'],
      totNumSections: data['tot_num_sections'],
      sectionName: data['section_name'],
      sectionToComplete: data['section_to_complete'],
      userEmail: data['user_email'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'course': course,
      'course_author': courseAuthor,
      'course_name': courseName,
      'num_sections_completed': numSectionsCompleted,
      'tot_num_sections': totNumSections,
      'section_name': sectionName,
      'section_to_complete': sectionToComplete,
      'user_email': userEmail,
    };
  }

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("user_course_enrolled").withConverter(
      fromFirestore: BloqoUserCourseEnrolled.fromFirestore,
      toFirestore: (BloqoUserCourseEnrolled userCourse, _) => userCourse.toFirestore(),
    );
  }
}