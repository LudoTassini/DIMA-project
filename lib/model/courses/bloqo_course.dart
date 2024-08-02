import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/bloqo_exception.dart';
import '../../utils/connectivity.dart';
import '../../utils/uuid.dart';
import '../bloqo_review.dart';
import 'bloqo_chapter.dart';

class BloqoCourse{

  final String id;
  final String name;
  final String authorId;
  final bool published;

  Timestamp? creationDate;
  Timestamp? publicationDate;
  bool? public;

  List<BloqoChapter>? chapters;

  List<BloqoReview>? reviews;

  int numberOfEnrollments = 0;
  int numberOfCompletions = 0;

  BloqoCourse({
    required this.id,
    required this.name,
    required this.authorId,
    this.published = false,
    this.creationDate,
    this.publicationDate,
    this.public,
    this.chapters,
    this.reviews,
    this.numberOfEnrollments = 0,
    this.numberOfCompletions = 0,
  });

  factory BloqoCourse.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ){
    final data = snapshot.data();
    return BloqoCourse(
        id: data!["id"],
        name: data["name"],
        authorId: data["author_id"],
        published: data["published"],
        creationDate: data["creation_date"],
        publicationDate: data["publication_date"],
        public: data["is_public"],
        chapters: data["chapters"],
        reviews: data["reviews"],
        numberOfEnrollments: data["number_of_enrollments"],
        numberOfCompletions: data["number_of_completions"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "author_id": authorId,
      "published": published,
      "creation_date": creationDate,
      "publication_date": publicationDate,
      "is_public": public,
      "chapters": chapters,
      "reviews": reviews,
      "number_of_enrollments": numberOfEnrollments,
      "number_of_completions": numberOfCompletions,
    };
  }

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("courses").withConverter(
      fromFirestore: BloqoCourse.fromFirestore,
      toFirestore: (BloqoCourse course, _) => course.toFirestore(),
    );
  }

}

Future<BloqoCourse> saveNewCourse({required var localizedText, required String authorId}) async {
  try {
    BloqoCourse course = BloqoCourse(
      id: uuid(),
      name: DateTime.now().toString(),
      authorId: authorId,
    );
    var ref = BloqoCourse.getRef();
    await checkConnectivity(localizedText: localizedText);
    await ref.doc().set(course);
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

Future<BloqoCourse> getCourseFromId({required var localizedText, required String courseId}) async {
  try {
    var ref = BloqoCourse.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("id", isEqualTo: courseId).get();
    BloqoCourse course = querySnapshot.docs.first.data();
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

Future<void> deleteCourse({required var localizedText, required String courseId}) async {
  try {
    var ref = BloqoCourse.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: courseId).get();
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