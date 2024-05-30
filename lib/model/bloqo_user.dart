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

  BloqoUser({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.isFullNameVisible,
    required this.followers,
    required this.following
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
      following: data["following"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "email": email,
      "username": username,
      "full_name": fullName,
      "is_full_name_visible": isFullNameVisible,
      "followers": followers,
      "following": following
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

Future<BloqoUser> getUserFromEmail({required var localizedText, required String email}) async {
  try {
    var ref = BloqoUser.getRef();
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

Future<bool> isUsernameAlreadyTaken({required var localizedText, required String username}) async {
  try {
    var ref = BloqoUser.getRef();
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