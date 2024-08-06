import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';
import '../utils/connectivity.dart';
import 'bloqo_user.dart';
import 'courses/bloqo_course.dart';

class BloqoUserCourseEnrolled {
  final String courseId;
  final String courseAuthor;
  final String courseName;
  final String authorId;

  List<dynamic> sectionsCompleted;
  List<dynamic> chaptersCompleted;
  final int totNumSections;

  String? sectionName;
  String? sectionToComplete;

  Timestamp lastUpdated;
  final Timestamp enrollmentDate;

  bool isRated;
  bool isCompleted;

  BloqoUserCourseEnrolled({
    required this.courseId,
    required this.courseAuthor,
    required this.courseName,
    required this.sectionsCompleted,
    required this.chaptersCompleted,
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
      sectionsCompleted: data['sections_completed'], //FIXME
      chaptersCompleted: data['chapters_completed'],
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
      'sections_completed': sectionsCompleted,
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

Future<BloqoUserCourseEnrolled> saveNewUserCourseEnrolled({required var localizedText, required BloqoCourse course}) async {
  try {
    BloqoUser author = await getUserFromId(localizedText: localizedText, id: course.authorId);
    List<BloqoChapter> chapters = await getChaptersFromIds(localizedText: localizedText, chapterIds: course.chapters);
    int totNumSections = 0;
    for (var chapter in chapters) {
      totNumSections = totNumSections + chapter.sections.length;
    }
    BloqoUserCourseEnrolled userCourseEnrolled =
      BloqoUserCourseEnrolled(
        courseId: course.id,
        courseName: course.name,
        authorId: course.authorId,
        lastUpdated: Timestamp.now(),
        courseAuthor: author.username,
        sectionsCompleted: [],
        chaptersCompleted: [],
        totNumSections: totNumSections,
        enrollmentDate: Timestamp.now(),
        isRated: false,
        isCompleted: false,
    );
    var ref = BloqoUserCourseEnrolled.getRef();
    await checkConnectivity(localizedText: localizedText);
    await ref.doc().set(userCourseEnrolled);
    return userCourseEnrolled;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> deleteUserCourseEnrolled({required var localizedText, required String courseId}) async {
  try {
    var ref = BloqoUserCourseEnrolled.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("course_id", isEqualTo: courseId).get();
    await querySnapshot.docs[0].reference.delete();
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}