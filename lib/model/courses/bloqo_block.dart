import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/bloqo_exception.dart';
import '../../utils/connectivity.dart';
import '../../utils/uuid.dart';

class BloqoBlock{

  final String id;
  final String superType;
  String? type;
  String name;
  int number;
  String? content;

  BloqoBlock({
    required this.id,
    required this.superType,
    this.type,
    required this.name,
    required this.number,
    this.content
  });

  factory BloqoBlock.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ){
    final data = snapshot.data();
    return BloqoBlock(
        id: data!["id"],
        superType: data["super_type"],
        type: data["type"],
        name: data["name"],
        number: data["number"],
        content: data["content"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "super_type": superType,
      "type": type,
      "name": name,
      "number": number,
      "content": content
    };
  }

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("blocks").withConverter(
      fromFirestore: BloqoBlock.fromFirestore,
      toFirestore: (BloqoBlock block, _) => block.toFirestore(),
    );
  }

}

enum BloqoBlockType{
  text,
  multimediaVideo,
  multimediaImage,
  multimediaAudio,
  quizMultipleChoice,
  quizOpenQuestion
}

enum BloqoBlockSuperType{
  text,
  multimedia,
  quiz
}

extension BloqoBlockSuperTypeExtension on BloqoBlockSuperType {
  static BloqoBlockSuperType? fromString(String value) {
    return _enumMap[value];
  }

  static final Map<String, BloqoBlockSuperType> _enumMap = {
    'BloqoBlockSuperType.text': BloqoBlockSuperType.text,
    'BloqoBlockSuperType.multimedia': BloqoBlockSuperType.multimedia,
    'BloqoBlockSuperType.quiz': BloqoBlockSuperType.quiz,
  };
}

String getNameBasedOnBlockType({required var localizedText, required BloqoBlockType type}){
  switch(type){
    case BloqoBlockType.text:
      return localizedText.text;
    case BloqoBlockType.multimediaVideo:
      return localizedText.multimedia_video;
    case BloqoBlockType.multimediaImage:
      return localizedText.multimedia_image;
    case BloqoBlockType.multimediaAudio:
      return localizedText.multimedia_audio;
    case BloqoBlockType.quizMultipleChoice:
      return localizedText.quiz_multiple_choice;
    case BloqoBlockType.quizOpenQuestion:
      return localizedText.quiz_open_question;
  }
}

String getNameBasedOnBlockSuperType({required var localizedText, required BloqoBlockSuperType superType}){
  switch(superType){
    case BloqoBlockSuperType.text:
      return localizedText.text;
    case BloqoBlockSuperType.multimedia:
      return localizedText.multimedia;
    case BloqoBlockSuperType.quiz:
      return localizedText.quiz;
  }
}

Future<List<BloqoBlock>> getBlocksFromIds({required var localizedText, required List<dynamic> blockIds}) async {
  try {
    var ref = BloqoBlock.getRef();
    List<BloqoBlock> blocks = [];
    for(String blockId in blockIds) {
      await checkConnectivity(localizedText: localizedText);
      var querySnapshot = await ref.where("id", isEqualTo: blockId).get();
      BloqoBlock block = querySnapshot.docs.first.data();
      blocks.add(block);
    }
    return blocks;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<BloqoBlock> saveNewBlock({required var localizedText, required BloqoBlockSuperType blockSuperType, required int blockNumber}) async {
  try {
    BloqoBlock block = BloqoBlock(
      id: uuid(),
      superType: blockSuperType.toString(),
      number: blockNumber,
      name: getNameBasedOnBlockSuperType(localizedText: localizedText, superType: blockSuperType),
      content: "",
    );
    var ref = BloqoBlock.getRef();
    await checkConnectivity(localizedText: localizedText);
    await ref.doc().set(block);
    return block;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> deleteBlock({required var localizedText, required String blockId}) async {
  try {
    var ref = BloqoBlock.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: blockId).get();
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

Future<void> reorderBlocks({required var localizedText, required List<dynamic> blockIds}) async {
  var ref = BloqoBlock.getRef();
  Map<String, BloqoBlock> blocks = {};

  for (String blockId in blockIds) {
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("id", isEqualTo: blockId).get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      BloqoBlock block = doc.data();
      blocks[doc.id] = block;
    }
  }

  var sortedBlocks = blocks.entries.toList()
    ..sort((a, b) => a.value.number.compareTo(b.value.number));

  for (int i = 0; i < sortedBlocks.length; i++) {
    var documentId = sortedBlocks[i].key;
    var block = sortedBlocks[i].value;

    block.number = i + 1;
    await checkConnectivity(localizedText: localizedText);
    await ref.doc(documentId).update({'number': block.number});
  }
}

Future<void> saveBlockChanges({required var localizedText, required BloqoBlock updatedBlock}) async {
  try {
    var ref = BloqoBlock.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: updatedBlock.id).get();
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedBlock.toFirestore());
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