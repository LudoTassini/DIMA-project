import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';
import '../utils/connectivity.dart';
import '../utils/constants.dart';

class BloqoNotificationData{

  final String id;
  final String userId;
  final String type;
  final Timestamp timestamp;

  // enrollment request
  String? privatePublishedCourseId;
  String? applicantId;

  // enrollment accepted
  String? privateCourseName;
  String? privateCourseAuthorId;

  // new course published from followed user
  String? courseAuthorId;
  String? courseName;

  BloqoNotificationData({
    required this.id,
    required this.userId,
    required this.type,
    required this.timestamp,
    this.privatePublishedCourseId,
    this.applicantId,
    this.privateCourseName,
    this.privateCourseAuthorId,
    this.courseAuthorId,
    this.courseName
  });

  factory BloqoNotificationData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    return BloqoNotificationData(
      id: data!["id"],
      userId: data["user_id"],
      type: data["type"],
      timestamp: data["timestamp"],
      privatePublishedCourseId: data["private_published_course_id"],
      applicantId: data["applicant_id"],
      privateCourseName: data["private_course_name"],
      privateCourseAuthorId: data["private_course_author_id"],
      courseAuthorId: data["course_author_id"],
      courseName: data["course_name"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id ,
      "user_id": userId,
      "type": type,
      "timestamp": timestamp,
      "private_published_course_id": privatePublishedCourseId,
      "applicant_id": applicantId,
      "private_course_name": privateCourseName,
      "private_course_author_username": privateCourseAuthorId,
      "course_author_id": courseAuthorId,
      "course_name": courseName
    };
  }

  static getRef() {
    var db = FirebaseFirestore.instance;
    return db.collection("notifications").withConverter(
      fromFirestore: BloqoNotificationData.fromFirestore,
      toFirestore: (BloqoNotificationData notification, _) => notification.toFirestore(),
    );
  }

}

enum BloqoNotificationType{
  courseEnrollmentRequest,
  courseEnrollmentAccepted,
  newCourseFromFollowedUser
}

Future<List<BloqoNotificationData>> getNotificationsFromUserId({required var localizedText, required String userId}) async {
  try {
    var ref = BloqoNotificationData.getRef();
    await checkConnectivity(localizedText: localizedText);

    var querySnapshot = await ref
        .where("user_id", isEqualTo: userId)
        .orderBy("timestamp", descending: true)
        .limit(Constants.maxNotificationsToFetch)
        .get();

    List<BloqoNotificationData> notifications = [];
    for(var doc in querySnapshot.docs){
      BloqoNotificationData notification = doc.data();
      notifications.add(notification);
    }
    return notifications;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
  on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<BloqoNotificationData?> getNotificationFromPublishedCourseIdAndApplicantId({
  required var localizedText,
  required String publishedCourseId,
  required String applicantId
}) async {
  try {
    var ref = BloqoNotificationData.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("private_published_course_id", isEqualTo: publishedCourseId).where("applicant_id", isEqualTo: applicantId).get();
    if(querySnapshot.docs.length == 0){
      return null;
    }
    else{
      BloqoNotificationData notification = querySnapshot.docs[0].data();
      return notification;
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
  on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> pushNotification({required var localizedText, required BloqoNotificationData notification}) async {
  try {
    var ref = BloqoNotificationData.getRef();
    await checkConnectivity(localizedText: localizedText);
    await ref.doc().set(notification);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
  on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> deleteNotification({required var localizedText, required String notificationId}) async {
  try {
    var ref = BloqoNotificationData.getRef();
    await checkConnectivity(localizedText: localizedText);
    QuerySnapshot querySnapshot = await ref.where("id", isEqualTo: notificationId).get();
    await querySnapshot.docs[0].reference.delete();
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
  on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}