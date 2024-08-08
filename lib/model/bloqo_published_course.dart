import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';
import '../utils/connectivity.dart';

class BloqoPublishedCourse {
  final String publishedCourseId;
  final String originalCourseId;
  final String courseName;
  final String authorUsername;
  final String authorId;
  final bool isPublic;
  final Timestamp publicationDate;
  final String language;
  final String modality;
  final String subject;
  final String duration;
  final String difficulty;

  List<dynamic> reviews;
  final double rating;

  int numberOfEnrollments;
  int numberOfCompletions;

  BloqoPublishedCourse({
    required this.publishedCourseId,
    required this.originalCourseId,
    required this.courseName,
    required this.authorUsername,
    required this.authorId,
    required this.isPublic,
    required this.publicationDate,
    required this.language,
    required this.modality,
    required this.subject,
    required this.difficulty,
    required this.duration,
    required this.reviews,
    required this.rating,
    this.numberOfEnrollments = 0,
    this.numberOfCompletions = 0,
  });

  factory BloqoPublishedCourse.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data()!;
    return BloqoPublishedCourse(
      publishedCourseId: data["published_course_id"],
      originalCourseId: data["original_course_id"],
      courseName: data["course_name"],
      authorUsername: data["author_username"],
      authorId: data["author_id"],
      isPublic: data["is_public"],
      publicationDate: data["publication_date"],
      language: data["language"],
      modality: data["modality"],
      subject: data["subject"],
      difficulty: data["difficulty"],
      duration: data["duration"],
      reviews: data["reviews"],
      rating: (data["rating"] is int) ? (data["rating"] as int).toDouble() : data["rating"],
      numberOfEnrollments: data["number_of_enrollments"],
      numberOfCompletions: data["number_of_completions"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "published_course_id": publishedCourseId,
      "original_course_id": originalCourseId,
      "course_name": courseName,
      "author_username": authorUsername,
      "author_id": authorId,
      "publication_date": publicationDate,
      "is_public": isPublic,
      "language": language,
      "modality": modality,
      "subject": subject,
      "difficulty": difficulty,
      "duration": duration,
      "reviews": reviews,
      "rating": rating,
      "number_of_enrollments": numberOfEnrollments,
      "number_of_completions": numberOfCompletions,
    };
  }

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("published_courses").withConverter(
      fromFirestore: BloqoPublishedCourse.fromFirestore,
      toFirestore: (BloqoPublishedCourse course, _) => course.toFirestore(),
    );
  }
}

Future<BloqoPublishedCourse> getPublishedCourseFromPublishedCourseId({required var localizedText, required String publishedCourseId}) async {
  try {
    await checkConnectivity(localizedText: localizedText);
    var ref = BloqoPublishedCourse.getRef();
    var querySnapshot = await ref.where("published_course_id", isEqualTo: publishedCourseId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoPublishedCourse publishedCourse = docSnapshot.data();
    return publishedCourse;
  } on FirebaseException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<BloqoPublishedCourse> getPublishedCourseFromCourseId({required var localizedText, required String courseId}) async {
  try {
    await checkConnectivity(localizedText: localizedText);
    var ref = BloqoPublishedCourse.getRef();
    var querySnapshot = await ref.where("original_course_id", isEqualTo: courseId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoPublishedCourse publishedCourse = docSnapshot.data();
    return publishedCourse;
  } on FirebaseException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<List<BloqoPublishedCourse>> getPublishedCoursesFromAuthorId({
  required var localizedText,
  required String authorId,
}) async {
  try {
    await checkConnectivity(localizedText: localizedText);
    var ref = BloqoPublishedCourse.getRef();
    var querySnapshot = await ref.where("author_id", isEqualTo: authorId).get();
    List<BloqoPublishedCourse> publishedCourses = [];
    for(var doc in querySnapshot.docs){
      publishedCourses.add(doc.data());
    }
    return publishedCourses;
  } on FirebaseException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> publishCourse({required var localizedText, required BloqoPublishedCourse publishedCourse}) async {
  try {
    await checkConnectivity(localizedText: localizedText);
    var ref = BloqoPublishedCourse.getRef();
    await ref.doc().set(publishedCourse);
  } on FirebaseException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<List<BloqoPublishedCourse>> getCoursesFromSearch({
  required var localizedText,
  required Query<Map<String, dynamic>>? query,
}) async {
  try {
    await checkConnectivity(localizedText: localizedText);
    if (query != null) {
      var querySnapshot = await query.get();

      List<BloqoPublishedCourse> courses = [];
      for (var doc in querySnapshot.docs) {
        courses.add(BloqoPublishedCourse.fromFirestore(doc, null));
      }

      return courses;
    } else {
      // Handle the case where no filters are applied or the query is null
      // FIXME: NON DOVREBBE MAI SUCCEDERE
      print("No filters applied or query is null"); // TODO: remove, used for debugging
      return [];
    }
  } on FirebaseException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }

}

Future<void> savePublishedCourseChanges({required var localizedText, required BloqoPublishedCourse updatedPublishedCourse}) async {
  try {
    var ref = BloqoPublishedCourse.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("published_course_id", isEqualTo: updatedPublishedCourse.publishedCourseId).get();
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedPublishedCourse.toFirestore());
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

Future<void> deletePublishedCourse({required var localizedText, required String publishedCourseId}) async {
  try {
    var ref = BloqoPublishedCourse.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("published_course_id", isEqualTo: publishedCourseId).get();
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