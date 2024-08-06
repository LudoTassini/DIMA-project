import 'package:bloqo/utils/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';

class BloqoReview{

  final String id;
  final String authorUsername;
  final String authorId;
  final int rating;

  String? comment;

  BloqoReview({
    required this.authorUsername,
    required this.authorId,
    required this.rating,
    required this.id,
    this.comment
  });

  factory BloqoReview.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    return BloqoReview(
        id: data!["id"],
        authorUsername: data["author_username"],
        authorId: data["author_id"],
        rating: data["rating"],
        comment: data["comment"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id ,
      "author_username": authorUsername,
      "author_id": authorId,
      "rating": rating,
      "comment": comment
    };
  }

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("reviews").withConverter(
      fromFirestore: BloqoReview.fromFirestore,
      toFirestore: (BloqoReview review, _) => user.toFirestore(),
    );
  }

  Future<BloqoUser> getUserFromId({required var localizedText, required String id}) async {
    try {
      var ref = BloqoUser.getRef();
      await checkConnectivity(localizedText: localizedText);
      var querySnapshot = await ref.where("id", isEqualTo: id).get();
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

}