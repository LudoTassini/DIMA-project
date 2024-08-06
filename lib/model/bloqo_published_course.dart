import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/bloqo_exception.dart';
import '../utils/connectivity.dart';

class BloqoPublishedCourse{

  final String originalCourseId;
  final String courseName;
  final String authorUsername;
  final bool isPublic;
  final Timestamp publicationDate;
  final String language;
  final String modality;
  final String subject;
  final String duration;
  final String difficulty;
  final double? rating;

  BloqoPublishedCourse({
    required this.originalCourseId,
    required this.courseName,
    required this.authorUsername,
    required this.isPublic,
    required this.publicationDate,
    required this.language,
    required this.modality,
    required this.subject,
    required this.difficulty,
    required this.duration,
    this.rating
  });

  factory BloqoPublishedCourse.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ){
    final data = snapshot.data();
    return BloqoPublishedCourse(
      originalCourseId: data!["original_course_id"],
      courseName: data["course_name"],
      authorUsername: data["author_username"],
      isPublic: data["is_public"],
      publicationDate: data["publication_date"],
      language: data["language"],
      modality: data["modality"],
      subject: data["subject"],
      difficulty: data["difficulty"],
      duration: data["duration"],
      rating: (data["rating"] is int) ? (data["rating"] as int).toDouble() : data["rating"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "original_course_id": originalCourseId,
      "course_name": courseName,
      "author_username": authorUsername,
      "publication_date": publicationDate,
      "is_public": isPublic,
      "language": language,
      "modality": modality,
      "subject": subject,
      "difficulty": difficulty,
      "duration": duration,
      "rating": rating
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
        print(e.message);
        throw BloqoException(message: localizedText.generic_error);
    }
  }

}