import 'package:bloqo/model/courses/published_courses/bloqo_published_course_data.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/bloqo_exception.dart';
import '../bloqo_user_data.dart';
import '../courses/bloqo_course_data.dart';
import '../courses/bloqo_section_data.dart';

class BloqoUserCourseEnrolledData {
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

  BloqoUserCourseEnrolledData({
    required this.courseId,
    required this.publishedCourseId,
    required this.courseAuthor,
    required this.enrolledUserId,
    required this.courseName,
    required this.sectionsCompleted,
    required this.chaptersCompleted,
    required this.totNumSections,
    required this.sectionName,
    required this.sectionToComplete,
    required this.authorId,
    required this.lastUpdated,
    required this.enrollmentDate,
    required this.isRated,
    required this.isCompleted,
  });

  factory BloqoUserCourseEnrolledData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();

    return BloqoUserCourseEnrolledData(
      courseId: data!['course_id'],
      publishedCourseId: data['published_course_id'],
      enrolledUserId: data['enrolled_user_id'],
      courseAuthor: data['course_author_username'],
      courseName: data['course_name'],
      sectionsCompleted: data['sections_completed'],
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
      'published_course_id': publishedCourseId,
      'enrolled_user_id': enrolledUserId,
      'course_author_username': courseAuthor,
      'course_name': courseName,
      'sections_completed': sectionsCompleted,
      'chapters_completed': chaptersCompleted,
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

  static getRef({required FirebaseFirestore firestore}) {
    return firestore.collection("user_course_enrolled").withConverter(
      fromFirestore: BloqoUserCourseEnrolledData.fromFirestore,
      toFirestore: (BloqoUserCourseEnrolledData userCourse, _) => userCourse.toFirestore(),
    );
  }

}

Future<List<BloqoUserCourseEnrolledData>> getUserCoursesEnrolled({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoUserData user
}) async {
  try {
    var ref = BloqoUserCourseEnrolledData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("enrolled_user_id", isEqualTo: user.id).orderBy("last_updated", descending: true).get();
    List<BloqoUserCourseEnrolledData> userCourses = [];
    for(var doc in querySnapshot.docs) {
      userCourses.add(doc.data());
    }
    return userCourses;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<List<BloqoUserCourseEnrolledData>> silentGetUserCoursesEnrolled({
  required BloqoUserData user
}) async {
  var ref = BloqoUserCourseEnrolledData.getRef(firestore: FirebaseFirestore.instance);
  var querySnapshot = await ref.where("enrolled_user_id", isEqualTo: user.id).orderBy("last_updated", descending: true).get();
  List<BloqoUserCourseEnrolledData> userCourses = [];
  for(var doc in querySnapshot.docs) {
    userCourses.add(doc.data());
  }
  return userCourses;
}

Future<BloqoUserCourseEnrolledData> getUserCourseEnrolledFromCourseId({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId
}) async {
  try {
    var ref = BloqoUserCourseEnrolledData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("course_id", isEqualTo: courseId).get();
    BloqoUserCourseEnrolledData course = querySnapshot.docs.first.data();
    return course;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<BloqoUserCourseEnrolledData> saveNewUserCourseEnrolled({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoCourseData course,
  required String publishedCourseId, required String userId}) async {
  try {
    BloqoUserData author = await getUserFromId(firestore: firestore, localizedText: localizedText, id: course.authorId);
    List<BloqoChapterData> chapters = await getChaptersFromIds(firestore: firestore, localizedText: localizedText, chapterIds: course.chapters);
    List<BloqoSectionData> sections = await getSectionsFromIds(firestore: firestore, localizedText: localizedText, sectionIds: chapters[0].sections);
    int totNumSections = 0;
    for (var chapter in chapters) {
      totNumSections = totNumSections + chapter.sections.length;
    }

    BloqoUserCourseEnrolledData userCourseEnrolled =
      BloqoUserCourseEnrolledData(
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
    var ref = BloqoUserCourseEnrolledData.getRef(firestore: firestore);
    await ref.doc().set(userCourseEnrolled);

    BloqoPublishedCourseData publishedCourseEnrolled = await getPublishedCourseFromCourseId(firestore: firestore, localizedText: localizedText, courseId: course.id);
    int numEnrollments = publishedCourseEnrolled.numberOfEnrollments + 1;
    publishedCourseEnrolled.numberOfEnrollments = numEnrollments;
    await savePublishedCourseChanges(firestore: firestore, localizedText: localizedText, updatedPublishedCourse: publishedCourseEnrolled);

    return userCourseEnrolled;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteUserCourseEnrolled({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId,
  required String enrolledUserId
}) async {
  try {
    var ref = BloqoUserCourseEnrolledData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("course_id", isEqualTo: courseId).where("enrolled_user_id", isEqualTo: enrolledUserId).get();
    await querySnapshot.docs[0].reference.delete();
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteUserCoursesEnrolledForDismissedCourse({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String publishedCourseId
}) async {
  try {
    var ref = BloqoUserCourseEnrolledData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("published_course_id", isEqualTo: publishedCourseId).get();
    for(var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> updateUserCourseEnrolledCompletedSections({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId,
  required String enrolledUserId,
  required List<dynamic>? sectionsCompleted
}) async {
  try {
    var ref = BloqoUserCourseEnrolledData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("course_id", isEqualTo: courseId)
        .where("enrolled_user_id", isEqualTo: enrolledUserId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoUserCourseEnrolledData userCourseEnrolled = docSnapshot.data();
    userCourseEnrolled.sectionsCompleted = sectionsCompleted;

    await ref.doc(docSnapshot.id).update(userCourseEnrolled.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> updateUserCourseEnrolledCompletedChapters({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId,
  required String enrolledUserId,
  required List<dynamic>? chaptersCompleted
}) async {
  try {
    var ref = BloqoUserCourseEnrolledData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("course_id", isEqualTo: courseId)
        .where("enrolled_user_id", isEqualTo: enrolledUserId).get();
    var docSnapshot = querySnapshot.docs.first;

    BloqoUserCourseEnrolledData course = docSnapshot.data();

    course.chaptersCompleted = chaptersCompleted;

    await ref.doc(docSnapshot.id).update(course.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> updateUserCourseEnrolledStatusCompleted({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId,
  required String enrolledUserId,
}) async {
  try {
    var ref = BloqoUserCourseEnrolledData.getRef(firestore: firestore);
    var querySnapshot = await ref
        .where("course_id", isEqualTo: courseId)
        .where("enrolled_user_id", isEqualTo: enrolledUserId)
        .get();

    var docSnapshot = querySnapshot.docs.first;

    BloqoUserCourseEnrolledData courseEnrolled = docSnapshot.data();

    courseEnrolled.isCompleted = true;
    courseEnrolled.sectionToComplete = null;
    courseEnrolled.sectionName = null;
    courseEnrolled.lastUpdated = Timestamp.now();

    await ref.doc(docSnapshot.id).update(courseEnrolled.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> updateUserCourseEnrolledNewSectionToComplete({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId,
  required String enrolledUserId,
  required BloqoSectionData sectionToComplete
}) async {
  try {

    var ref = BloqoUserCourseEnrolledData.getRef(firestore: firestore);
    var querySnapshot = await ref
        .where("course_id", isEqualTo: courseId)
        .where("enrolled_user_id", isEqualTo: enrolledUserId)
        .get();

    var docSnapshot = querySnapshot.docs.first;
    BloqoUserCourseEnrolledData courseEnrolled = docSnapshot.data();

    courseEnrolled.sectionToComplete = sectionToComplete.id;
    courseEnrolled.sectionName = sectionToComplete.name;
    courseEnrolled.lastUpdated = Timestamp.now();

    await ref.doc(docSnapshot.id).update(courseEnrolled.toFirestore());

  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> updateUserCourseEnrolledRated({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String userId,
  required String publishedCourseId
}) async {
  try {
    var ref = BloqoUserCourseEnrolledData.getRef(firestore: firestore);
    var querySnapshot = await ref
        .where("published_course_id", isEqualTo: publishedCourseId)
        .where("enrolled_user_id", isEqualTo: userId)
        .get();

    var docSnapshot = querySnapshot.docs.first;
    BloqoUserCourseEnrolledData courseEnrolled = docSnapshot.data();

    courseEnrolled.isRated = true;
    await ref.doc(docSnapshot.id).update(courseEnrolled.toFirestore());

  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}