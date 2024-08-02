import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';
import '../utils/connectivity.dart';
import 'bloqo_user.dart';

class BloqoUserCourseEnrolled {
  final String courseId;
  final String courseAuthor;
  final String courseName;
  final String authorId;
  final String? description;

  int numSectionsCompleted;
  final int totNumSections;

  String? sectionName;
  DocumentReference? sectionToComplete;

  Timestamp lastUpdated;
  Timestamp enrollmentDate;

  bool isRated;
  bool isCompleted;

  BloqoUserCourseEnrolled({
    required this.courseId,
    required this.courseAuthor,
    required this.courseName,
    this.description,
    required this.numSectionsCompleted,
    required this.totNumSections,
    this.sectionName,
    this.sectionToComplete,
    required this.authorId,
    required this.lastUpdated,
    required this.enrollmentDate,
    required this.isRated,
    required this.isCompleted,
  });

  factory BloqoUserCourseEnrolled.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();

    return BloqoUserCourseEnrolled(
      courseId: data!['course_id'],
      courseAuthor: data['course_author_username'],
      courseName: data['course_name'],
      description: data["description"],
      numSectionsCompleted: data['num_sections_completed'],
      totNumSections: data['tot_num_sections'],
      sectionName: data['section_name'],
      sectionToComplete: data['section_to_complete'],
      authorId: data['course_author_id'],
      lastUpdated: data['last_updated'],
      enrollmentDate: data['enrollment_date'],
      isRated: data['is_rated'],
      isCompleted: data['is_completed'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'course_id': courseId,
      'course_author': courseAuthor,
      'course_name': courseName,
      "description": description,
      'num_sections_completed': numSectionsCompleted,
      'tot_num_sections': totNumSections,
      'section_name': sectionName,
      'section_to_complete': sectionToComplete,
      'author_id': authorId,
      'last_updated': FieldValue.serverTimestamp(),
      'enrollment_date': enrollmentDate,
      'is_rated': isRated,
      'is_completed': isCompleted,
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

// FIXME: limitare a tre corsi
Future<List<BloqoUserCourseEnrolled>> getUserCoursesEnrolled({required var localizedText, required BloqoUser user}) async {
  try {
    var ref = BloqoUserCourseEnrolled.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("enrolled_user_id", isEqualTo: user.id).orderBy("last_updated", descending: true).get();
    List<BloqoUserCourseEnrolled> userCourses = [];
    for(var doc in querySnapshot.docs) {
      userCourses.add(doc.data());
    }
    return userCourses;
  } on FirebaseAuthException catch(e){
    switch(e.code){
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<BloqoUserCourseEnrolled> getUserCourseEnrolledFromId({required var localizedText, required String courseId}) async {
  try {
    var ref = BloqoUserCourseEnrolled.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("course_id", isEqualTo: courseId).get();
    BloqoUserCourseEnrolled course = querySnapshot.docs.first.data();
    return course;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}