import 'package:bloqo/utils/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';

class BloqoUser{
  late String id;
  late String email;
  late String username;
  late String fullName;
  late bool isFullNameVisible;
  late int followers;
  late int following;
  late String pictureUrl;

  BloqoUser({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.isFullNameVisible,
    required this.followers,
    required this.following,
    required this.pictureUrl
  });

  factory BloqoUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    return BloqoUser(
      id: data!["id"],
      email: data["email"],
      username: data["username"],
      fullName: data["full_name"],
      isFullNameVisible: data["is_full_name_visible"],
      followers: data["followers"],
      following: data["following"],
      pictureUrl: data["picture_url"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id ,
      "email": email,
      "username": username,
      "full_name": fullName,
      "is_full_name_visible": isFullNameVisible,
      "followers": followers,
      "following": following,
      "picture_url": pictureUrl
    };
  }

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("users").withConverter(
      fromFirestore: BloqoUser.fromFirestore,
      toFirestore: (BloqoUser user, _) => user.toFirestore(),
    );
  }

}

Future<void> registerNewUser({required var localizedText, required BloqoUser user, required String password}) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email, password: password);
    var ref = BloqoUser.getRef();
    await ref.doc().set(user);
  } on FirebaseAuthException catch (e) {
    switch(e.code){
      case "email-already-in-use":
        throw BloqoException(message: localizedText.register_email_already_taken);
      case "network-request-failed":
        throw BloqoException(message: localizedText.register_network_error);
      default:
        throw BloqoException(message: localizedText.register_error);
    }
  }
}

Future<BloqoUser> getUserFromEmail({required var localizedText, required String email}) async {
  try {
    var ref = BloqoUser.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("email", isEqualTo: email).get();
    BloqoUser user = querySnapshot.docs.first.data();
    return user;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> saveProfilePictureUrl({
  required var localizedText,
  required String userId,
  required String pictureUrl,
}) async {
  try {
    var ref = BloqoUser.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("id", isEqualTo: userId).get();
    if (querySnapshot.docs.isNotEmpty) {
      var documentId = querySnapshot.docs[0].id;
      await ref.doc(documentId).update({
        "picture_url": pictureUrl,
      });
    } else {
      throw BloqoException(message: localizedText.generic_error);
    }
  } on FirebaseException catch (e) {
    if (e.code == "unavailable" || e.code == "network-request-failed") {
      throw BloqoException(message: localizedText.network_error);
    } else {
      throw BloqoException(message: localizedText.generic_error);
    }
  }
}


Future<bool> isUsernameAlreadyTaken({required var localizedText, required String username}) async {
  try {
    var ref = BloqoUser.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("username", isEqualTo: username).get();
    if (querySnapshot.docs.length != 0) {
      return true;
    }
    else {
      return false;
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