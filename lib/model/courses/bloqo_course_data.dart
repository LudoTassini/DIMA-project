import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../utils/bloqo_exception.dart';
import '../../utils/uuid.dart';

class BloqoCourseData{

  final String id;
  String name;
  final String authorId;
  bool published;
  final Timestamp creationDate;
  final List<dynamic> chapters;

  String? description;
  Timestamp? publicationDate;

  BloqoCourseData({
    required this.id,
    required this.name,
    required this.authorId,
    required this.creationDate,
    required this.chapters,
    this.description,
    this.published = false,
    this.publicationDate,
  });

  factory BloqoCourseData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ){
    final data = snapshot.data();
    return BloqoCourseData(
      id: data!["id"],
      name: data["name"],
      authorId: data["author_id"],
      description: data["description"],
      published: data["published"],
      creationDate: data["creation_date"],
      publicationDate: data["publication_date"],
      chapters: data["chapters"],
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
      "chapters": chapters
    };
  }

  static getRef({required FirebaseFirestore firestore}) {
    return firestore.collection("courses").withConverter(
      fromFirestore: BloqoCourseData.fromFirestore,
      toFirestore: (BloqoCourseData course, _) => course.toFirestore(),
    );
  }

}

Future<BloqoCourseData> saveNewCourse({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String authorId
}) async {
  try {
    BloqoCourseData course = BloqoCourseData(
      id: uuid(),
      name: localizedText.course,
      authorId: authorId,
      creationDate: Timestamp.now(),
      chapters: [],
    );
    var ref = BloqoCourseData.getRef(firestore: firestore);
    await ref.doc().set(course);
    return course;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<BloqoCourseData> getCourseFromId({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId
}) async {
  try {
    var ref = BloqoCourseData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: courseId).get();
    BloqoCourseData course = querySnapshot.docs.first.data();
    return course;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteCourse({
  required FirebaseFirestore firestore,
  required FirebaseStorage storage,
  required var localizedText,
  required BloqoCourseData course
}) async {
  try {
    var ref = BloqoCourseData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: course.id).get();
    await querySnapshot.docs[0].reference.delete();
    List<BloqoChapterData> chapters = await getChaptersFromIds(firestore: firestore, localizedText: localizedText, chapterIds: course.chapters);
    for(BloqoChapterData chapter in chapters){
      await deleteChapter(firestore: firestore, storage: storage, localizedText: localizedText, chapter: chapter, courseId: course.id);
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteChapterFromCourse({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId,
  required String chapterId
}) async {
  try {
    var ref = BloqoCourseData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: courseId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoCourseData course = docSnapshot.data();
    course.chapters.remove(chapterId);
    await ref.doc(docSnapshot.id).update(course.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> saveCourseChanges({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoCourseData updatedCourse
}) async {
  try {
    var ref = BloqoCourseData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: updatedCourse.id).get();
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedCourse.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> updateCourseStatus({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String courseId,
  required bool published
}) async {
  try {
    var ref = BloqoCourseData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: courseId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoCourseData course = docSnapshot.data();
    course.published = published;
    course.publicationDate = Timestamp.now();
    await ref.doc(docSnapshot.id).update(course.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}