import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../utils/bloqo_exception.dart';
import '../../utils/uuid.dart';
import 'bloqo_block_data.dart';

class BloqoSectionData{

  final String id;
  int number;
  String name;

  List<dynamic> blocks;

  BloqoSectionData({
    required this.id,
    required this.number,
    required this.name,
    required this.blocks
  });

  factory BloqoSectionData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ){
    final data = snapshot.data();
    return BloqoSectionData(
        id: data!["id"],
        number: data["number"],
        name: data["name"],
        blocks: data["blocks"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "number": number,
      "name": name,
      "blocks": blocks
    };
  }

  static getRef({required FirebaseFirestore firestore}) {
    return firestore.collection("sections").withConverter(
      fromFirestore: BloqoSectionData.fromFirestore,
      toFirestore: (BloqoSectionData section, _) => section.toFirestore(),
    );
  }

}

Future<List<BloqoSectionData>> getSectionsFromIds({
  required FirebaseFirestore firestore,
  required var localizedText,
  required List<dynamic> sectionIds
}) async {
  try {
    var ref = BloqoSectionData.getRef(firestore: firestore);
    List<BloqoSectionData> sections = [];
    for(String sectionId in sectionIds) {
      var querySnapshot = await ref.where("id", isEqualTo: sectionId).get();
      BloqoSectionData section = querySnapshot.docs.first.data();
      sections.add(section);
    }
    return sections;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<BloqoSectionData> getSectionFromId({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String sectionId
}) async {
  try {
    var ref = BloqoSectionData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: sectionId).get();
    BloqoSectionData section = querySnapshot.docs.first.data();
    return section;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<BloqoSectionData> saveNewSection({
  required FirebaseFirestore firestore,
  required var localizedText,
  required int sectionNumber
}) async {
  try {
    BloqoSectionData section = BloqoSectionData(
      id: uuid(),
      number: sectionNumber,
      name: "${localizedText.section} $sectionNumber",
      blocks: [],
    );
    var ref = BloqoSectionData.getRef(firestore: firestore);
    await ref.doc().set(section);
    return section;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteSection({
  required FirebaseFirestore firestore,
  required FirebaseStorage storage,
  required var localizedText,
  required BloqoSectionData section,
  required String courseId
}) async {
  try {
    var ref = BloqoSectionData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: section.id).get();
    await querySnapshot.docs[0].reference.delete();
    for(String blockId in section.blocks){
      await deleteBlock(firestore: firestore, storage: storage, localizedText: localizedText, courseId: courseId, blockId: blockId);
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> reorderSections({
  required FirebaseFirestore firestore,
  required var localizedText,
  required List<dynamic> sectionIds
}) async {
  var ref = BloqoSectionData.getRef(firestore: firestore);
  Map<String, BloqoSectionData> sections = {};

  for (String sectionId in sectionIds) {
    var querySnapshot = await ref.where("id", isEqualTo: sectionId).get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      BloqoSectionData section = doc.data();
      sections[doc.id] = section;
    }
  }

  var sortedSections = sections.entries.toList()
    ..sort((a, b) => a.value.number.compareTo(b.value.number));

  for (int i = 0; i < sortedSections.length; i++) {
    var documentId = sortedSections[i].key;
    var section = sortedSections[i].value;

    section.number = i + 1;
    await ref.doc(documentId).update({'number': section.number});
  }
}

Future<void> saveSectionChanges({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoSectionData updatedSection
}) async {
  try {
    var ref = BloqoSectionData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: updatedSection.id).get();
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedSection.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteBlockFromSection({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String sectionId,
  required String blockId
}) async {
  try {
    var ref = BloqoSectionData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: sectionId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoSectionData section = docSnapshot.data();
    section.blocks.remove(blockId);
    await ref.doc(docSnapshot.id).update(section.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}