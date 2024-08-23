import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/model/bloqo_notification_data.dart';
import 'package:bloqo/model/bloqo_user_data.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_created_data.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_enrolled_data.dart';
import 'package:bloqo/utils/bloqo_external_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:bloqo/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final user = MockUser(
    isAnonymous: false,
    uid: 'test',
    email: 'test@bloqo.com',
    displayName: 'test',
  );

  final fakeFirestore = FakeFirebaseFirestore();
  final mockFirebaseAuth = MockFirebaseAuth(mockUser: user);
  final mockFirebaseStorage = MockFirebaseStorage();

  testWidgets('Login test', (WidgetTester tester) async {

    BloqoUserData testUser = BloqoUserData(
        id: "test",
        email: "test@bloqo.com",
        username: "test",
        fullName: "test",
        isFullNameVisible: false,
        pictureUrl: "none",
        followers: [],
        following: []
    );

    BloqoUserCourseCreatedData testCourseCreated = BloqoUserCourseCreatedData(
        courseId: "test",
        courseName: "test",
        numSectionsCreated: 1,
        numChaptersCreated: 1,
        authorId: "test",
        published: false,
        lastUpdated: Timestamp.now()
    );

    BloqoUserCourseEnrolledData testCourseEnrolled = BloqoUserCourseEnrolledData(
        courseId: "test",
        publishedCourseId: "test",
        courseAuthor: "test",
        enrolledUserId: "test",
        courseName: "test",
        sectionsCompleted: [],
        chaptersCompleted: [],
        totNumSections: 1,
        authorId: "test",
        lastUpdated: Timestamp.now(),
        enrollmentDate: Timestamp.now(),
        isRated: false,
        isCompleted: false
    );

    BloqoNotificationData testNotification = BloqoNotificationData(
        id: "test",
        userId: "test",
        type: BloqoNotificationType.courseEnrollmentRequest.toString(),
        timestamp: Timestamp.now(),
        privatePublishedCourseId: "test",
        applicantId: "test"
    );

    await fakeFirestore.collection('users').doc('test').set(testUser.toFirestore());
    await fakeFirestore.collection('user_course_created').doc('test').set(testCourseCreated.toFirestore());
    await fakeFirestore.collection('user_course_enrolled').doc('test').set(testCourseEnrolled.toFirestore());
    await fakeFirestore.collection('notifications').doc('test').set(testNotification.toFirestore());

    await tester.runAsync(() async {
      await app.main(externalServices: BloqoExternalServices(
          firestore: fakeFirestore,
          auth: mockFirebaseAuth,
          storage: mockFirebaseStorage
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
      await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(BloqoFilledButton).first);
      await tester.pumpAndSettle();

      //await Future.delayed(const Duration(seconds: 5));

      expect(find.text('test'), findsAtLeast(1));
    });
  });
}