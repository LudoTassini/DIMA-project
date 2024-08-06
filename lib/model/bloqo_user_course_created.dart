import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';
import '../utils/connectivity.dart';
import 'bloqo_user.dart';
import 'courses/bloqo_course.dart';

class BloqoUserCourseCreated {
  final String courseId;
  String courseName;
  int numSectionsCreated;
  int numChaptersCreated;
  final String authorId;
  Timestamp lastUpdated;
  bool published;

  BloqoUserCourseCreated({
    required this.courseId,
    required this.courseName,
    required this.numSectionsCreated,
    required this.numChaptersCreated,
    required this.authorId,
    required this.published,
    required this.lastUpdated
  });

  factory BloqoUserCourseCreated.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();

    return BloqoUserCourseCreated(
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

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("user_course_created").withConverter(
      fromFirestore: BloqoUserCourseCreated.fromFirestore,
      toFirestore: (BloqoUserCourseCreated userCourse, _) => userCourse.toFirestore(),
    );
  }
}

Future<BloqoUserCourseCreated> saveNewUserCourseCreated({required var localizedText, required BloqoCourse course}) async {
  try {
    BloqoUserCourseCreated userCourseCreated = BloqoUserCourseCreated(
      courseId: course.id,
      courseName: course.name,
      numSectionsCreated: 0,
      numChaptersCreated: 0,
      authorId: course.authorId,
      published: false,
      lastUpdated: Timestamp.now()
    );
    var ref = BloqoUserCourseCreated.getRef();
    await checkConnectivity(localizedText: localizedText);
    await ref.doc().set(userCourseCreated);
    return userCourseCreated;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

// FIXME: limitare a tre corsi
// FIXME: da cambiare: author_id --> course_author_id
Future<List<BloqoUserCourseCreated>> getUserCoursesCreated({required var localizedText, required BloqoUser user}) async {
  try {
    var ref = BloqoUserCourseCreated.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("author_id", isEqualTo: user.id).orderBy("last_updated", descending: true).get();
    List<BloqoUserCourseCreated> userCourses = [];
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

Future<void> deleteUserCourseCreated({required var localizedText, required String courseId}) async {
  try {
    var ref = BloqoUserCourseCreated.getRef();
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

Future<void> deleteChapterFromUserCourseCreated({required var localizedText, required String courseId}) async {
  try {
    var ref = BloqoUserCourseCreated.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("course_id", isEqualTo: courseId).get();
    BloqoUserCourseCreated userCourseCreated = querySnapshot.docs[0].data();
    userCourseCreated.numChaptersCreated--;
    await querySnapshot.docs[0].reference.update(userCourseCreated.toFirestore());
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> deleteSectionFromUserCourseCreated({required var localizedText, required String courseId}) async {
  try {
    var ref = BloqoUserCourseCreated.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("course_id", isEqualTo: courseId).get();
    BloqoUserCourseCreated userCourseCreated = querySnapshot.docs[0].data();
    userCourseCreated.numSectionsCreated--;
    await querySnapshot.docs[0].reference.update(userCourseCreated.toFirestore());
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> saveUserCourseCreatedChanges({required var localizedText, required BloqoUserCourseCreated updatedUserCourseCreated}) async {
  try {
    updatedUserCourseCreated.lastUpdated = Timestamp.now();
    var ref = BloqoUserCourseCreated.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("course_id", isEqualTo: updatedUserCourseCreated.courseId).get();
    if (querySnapshot.docs.isEmpty) {
      throw BloqoException(message: localizedText.course_not_found);
    }
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedUserCourseCreated.toFirestore());
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  } catch (e) {
    throw BloqoException(message: localizedText.generic_error);
  }
}