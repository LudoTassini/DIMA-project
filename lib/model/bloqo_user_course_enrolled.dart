import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';
import '../utils/connectivity.dart';
import 'bloqo_user.dart';
import 'courses/bloqo_course.dart';
import 'courses/bloqo_section.dart';

class BloqoUserCourseEnrolled {
  final String courseId;
  final String publishedCourseId;
  final String courseAuthor;
  final String courseName;
  final String authorId;
  final String enrolledUserId;

  List<dynamic>? sectionsCompleted;
  List<dynamic>? chaptersCompleted;
  final int totNumSections;

  String? sectionName;
  String? sectionToComplete;

  Timestamp lastUpdated;
  final Timestamp enrollmentDate;

  bool isRated;
  bool isCompleted;

  BloqoUserCourseEnrolled({
    required this.courseId,
    required this.publishedCourseId,
    required this.courseAuthor,
    required this.enrolledUserId,
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
      publishedCourseId: data['published_course_id'],
      enrolledUserId: data['enrolled_user_id'],
      courseAuthor: data['course_author_username'],
      courseName: data['course_name'],
      sectionsCompleted: data['sections_completed'], //FIXME
      chaptersCompleted: data['chapters_completed'], //FIXME
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
      'published_course_id': publishedCourseId,
      'enrolled_user_id': enrolledUserId,
      'course_author_username': courseAuthor,
      'course_name': courseName,
      'sections_completed': sectionsCompleted,
      'tot_num_sections': totNumSections,
      'section_name': sectionName,
      'section_to_complete': sectionToComplete,
      'course_author_id': authorId,
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

Future<BloqoUserCourseEnrolled> saveNewUserCourseEnrolled({required var localizedText, required BloqoCourse course,
  required String publishedCourseId, required String userId}) async {
  try {
    BloqoUser author = await getUserFromId(localizedText: localizedText, id: course.authorId);
    List<BloqoChapter> chapters = await getChaptersFromIds(localizedText: localizedText, chapterIds: course.chapters);
    List<BloqoSection> sections = await getSectionsFromIds(localizedText: localizedText, sectionIds: chapters[0].sections);
    int totNumSections = 0;
    for (var chapter in chapters) {
      totNumSections = totNumSections + chapter.sections.length;
    }

    BloqoUserCourseEnrolled userCourseEnrolled =
      BloqoUserCourseEnrolled(
        courseId: course.id,
        publishedCourseId: publishedCourseId,
        enrolledUserId: userId,
        courseName: course.name,
        authorId: course.authorId,
        lastUpdated: Timestamp.now(),
        courseAuthor: author.username,
        sectionsCompleted: [],
        chaptersCompleted: [],
        sectionName: sections[0].name,
        sectionToComplete: sections[0].id,
        totNumSections: totNumSections,
        enrollmentDate: Timestamp.now(),
        isRated: false,
        isCompleted: false,
    );
    var ref = BloqoUserCourseEnrolled.getRef();
    await checkConnectivity(localizedText: localizedText);
    await ref.doc().set(userCourseEnrolled);

    // FIXME
    BloqoCourse courseEnrolled = await getCourseFromId(localizedText: localizedText, courseId: course.id);
    int numEnrollments = courseEnrolled.numberOfEnrollments + 1;
    courseEnrolled.numberOfEnrollments = numEnrollments;
    saveCourseChanges(localizedText: localizedText, updatedCourse: courseEnrolled);

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