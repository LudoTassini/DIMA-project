import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../utils/bloqo_exception.dart';
import '../../utils/uuid.dart';

class BloqoChapterData{

  final String id;
  int number;
  String name;

  String? description;
  List<dynamic> sections;

  BloqoChapterData({
    required this.id,
    required this.number,
    required this.name,
    required this.sections,
    this.description
  });

  factory BloqoChapterData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ){
    final data = snapshot.data();
    return BloqoChapterData(
      id: data!["id"],
      number: data["number"],
      name: data["name"],
      description: data["description"],
      sections: data["sections"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "number": number,
      "name": name,
      "description": description,
      "sections": sections
    };
  }

  static getRef({required FirebaseFirestore firestore}) {
    return firestore.collection("chapters").withConverter(
      fromFirestore: BloqoChapterData.fromFirestore,
      toFirestore: (BloqoChapterData chapter, _) => chapter.toFirestore(),
    );
  }

}

Future<BloqoChapterData> saveNewChapter({
  required FirebaseFirestore firestore,
  required var localizedText,
  required int chapterNumber
}) async {
  try {
    BloqoChapterData chapter = BloqoChapterData(
        id: uuid(),
        number: chapterNumber,
        name: "${localizedText.chapter} $chapterNumber",
        sections: [],
    );
    var ref = BloqoChapterData.getRef(firestore: firestore);
    await ref.doc().set(chapter);
    return chapter;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<List<BloqoChapterData>> getChaptersFromIds({
  required FirebaseFirestore firestore,
  required var localizedText,
  required List<dynamic> chapterIds
}) async {
  try {
    var ref = BloqoChapterData.getRef(firestore: firestore);
    List<BloqoChapterData> chapters = [];
    for(String chapterId in chapterIds) {
      var querySnapshot = await ref.where("id", isEqualTo: chapterId).get();
      BloqoChapterData chapter = querySnapshot.docs.first.data();
      chapters.add(chapter);
    }
    return chapters;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteChapter({
  required FirebaseFirestore firestore,
  required FirebaseStorage storage,
  required var localizedText,
  required BloqoChapterData chapter,
  required String courseId
}) async {
  try {
    var ref = BloqoChapterData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: chapter.id).get();
    await querySnapshot.docs[0].reference.delete();
    List<BloqoSectionData> sections = await getSectionsFromIds(firestore: firestore, localizedText: localizedText, sectionIds: chapter.sections);
    for(BloqoSectionData section in sections){
      await deleteSection(firestore: firestore, storage: storage, localizedText: localizedText, section: section, courseId: courseId);
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> reorderChapters({
  required FirebaseFirestore firestore,
  required var localizedText,
  required List<dynamic> chapterIds
}) async {
  var ref = BloqoChapterData.getRef(firestore: firestore);
  Map<String, BloqoChapterData> chapters = {};

  for (String chapterId in chapterIds) {
    var querySnapshot = await ref.where("id", isEqualTo: chapterId).get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      BloqoChapterData chapter = doc.data();
      chapters[doc.id] = chapter;
    }
  }

  var sortedChapters = chapters.entries.toList()
    ..sort((a, b) => a.value.number.compareTo(b.value.number));

  for (int i = 0; i < sortedChapters.length; i++) {
    var documentId = sortedChapters[i].key;
    var chapter = sortedChapters[i].value;

    chapter.number = i + 1;
    await ref.doc(documentId).update({'number': chapter.number});
  }
}

Future<void> saveChapterChanges({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoChapterData updatedChapter
}) async {
  try {
    var ref = BloqoChapterData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: updatedChapter.id).get();
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedChapter.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteSectionFromChapter({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String chapterId,
  required String sectionId
}) async {
  try {
    var ref = BloqoChapterData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: chapterId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoChapterData chapter = docSnapshot.data();
    chapter.sections.remove(sectionId);
    await ref.doc(docSnapshot.id).update(chapter.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}