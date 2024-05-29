import 'package:cloud_firestore/cloud_firestore.dart';

class BloqoUser{
  final String email;
  final String username;
  final String fullName;
  final bool isFullNameVisible;
  final int followers;
  final int following;

  BloqoUser({
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
      email: data!["email"],
      username: data["username"],
      fullName: data["full_name"],
      isFullNameVisible: data["is_full_name_visible"],
      followers: data["followers"],
      following: data["following"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
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