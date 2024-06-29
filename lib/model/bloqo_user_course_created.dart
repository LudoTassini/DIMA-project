import 'package:cloud_firestore/cloud_firestore.dart';

class BloqoUserCourseCreated {
  final DocumentReference course;
  final String courseName;
  int numSectionsCreated;
  int numChaptersCreated;
  final String authorId;
  bool published;

  BloqoUserCourseCreated({
    required this.course,
    required this.courseName,
    required this.numSectionsCreated,
    required this.numChaptersCreated,
    required this.authorId,
    required this.published
  });

  factory BloqoUserCourseCreated.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();

    return BloqoUserCourseCreated(
      course: data!['course'],
      courseName: data['course_name'],
      numSectionsCreated: data['num_sections_created'],
      numChaptersCreated: data['num_chapters_created'],
      authorId: data['author_id'],
      published: data['published']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'course': course,
      'course_name': courseName,
      'num_sections_created': numSectionsCreated,
      'num_chapters_created': numChaptersCreated,
      'author_id': authorId,
      'published': published
    };
  }

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("user_course_created").withConverter(
      fromFirestore: BloqoUserCourseCreated.fromFirestore,
      toFirestore: (BloqoUserCourseCreated userCourse, _) => userCourse.toFirestore(),
    );
  }
}