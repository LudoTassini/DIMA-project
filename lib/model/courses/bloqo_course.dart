import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloqo_review.dart';
import 'bloqo_chapter.dart';

class BloqoCourse{

  final String name;
  final String author;

  DateTime? creationDate;
  DateTime? publicationDate;
  bool? isPublic;

  List<BloqoChapter>? chapters;

  List<BloqoReview>? reviews;

  int numberOfEnrollments = 0;
  int numberOfCompletions = 0;

  BloqoCourse({
    required this.name,
    required this.author,
    this.creationDate,
    this.publicationDate,
    this.isPublic,
    this.chapters,
    this.reviews,
    this.numberOfEnrollments = 0,
    this.numberOfCompletions = 0,
  });

  factory BloqoCourse.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ){
    final data = snapshot.data();
    return BloqoCourse(
        name: data!["name"],
        author: data["author_username"],
        creationDate: data["creation_date"],
        publicationDate: data["publication_date"],
        isPublic: data["is_public"],
        chapters: data["chapters"],
        reviews: data["reviews"],
        numberOfEnrollments: data["number_of_enrollments"],
        numberOfCompletions: data["number_of_completions"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "author_username": author,
      "creation_date": creationDate,
      "publication_date": publicationDate,
      "is_public": isPublic,
      "chapters": chapters,
      "reviews": reviews,
      "number_of_enrollments": numberOfEnrollments,
      "number_of_completions": numberOfCompletions
    };
  }

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("courses").withConverter(
      fromFirestore: BloqoCourse.fromFirestore,
      toFirestore: (BloqoCourse course, _) => course.toFirestore(),
    );
  }

}