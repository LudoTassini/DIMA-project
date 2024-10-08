import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../utils/bloqo_exception.dart';
import '../../utils/uuid.dart';

class BloqoBlockData{

  final String id;
  final String superType;
  String? type;
  String name;
  int number;
  String content;

  BloqoBlockData({
    required this.id,
    required this.superType,
    this.type,
    required this.name,
    required this.number,
    required this.content
  });

  factory BloqoBlockData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ){
    final data = snapshot.data();
    return BloqoBlockData(
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

  static getRef({required FirebaseFirestore firestore}) {
    return firestore.collection("blocks").withConverter(
      fromFirestore: BloqoBlockData.fromFirestore,
      toFirestore: (BloqoBlockData block, _) => block.toFirestore(),
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

extension BloqoBlockTypeExtension on BloqoBlockType {
  String? multimediaShortText({required var localizedText}) {
    switch (this) {
      case BloqoBlockType.multimediaVideo:
        return localizedText.multimedia_video_short;
      case BloqoBlockType.multimediaImage:
        return localizedText.multimedia_image_short;
      case BloqoBlockType.multimediaAudio:
        return localizedText.multimedia_audio_short;
      default:
        return null;
    }
  }

  String? quizShortText({required var localizedText}) {
    switch (this) {
      case BloqoBlockType.quizMultipleChoice:
        return localizedText.quiz_multiple_choice_short;
      case BloqoBlockType.quizOpenQuestion:
        return localizedText.quiz_open_question_short;
      default:
        return null;
    }
  }

  static BloqoBlockType? fromString(String value) {
    return _enumMap[value];
  }

  static final Map<String, BloqoBlockType> _enumMap = {
    'BloqoBlockType.text': BloqoBlockType.text,
    'BloqoBlockType.multimediaAudio': BloqoBlockType.multimediaAudio,
    'BloqoBlockType.multimediaImage': BloqoBlockType.multimediaImage,
    'BloqoBlockType.multimediaVideo': BloqoBlockType.multimediaVideo,
    'BloqoBlockType.quizMultipleChoice': BloqoBlockType.quizMultipleChoice,
    'BloqoBlockType.quizOpenQuestion': BloqoBlockType.quizOpenQuestion,
  };

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

List<DropdownMenuEntry<String>> buildMultimediaTypesList({required var localizedText, bool withNone = true}) {
  final List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
  for (var entry in BloqoBlockType.values) {
    String? text = entry.multimediaShortText(localizedText: localizedText);
    if(text != null) {
      dropdownMenuEntries.add(DropdownMenuEntry<String>(
        value: entry.toString(),
        label: text,
        labelWidget: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 2, // Adjust the maxLines as needed
        ),
      ));
    }
  }
  dropdownMenuEntries.sort((a, b) => a.label.compareTo(b.label)); // sorts the list alphabetically

  if(withNone) {
    dropdownMenuEntries.insert(0, DropdownMenuEntry<String>(
      value: "None",
      label: localizedText.none,
      labelWidget: Text(
        localizedText.none,
        overflow: TextOverflow.ellipsis,
        maxLines: 2, // Adjust the maxLines as needed
      ),
    ));
  }

  return dropdownMenuEntries;
}

List<DropdownMenuEntry<String>> buildQuizTypesList({required var localizedText, bool withNone = true}) {
  final List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
  for (var entry in BloqoBlockType.values) {
    String? text = entry.quizShortText(localizedText: localizedText);
    if(text != null) {
      dropdownMenuEntries.add(DropdownMenuEntry<String>(
        value: entry.toString(),
        label: text,
        labelWidget: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 2, // Adjust the maxLines as needed
        ),
      ));
    }
  }
  dropdownMenuEntries.sort((a, b) => a.label.compareTo(b.label)); // sorts the list alphabetically

  if(withNone) {
    dropdownMenuEntries.insert(0, DropdownMenuEntry<String>(
      value: "None",
      label: localizedText.none,
      labelWidget: Text(
        localizedText.none,
        overflow: TextOverflow.ellipsis,
        maxLines: 2, // Adjust the maxLines as needed
      ),
    ));
  }

  return dropdownMenuEntries;
}

Future<List<BloqoBlockData>> getBlocksFromIds({
  required FirebaseFirestore firestore,
  required var localizedText,
  required List<dynamic> blockIds
}) async {
  try {
    var ref = BloqoBlockData.getRef(firestore: firestore);
    List<BloqoBlockData> blocks = [];
    for(String blockId in blockIds) {
      var querySnapshot = await ref.where("id", isEqualTo: blockId).get();
      BloqoBlockData block = querySnapshot.docs.first.data();
      blocks.add(block);
    }
    return blocks;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<BloqoBlockData> saveNewBlock({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoBlockSuperType blockSuperType,
  required int blockNumber
}) async {
  try {
    BloqoBlockData block = BloqoBlockData(
      id: uuid(),
      superType: blockSuperType.toString(),
      number: blockNumber,
      name: getNameBasedOnBlockSuperType(localizedText: localizedText, superType: blockSuperType),
      content: "",
    );
    var ref = BloqoBlockData.getRef(firestore: firestore);
    await ref.doc().set(block);
    return block;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteBlock({
  required FirebaseFirestore firestore,
  required FirebaseStorage storage,
  required var localizedText,
  required String courseId,
  required String blockId
}) async {
  try {
    var ref = BloqoBlockData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: blockId).get();
    BloqoBlockData blockToDelete = querySnapshot.docs[0].data();
    String? type = blockToDelete.type;
    await querySnapshot.docs[0].reference.delete();
    if(type != null) {
      if(type == BloqoBlockType.multimediaAudio.toString()){
        await deleteFile(storage: storage, localizedText: localizedText,
            filePath: 'audios/courses/$courseId/$blockId');
      }
      else if(type == BloqoBlockType.multimediaImage.toString()){
        await deleteFile(storage: storage, localizedText: localizedText,
            filePath: 'images/courses/$courseId/$blockId');
      }
      else if(type == BloqoBlockType.multimediaVideo.toString()) {
        if(!blockToDelete.content.startsWith("yt")) {
          await deleteFile(storage: storage, localizedText: localizedText,
              filePath: 'videos/courses/$courseId/$blockId');
        }
      }
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> reorderBlocks({
  required FirebaseFirestore firestore,
  required var localizedText,
  required List<dynamic> blockIds
}) async {
  var ref = BloqoBlockData.getRef(firestore: firestore);
  Map<String, BloqoBlockData> blocks = {};

  for (String blockId in blockIds) {
    var querySnapshot = await ref.where("id", isEqualTo: blockId).get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      BloqoBlockData block = doc.data();
      blocks[doc.id] = block;
    }
  }

  var sortedBlocks = blocks.entries.toList()
    ..sort((a, b) => a.value.number.compareTo(b.value.number));

  for (int i = 0; i < sortedBlocks.length; i++) {
    var documentId = sortedBlocks[i].key;
    var block = sortedBlocks[i].value;

    block.number = i + 1;
    await ref.doc(documentId).update({'number': block.number});
  }
}

Future<void> saveBlockChanges({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoBlockData updatedBlock
}) async {
  try {
    var ref = BloqoBlockData.getRef(firestore: firestore);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: updatedBlock.id).get();
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    await ref.doc(docSnapshot.id).update(updatedBlock.toFirestore());
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> saveBlockAudioUrl({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String blockId,
  required String audioUrl
}) async {
  try {
    var ref = BloqoBlockData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: blockId).get();
    if (querySnapshot.docs.isNotEmpty) {
      var documentId = querySnapshot.docs[0].id;
      await ref.doc(documentId).update({
        "content": audioUrl,
        "type": BloqoBlockType.multimediaAudio.toString(),
        "name": getNameBasedOnBlockType(localizedText: localizedText, type: BloqoBlockType.multimediaAudio)
      });
    } else {
      throw BloqoException(message: localizedText.generic_error);
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> saveBlockImageUrl({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String blockId,
  required String imageUrl
}) async {
  try {
    var ref = BloqoBlockData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: blockId).get();
    if (querySnapshot.docs.isNotEmpty) {
      var documentId = querySnapshot.docs[0].id;
      await ref.doc(documentId).update({
        "content": imageUrl,
        "type": BloqoBlockType.multimediaImage.toString(),
        "name": getNameBasedOnBlockType(localizedText: localizedText, type: BloqoBlockType.multimediaImage)
      });
    } else {
      throw BloqoException(message: localizedText.generic_error);
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> saveBlockVideoUrl({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String blockId,
  required String videoUrl
}) async {
  try {
    var ref = BloqoBlockData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: blockId).get();
    if (querySnapshot.docs.isNotEmpty) {
      var documentId = querySnapshot.docs[0].id;
      await ref.doc(documentId).update({
        "content": videoUrl,
        "type": BloqoBlockType.multimediaVideo.toString(),
        "name": getNameBasedOnBlockType(localizedText: localizedText, type: BloqoBlockType.multimediaVideo)
      });
    } else {
      throw BloqoException(message: localizedText.generic_error);
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> saveBlockMultipleChoiceQuiz({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String blockId,
  required String content
}) async {
  try {
    var ref = BloqoBlockData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: blockId).get();
    if (querySnapshot.docs.isNotEmpty) {
      var documentId = querySnapshot.docs[0].id;
      await ref.doc(documentId).update({
        "content": content,
        "type": BloqoBlockType.quizMultipleChoice.toString(),
        "name": getNameBasedOnBlockType(localizedText: localizedText, type: BloqoBlockType.quizMultipleChoice)
      });
    } else {
      throw BloqoException(message: localizedText.generic_error);
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> saveBlockOpenQuestionQuiz({
  required FirebaseFirestore firestore,
  required var localizedText,
  required String blockId,
  required String content
}) async {
  try {
    var ref = BloqoBlockData.getRef(firestore: firestore);
    var querySnapshot = await ref.where("id", isEqualTo: blockId).get();
    if (querySnapshot.docs.isNotEmpty) {
      var documentId = querySnapshot.docs[0].id;
      await ref.doc(documentId).update({
        "content": content,
        "type": BloqoBlockType.quizOpenQuestion.toString(),
        "name": getNameBasedOnBlockType(localizedText: localizedText, type: BloqoBlockType.quizOpenQuestion)
      });
    } else {
      throw BloqoException(message: localizedText.generic_error);
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteFile({required FirebaseStorage storage, required var localizedText, required String filePath}) async {
  try {
    final ref = storage.ref().child(filePath);
    await ref.delete();
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}