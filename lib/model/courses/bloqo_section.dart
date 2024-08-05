import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/bloqo_exception.dart';
import '../../utils/connectivity.dart';
import '../../utils/uuid.dart';
import 'bloqo_block.dart';

class BloqoSection{

  final String id;
  int number;
  String name;

  List<dynamic> blocks;

  BloqoSection({
    required this.id,
    required this.number,
    required this.name,
    required this.blocks
  });

  factory BloqoSection.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ){
    final data = snapshot.data();
    return BloqoSection(
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

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("sections").withConverter(
      fromFirestore: BloqoSection.fromFirestore,
      toFirestore: (BloqoSection section, _) => section.toFirestore(),
    );
  }

}

Future<List<BloqoSection>> getSectionsFromIds({required var localizedText, required List<dynamic> sectionIds}) async {
  try {
    var ref = BloqoSection.getRef();
    List<BloqoSection> sections = [];
    for(String sectionId in sectionIds) {
      await checkConnectivity(localizedText: localizedText);
      var querySnapshot = await ref.where("id", isEqualTo: sectionId).get();
      BloqoSection section = querySnapshot.docs.first.data();
      sections.add(section);
    }
    return sections;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<BloqoSection> saveNewSection({required var localizedText, required int sectionNumber}) async {
  try {
    BloqoSection section = BloqoSection(
      id: uuid(),
      number: sectionNumber,
      name: "${localizedText.section} $sectionNumber",
      blocks: [],
    );
    var ref = BloqoSection.getRef();
    await checkConnectivity(localizedText: localizedText);
    await ref.doc().set(section);
    return section;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> deleteSection({required var localizedText, required BloqoSection section, required String courseId}) async {
  try {
    var ref = BloqoSection.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: section.id).get();
    await querySnapshot.docs[0].reference.delete();
    for(String blockId in section.blocks){
      await deleteBlock(localizedText: localizedText, courseId: courseId, blockId: blockId);
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

Future<void> reorderSections({required var localizedText, required List<dynamic> sectionIds}) async {
  var ref = BloqoSection.getRef();
  Map<String, BloqoSection> sections = {};

  for (String sectionId in sectionIds) {
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("id", isEqualTo: sectionId).get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      BloqoSection section = doc.data();
      sections[doc.id] = section;
    }
  }

  var sortedSections = sections.entries.toList()
    ..sort((a, b) => a.value.number.compareTo(b.value.number));

  for (int i = 0; i < sortedSections.length; i++) {
    var documentId = sortedSections[i].key;
    var section = sortedSections[i].value;

    section.number = i + 1;
    await checkConnectivity(localizedText: localizedText);
    await ref.doc(documentId).update({'number': section.number});
  }
}

Future<void> saveSectionChanges({required var localizedText, required BloqoSection updatedSection}) async {
  try {
    var ref = BloqoSection.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: updatedSection.id).get();
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedSection.toFirestore());
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

Future<void> deleteBlockFromSection({required var localizedText, required String sectionId, required String blockId}) async {
  try {
    var ref = BloqoSection.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("id", isEqualTo: sectionId).get();
    var docSnapshot = querySnapshot.docs.first;
    BloqoSection section = docSnapshot.data();
    section.blocks.remove(blockId);
    await ref.doc(docSnapshot.id).update(section.toFirestore());
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}