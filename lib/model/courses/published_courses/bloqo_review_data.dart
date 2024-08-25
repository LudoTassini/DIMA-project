import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/bloqo_exception.dart';

class BloqoReviewData{

  final String id;
  final String authorUsername;
  final String authorId;
  final int rating;
  final String commentTitle;
  final String comment;

  BloqoReviewData({
    required this.authorUsername,
    required this.authorId,
    required this.rating,
    required this.id,
    required this.commentTitle,
    required this.comment
  });

  factory BloqoReviewData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    return BloqoReviewData(
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

  static getRef({required FirebaseFirestore firestore}) {
    return firestore.collection("reviews").withConverter(
      fromFirestore: BloqoReviewData.fromFirestore,
      toFirestore: (BloqoReviewData review, _) => review.toFirestore(),
    );
  }

}

Future<List<BloqoReviewData>> getReviewsFromIds({
  required FirebaseFirestore firestore,
  required var localizedText,
  required List<dynamic> reviewsIds
}) async {
  try {
    var ref = BloqoReviewData.getRef(firestore: firestore);
    List<BloqoReviewData> reviews = [];
    for(var reviewId in reviewsIds) {
      var querySnapshot = await ref.where("id", isEqualTo: reviewId).get();
      BloqoReviewData review = querySnapshot.docs.first.data();
      reviews.add(review);
    }
    return reviews;
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> publishReview({
  required FirebaseFirestore firestore,
  required var localizedText,
  required BloqoReviewData review
}) async {
  try {
    var ref = BloqoReviewData.getRef(firestore: firestore);
    await ref.doc().set(review);
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}