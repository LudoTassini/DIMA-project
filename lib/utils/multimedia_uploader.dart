import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../model/bloqo_user.dart';
import 'bloqo_exception.dart';
import 'connectivity.dart';

Future<String> uploadImage({required var localizedText, required File image, required String userId}) async {

  await checkConnectivity(localizedText: localizedText);

  final destination = 'images/users/$userId';

  try {

    final refStorage = FirebaseStorage.instance.ref(destination);
    await refStorage.putFile(image);
    final url = await refStorage.getDownloadURL();

    await saveUserPictureUrl(localizedText: localizedText, userId: userId, pictureUrl: url);

    return url;
  } catch (e) {
    throw BloqoException(
      message: localizedText.generic_error
    );
  }

}