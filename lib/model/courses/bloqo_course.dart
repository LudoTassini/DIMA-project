import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/bloqo_exception.dart';
import '../../utils/connectivity.dart';
import '../../utils/uuid.dart';

class BloqoCourse{

  final String id;
  String name;
  final String authorId;
  final bool published;
  final Timestamp creationDate;
  final List<dynamic> chapters;
  final List<dynamic> reviews;

  String? description;
  Timestamp? publicationDate;
  bool? public;

  int numberOfEnrollments = 0;
  int numberOfCompletions = 0;

  BloqoCourse({
    required this.id,
    required this.name,
    required this.authorId,
    required this.creationDate,
    required this.chapters,
    required this.reviews,
    this.description,
    this.published = false,
    this.publicationDate,
    this.public,
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
        description: data["description"],
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
      "description": description,
      "published": published,
      "creation_date": creationDate,
      "publication_date": publicationDate,
      "is_public": public,
      "chapters": chapters,
      "reviews": reviews,
      "number_of_enrollments": numberOfEnrollments,
      "number_of_completions": numberOfCompletions
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
      creationDate: Timestamp.now(),
      chapters: [],
      reviews: []
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

Future<void> deleteCourse({required var localizedText, required BloqoCourse course}) async {
  try {
    var ref = BloqoCourse.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: course.id).get();
    await querySnapshot.docs[0].reference.delete();
    List<BloqoChapter> chapters = await getChaptersFromIds(localizedText: localizedText, chapterIds: course.chapters);
    for(BloqoChapter chapter in chapters){
      await deleteChapter(localizedText: localizedText, chapter: chapter);
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> deleteChapterFromCourse({required var localizedText, required String courseId, required String chapterId}) async {
  try {
    var ref = BloqoCourse.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("id", isEqualTo: courseId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoCourse course = docSnapshot.data();
    course.chapters.remove(chapterId);
    await ref.doc(docSnapshot.id).update(course.toFirestore());
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> saveCourseChanges({required var localizedText, required BloqoCourse updatedCourse}) async {
  try {
    var ref = BloqoCourse.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: updatedCourse.id).get();
    if (querySnapshot.docs.isEmpty) {
      throw BloqoException(message: localizedText.course_not_found);
    }
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedCourse.toFirestore());
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