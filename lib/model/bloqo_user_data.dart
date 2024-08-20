import 'package:bloqo/utils/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';

class BloqoUserData{
  late String id;
  late String email;
  late String username;
  late String fullName;
  late bool isFullNameVisible;
  late String pictureUrl;
  late List<dynamic> followers;
  late List<dynamic> following;

  BloqoUserData({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.isFullNameVisible,
    required this.pictureUrl,
    required this.followers,
    required this.following
  });

  factory BloqoUserData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    return BloqoUserData(
      id: data!["id"],
      email: data["email"],
      username: data["username"],
      fullName: data["full_name"],
      isFullNameVisible: data["is_full_name_visible"],
      followers: data["followers"],
      following: data["following"],
      pictureUrl: data["picture_url"],
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
      fromFirestore: BloqoUserData.fromFirestore,
      toFirestore: (BloqoUserData user, _) => user.toFirestore(),
    );
  }

}

Future<void> registerNewUser({required var localizedText, required BloqoUserData user, required String password}) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email, password: password);
    var ref = BloqoUserData.getRef();
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

Future<BloqoUserData> getUserFromEmail({required var localizedText, required String email}) async {
  try {
    var ref = BloqoUserData.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("email", isEqualTo: email).get();
    BloqoUserData user = querySnapshot.docs.first.data();
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

Future<List<BloqoUserData>> getUsersFromUserIds({required var localizedText, required List<dynamic> userIds}) async {
  try {
    List<BloqoUserData> users = [];
    for(String userId in userIds){
      BloqoUserData user = await getUserFromId(localizedText: localizedText, id: userId);
      users.add(user);
    }
    return users;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> followUser({required var localizedText, required String userToFollowId, required String myUserId}) async {
  try {
    var ref = BloqoUserData.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("id", isEqualTo: userToFollowId).get();
    BloqoUserData userToFollow = querySnapshot.docs.first.data();
    userToFollow.followers.add(myUserId);
    await ref.doc(querySnapshot.docs.first.id).update(userToFollow.toFirestore());
    querySnapshot = await ref.where("id", isEqualTo: myUserId).get();
    BloqoUserData myself = querySnapshot.docs.first.data();
    myself.following.add(userToFollowId);
    await ref.doc(querySnapshot.docs.first.id).update(myself.toFirestore());
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

Future<void> unfollowUser({required var localizedText, required String userToUnfollowId, required String myUserId}) async {
  try {
    var ref = BloqoUserData.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("id", isEqualTo: userToUnfollowId).get();
    BloqoUserData userToUnfollow = querySnapshot.docs.first.data();
    userToUnfollow.followers.remove(myUserId);
    await ref.doc(querySnapshot.docs.first.id).update(userToUnfollow.toFirestore());
    querySnapshot = await ref.where("id", isEqualTo: myUserId).get();
    BloqoUserData myself = querySnapshot.docs.first.data();
    myself.following.remove(userToUnfollowId);
    await ref.doc(querySnapshot.docs.first.id).update(myself.toFirestore());
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
    var ref = BloqoUserData.getRef();
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
    var ref = BloqoUserData.getRef();
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

Future<BloqoUserData> getUserFromId({required var localizedText, required String id}) async {
  try {
    var ref = BloqoUserData.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("id", isEqualTo: id).get();
    BloqoUserData user = querySnapshot.docs.first.data();
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

Future<BloqoUserData> silentGetUserFromId({required String id}) async {
  var ref = BloqoUserData.getRef();
  var querySnapshot = await ref.where("id", isEqualTo: id).get();
  BloqoUserData user = querySnapshot.docs.first.data();
  return user;
}