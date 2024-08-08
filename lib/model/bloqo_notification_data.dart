import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/bloqo_exception.dart';
import '../utils/connectivity.dart';

class BloqoNotificationData{

  final String id;
  final String userId;
  final String type;
  final Timestamp timestamp;

  String? privatePublishedCourseId;
  String? applicantId;

  String? content;

  BloqoNotificationData({
    required this.id,
    required this.userId,
    required this.type,
    required this.timestamp,
    this.privatePublishedCourseId,
    this.applicantId,
    this.content
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
      content: data["content"]
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
      "content": content,
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
  genericInfo
}

Future<List<BloqoNotificationData>> getNotificationsFromUserId({required var localizedText, required String userId}) async {
  try {
    var ref = BloqoNotificationData.getRef();
    await checkConnectivity(localizedText: localizedText);
    var querySnapshot = await ref.where("user_id", isEqualTo: userId).get();
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