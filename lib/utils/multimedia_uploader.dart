import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/bloqo_user_data.dart';
import '../model/courses/bloqo_block_data.dart';
import 'bloqo_exception.dart';

Future<String> uploadProfilePicture({
  required FirebaseFirestore firestore,
  required FirebaseStorage storage,
  required var localizedText,
  required File image,
  required String userId
}) async {

  final destination = 'images/users/$userId';

  try {

    final refStorage = storage.ref(destination);
    await refStorage.putFile(image);
    final url = await refStorage.getDownloadURL();

    await saveProfilePictureUrl(firestore: firestore, localizedText: localizedText, userId: userId, pictureUrl: url);

    return url;
  } catch (e) {
    throw BloqoException(
      message: localizedText.generic_error
    );
  }

}

Future<String> uploadBlockAudio({
  required FirebaseFirestore firestore,
  required FirebaseStorage storage,
  required var localizedText,
  required File audio,
  required String courseId,
  required String blockId
}) async {

  final destination = 'audios/courses/$courseId/$blockId';

  try {
    final refStorage = storage.ref(destination);
    await refStorage.putFile(audio);
    final url = await refStorage.getDownloadURL();

    await saveBlockAudioUrl(firestore: firestore, localizedText: localizedText, blockId: blockId, audioUrl: url);

    return url;
  } catch (e) {
    throw BloqoException(
        message: localizedText.generic_error
    );
  }
}

Future<String> uploadBlockImage({
  required FirebaseFirestore firestore,
  required FirebaseStorage storage,
  required var localizedText,
  required File image,
  required String courseId,
  required String blockId
}) async {

  final destination = 'images/courses/$courseId/$blockId';

  try {
    final refStorage = storage.ref(destination);
    await refStorage.putFile(image);
    final url = await refStorage.getDownloadURL();

    await saveBlockImageUrl(firestore: firestore, localizedText: localizedText, blockId: blockId, imageUrl: url);

    return url;
  } catch (e) {
    throw BloqoException(
        message: localizedText.generic_error
    );
  }
}

Future<String> uploadBlockVideo({
  required FirebaseFirestore firestore,
  required FirebaseStorage storage,
  required var localizedText,
  required File video,
  required String courseId,
  required String blockId
}) async {

  final destination = 'videos/courses/$courseId/$blockId';

  try {
    final refStorage = storage.ref(destination);
    await refStorage.putFile(video);
    final url = await refStorage.getDownloadURL();

    await saveBlockVideoUrl(firestore: firestore, localizedText: localizedText, blockId: blockId, videoUrl: url);

    return url;
  } catch (e) {
    throw BloqoException(
        message: localizedText.generic_error
    );
  }
}