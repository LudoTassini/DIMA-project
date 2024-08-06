import 'package:bloqo/utils/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';

class BloqoReview{

  final String id;
  final String authorUsername;
  final String authorId;
  final int rating;
  final String commentTitle;
  final String comment;

  BloqoReview({
    required this.authorUsername,
    required this.authorId,
    required this.rating,
    required this.id,
    required this.commentTitle,
    required this.comment
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
        commentTitle: data["comment_title"],
        comment: data["comment"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id ,
      "author_username": authorUsername,
      "author_id": authorId,
      "rating": rating,
      "comment_title": commentTitle,
      "comment": comment
    };
  }

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("reviews").withConverter(
      fromFirestore: BloqoReview.fromFirestore,
      toFirestore: (BloqoReview review, _) => review.toFirestore(),
    );
  }

}

Future<List<BloqoReview>> getReviewsFromIds({required var localizedText, required List<dynamic>? reviewsIds}) async {
  try {
    var ref = BloqoReview.getRef();
    List<BloqoReview> reviews = [];
    for(var reviewId in reviewsIds!) {
      await checkConnectivity(localizedText: localizedText);
      var querySnapshot = await ref.where("id", isEqualTo: reviewId).get();
      BloqoReview review = querySnapshot.docs.first.data();
      reviews.add(review);
    }
    return reviews;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}