import 'package:bloqo/model/courses/bloqo_course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloqoUser{
  final String email;
  final String username;
  final String fullName;
  final bool isFullNameVisible;

  List<BloqoCourse>? coursesEnrolledIn;
  List<BloqoCourse>? coursesCreated;

  BloqoUser({
    required this.email,
    required this.username,
    required this.fullName,
    required this.isFullNameVisible,
    this.coursesEnrolledIn,
    this.coursesCreated,
  });

  factory BloqoUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ){
    final data = snapshot.data();
    // retrieving courses the user is enrolled in
    List<dynamic> subDocumentReferences = data?['courses_enrolled_in'];
    List<BloqoCourse>? coursesEnrolledIn;

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
        coursesEnrolledIn!.add(course);
      } else {
        print('Sub-document does not exist');
        // FIXME
      }
    }

    // retrieving courses the user created
    subDocumentReferences = data?['courses_created'];
    List<BloqoCourse>? coursesCreated;

    for (dynamic subDocumentReference in subDocumentReferences) {
      //Fetch each referenced sub-document from Firestore
      DocumentSnapshot subDocumentSnapshot = subDocumentReference.get();
      if (subDocumentSnapshot.exists) {
        //Extract the desired variables from each sub-document
        String courseName = subDocumentSnapshot['name'];
        //TODO: aggiungere parametri per contare numero di capitoli e di sezioni

        final course = BloqoCourse(
          name: courseName,
          author: data?['username'],
        );
        coursesEnrolledIn!.add(course);
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
      coursesEnrolledIn: coursesEnrolledIn,
      coursesCreated: coursesCreated,
    );
  }

  Map<String, dynamic> toFirestore() {
    List? coursesEnrolledInReferences = coursesEnrolledIn?.map((course) => BloqoCourse.getRef()).toList();
    List? coursesCreatedReferences = coursesCreated?.map((course) => BloqoCourse.getRef()).toList();
    return {
      "email": email,
      "username": username,
      "full_name": fullName,
      "is_full_name_visible": isFullNameVisible,
      "courses_enrolled_in": coursesEnrolledInReferences,
      "courses_created": coursesCreatedReferences,
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