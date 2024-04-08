import 'package:bloqo/model/courses/bloqo_course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloqoUser{
  final String email;
  final String username;
  final String fullName;
  final bool isFullNameVisible;

  List<BloqoCourse>? coursesEnrolledIn;

  BloqoUser({
    required this.email,
    required this.username,
    required this.fullName,
    required this.isFullNameVisible,
    this.coursesEnrolledIn
  });

  factory BloqoUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ){
    final data = snapshot.data();
    List<dynamic> subDocumentReferences = data?['courses_enrolled_in'];
    List<BloqoCourse>? courses;

    for (dynamic subDocumentReference in subDocumentReferences) {
      //Fetch each referenced sub-document from Firestore
      DocumentSnapshot subDocumentSnapshot = subDocumentReference.get();
      if (subDocumentSnapshot.exists) {
        //Extract the desired variables from each sub-document
        String courseName = subDocumentSnapshot['name'];
        String courseAuthor = subDocumentSnapshot['author_username'];

        final course = BloqoCourse(
            name: courseName,
            author: courseAuthor,
        );
        courses!.add(course);
      } else {
        print('Sub-document does not exist');
        // FIXME
      }
    }

    return BloqoUser(
      email: data!["email"],
      username: data["username"],
      fullName: data["full_name"],
      isFullNameVisible: data["is_full_name_visible"],
      coursesEnrolledIn: courses,
    );
  }

  Map<String, dynamic> toFirestore() {
    List? coursesEnrolledInReferences = coursesEnrolledIn?.map((course) => BloqoCourse.getRef()).toList();
    return {
      "email": email,
      "username": username,
      "full_name": fullName,
      "is_full_name_visible": isFullNameVisible,
      "courses_enrolled_in": coursesEnrolledInReferences,
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