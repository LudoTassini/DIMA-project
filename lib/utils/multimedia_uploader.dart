import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../model/bloqo_user.dart';
import '../model/courses/bloqo_block.dart';
import 'bloqo_exception.dart';
import 'connectivity.dart';

Future<String> uploadProfilePicture({required var localizedText, required File image, required String userId}) async {

  await checkConnectivity(localizedText: localizedText);

  final destination = 'images/users/$userId';

  try {

    final refStorage = FirebaseStorage.instance.ref(destination);
    await refStorage.putFile(image);
    final url = await refStorage.getDownloadURL();

    await saveProfilePictureUrl(localizedText: localizedText, userId: userId, pictureUrl: url);

    return url;
  } catch (e) {
    throw BloqoException(
      message: localizedText.generic_error
    );
  }

}

Future<String> uploadBlockImage({required var localizedText, required File image, required String courseId, required String blockId}) async {

  await checkConnectivity(localizedText: localizedText);

  final destination = 'images/courses/$courseId/$blockId';

  try {
    final refStorage = FirebaseStorage.instance.ref(destination);
    await refStorage.putFile(image);
    final url = await refStorage.getDownloadURL();

    await saveBlockImageUrl(localizedText: localizedText, blockId: blockId, imageUrl: url);

    return url;
  } catch (e) {
    throw BloqoException(
        message: localizedText.generic_error
    );
  }
}

Future<String> uploadBlockVideo({required var localizedText, required File video, required String courseId, required String blockId}) async {

  await checkConnectivity(localizedText: localizedText);

  final destination = 'videos/courses/$courseId/$blockId';

  try {
    final refStorage = FirebaseStorage.instance.ref(destination);
    await refStorage.putFile(video);
    final url = await refStorage.getDownloadURL();

    await saveBlockVideoUrl(localizedText: localizedText, blockId: blockId, videoUrl: url);

    return url;
  } catch (e) {
    throw BloqoException(
        message: localizedText.generic_error
    );
  }
}