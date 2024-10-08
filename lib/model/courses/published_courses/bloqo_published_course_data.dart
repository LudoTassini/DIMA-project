import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/bloqo_exception.dart';

class BloqoPublishedCourseData {
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
  late double rating;

  int numberOfEnrollments;
  int numberOfCompletions;

  BloqoPublishedCourseData({
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

  factory BloqoPublishedCourseData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data()!;
    return BloqoPublishedCourseData(
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

  static getRef({required FirebaseFirestore firestore}) {
    return firestore.collection("published_courses").withConverter(
      fromFirestore: BloqoPublishedCourseData.fromFirestore,
      toFirestore: (BloqoPublishedCourseData course, _) => course.toFirestore(),
    );
  }
}

Future<BloqoPublishedCourseData> getPublishedCourseFromPublishedCourseId({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String publishedCourseId
}) async {
  try {
    var ref = BloqoPublishedCourseData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("published_course_id", isEqualTo: publishedCourseId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoPublishedCourseData publishedCourse = docSnapshot.data();
    return publishedCourse;
  }
  on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<BloqoPublishedCourseData> getPublishedCourseFromCourseId({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId
}) async {
  try {
    var ref = BloqoPublishedCourseData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("original_course_id", isEqualTo: courseId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoPublishedCourseData publishedCourse = docSnapshot.data();
    return publishedCourse;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<List<BloqoPublishedCourseData>> getPublishedCoursesFromAuthorId({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String authorId,
}) async {
  try {
    var ref = BloqoPublishedCourseData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("author_id", isEqualTo: authorId).get();
    List<BloqoPublishedCourseData> publishedCourses = [];
    for(var doc in querySnapshot.docs){
      publishedCourses.add(doc.data());
    }
    return publishedCourses;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> publishCourse({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoPublishedCourseData publishedCourse
}) async {
  try {
    var ref = BloqoPublishedCourseData.getRef(firestore: firestore);
    await ref.doc().set(publishedCourse);
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> addReviewToPublishedCourse({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String reviewId,
  required String publishedCourseId,
  required double newRating
}) async {
  try {
    var ref = BloqoPublishedCourseData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("published_course_id", isEqualTo: publishedCourseId).get();
    var docSnapshot = querySnapshot.docs.first;

    BloqoPublishedCourseData updatedCourse = docSnapshot.data();
    updatedCourse.reviews.add(reviewId);
    updatedCourse.rating = newRating;

    await ref.doc(docSnapshot.id).update(updatedCourse.toFirestore());

  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<List<BloqoPublishedCourseData>> getCoursesFromSearch({
  required FirebaseFirestore firestore,
  required var localizedText,
  required Query<Map<String, dynamic>>? query,
}) async {
  try {
    if (query != null) {
      var querySnapshot = await query.get();

      List<BloqoPublishedCourseData> courses = [];
      for (var doc in querySnapshot.docs) {
        courses.add(BloqoPublishedCourseData.fromFirestore(doc, null));
      }

      return courses;
    } else {
      return [];
    }
  } on FirebaseException catch (e) {
    if (e.code == 'failed-precondition') {
      if (kDebugMode) {
        print(e);
      }
    }
    throw BloqoException(message: localizedText.sort_error);
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }

}

Future<void> savePublishedCourseChanges({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoPublishedCourseData updatedPublishedCourse
}) async {
  try {
    var ref = BloqoPublishedCourseData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("published_course_id", isEqualTo: updatedPublishedCourse.publishedCourseId).get();
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedPublishedCourse.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deletePublishedCourse({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String publishedCourseId
}) async {
  try {
    var ref = BloqoPublishedCourseData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("published_course_id", isEqualTo: publishedCourseId).get();
    await querySnapshot.docs[0].reference.delete();
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}