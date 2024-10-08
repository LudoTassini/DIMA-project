import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/bloqo_exception.dart';
import '../bloqo_user_data.dart';
import '../courses/bloqo_course_data.dart';

class BloqoUserCourseCreatedData {
  final String courseId;
  String courseName;
  int numSectionsCreated;
  int numChaptersCreated;
  final String authorId;
  Timestamp lastUpdated;
  bool published;

  BloqoUserCourseCreatedData({
    required this.courseId,
    required this.courseName,
    required this.numSectionsCreated,
    required this.numChaptersCreated,
    required this.authorId,
    required this.published,
    required this.lastUpdated
  });

  factory BloqoUserCourseCreatedData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();

    return BloqoUserCourseCreatedData(
      courseId: data!['course_id'],
      courseName: data['course_name'],
      numSectionsCreated: data['num_sections_created'],
      numChaptersCreated: data['num_chapters_created'],
      authorId: data['author_id'],
      published: data['published'],
      lastUpdated: data['last_updated']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'course_id': courseId,
      'course_name': courseName,
      'num_sections_created': numSectionsCreated,
      'num_chapters_created': numChaptersCreated,
      'author_id': authorId,
      'published': published,
      'last_updated': lastUpdated
    };
  }

  static getRef({required FirebaseFirestore firestore}) {
    return firestore.collection("user_course_created").withConverter(
      fromFirestore: BloqoUserCourseCreatedData.fromFirestore,
      toFirestore: (BloqoUserCourseCreatedData userCourse, _) => userCourse.toFirestore(),
    );
  }
}

Future<BloqoUserCourseCreatedData> saveNewUserCourseCreated({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoCourseData course
}) async {
  try {
    BloqoUserCourseCreatedData userCourseCreated = BloqoUserCourseCreatedData(
      courseId: course.id,
      courseName: course.name,
      numSectionsCreated: 0,
      numChaptersCreated: 0,
      authorId: course.authorId,
      published: false,
      lastUpdated: Timestamp.now()
    );
    var ref = BloqoUserCourseCreatedData.getRef(firestore: firestore);
    await ref.doc().set(userCourseCreated);
    return userCourseCreated;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<List<BloqoUserCourseCreatedData>> getUserCoursesCreated({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoUserData user
}) async {
  try {
    var ref = BloqoUserCourseCreatedData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("author_id", isEqualTo: user.id).orderBy("last_updated", descending: true).get();
    List<BloqoUserCourseCreatedData> userCourses = [];
    for(var doc in querySnapshot.docs) {
      userCourses.add(doc.data());
    }
    return userCourses;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<List<BloqoUserCourseCreatedData>> silentGetUserCoursesCreated({
  required BloqoUserData user
}) async {
  var ref = BloqoUserCourseCreatedData.getRef(firestore: FirebaseFirestore.instance);
  var querySnapshot = await ref.where("author_id", isEqualTo: user.id).orderBy("last_updated", descending: true).get();
  List<BloqoUserCourseCreatedData> userCourses = [];
  for(var doc in querySnapshot.docs) {
    userCourses.add(doc.data());
  }
  return userCourses;
}

Future<void> deleteUserCourseCreated({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId
}) async {
  try {
    var ref = BloqoUserCourseCreatedData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("course_id", isEqualTo: courseId).get();
    await querySnapshot.docs[0].reference.delete();
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteChapterFromUserCourseCreated({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId
}) async {
  try {
    var ref = BloqoUserCourseCreatedData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("course_id", isEqualTo: courseId).get();
    BloqoUserCourseCreatedData userCourseCreated = querySnapshot.docs[0].data();
    userCourseCreated.numChaptersCreated--;
    await querySnapshot.docs[0].reference.update(userCourseCreated.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteSectionFromUserCourseCreated({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId
}) async {
  try {
    var ref = BloqoUserCourseCreatedData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("course_id", isEqualTo: courseId).get();
    BloqoUserCourseCreatedData userCourseCreated = querySnapshot.docs[0].data();
    userCourseCreated.numSectionsCreated--;
    await querySnapshot.docs[0].reference.update(userCourseCreated.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> saveUserCourseCreatedChanges({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoUserCourseCreatedData updatedUserCourseCreated
}) async {
  try {
    updatedUserCourseCreated.lastUpdated = Timestamp.now();
    var ref = BloqoUserCourseCreatedData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("course_id", isEqualTo: updatedUserCourseCreated.courseId).get();
    if (querySnapshot.docs.isEmpty) {
      throw BloqoException(message: localizedText.course_not_found);
    }
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedUserCourseCreated.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}