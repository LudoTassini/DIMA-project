import 'package:bloqo/model/bloqo_notification_data.dart';
import 'package:bloqo/model/bloqo_user_data.dart';
import 'package:bloqo/model/courses/bloqo_block_data.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/model/courses/bloqo_course_data.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_published_course_data.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_review_data.dart';
import 'package:bloqo/model/courses/tags/bloqo_difficulty_tag.dart';
import 'package:bloqo/model/courses/tags/bloqo_duration_tag.dart';
import 'package:bloqo/model/courses/tags/bloqo_language_tag.dart';
import 'package:bloqo/model/courses/tags/bloqo_modality_tag.dart';
import 'package:bloqo/model/courses/tags/bloqo_subject_tag.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_created_data.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_enrolled_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

class MockExternalServices {
  final FakeFirebaseFirestore fakeFirestore;
  final CustomMockFirebaseAuth mockFirebaseAuth;
  final MockFirebaseStorage mockFirebaseStorage;

  final BloqoUserData testUser;
  final BloqoUserCourseCreatedData testCourseCreated;
  final BloqoUserCourseEnrolledData testCourseEnrolled;
  final BloqoNotificationData testNotification;
  final BloqoCourseData testCourse;
  final BloqoChapterData testChapter;
  final BloqoSectionData testSection;
  final BloqoBlockData testBlock1;
  final BloqoReviewData testReview;

  final BloqoUserData testUser2;
  final BloqoCourseData testCourse2;
  final BloqoPublishedCourseData testPublishedCourse2;
  final BloqoCourseData testCourse3;
  final BloqoPublishedCourseData testPublishedCourse3;
  final BloqoCourseData testCourse4;
  final BloqoPublishedCourseData testPublishedCourse4;

  MockExternalServices()
      : fakeFirestore = FakeFirebaseFirestore(),
        mockFirebaseStorage = MockFirebaseStorage(),
        testUser = BloqoUserData(
          id: "test",
          email: "test@bloqo.com",
          username: "test",
          fullName: "test",
          isFullNameVisible: false,
          pictureUrl: "none",
          followers: [],
          following: ["test2"],
        ),
        testUser2 = BloqoUserData(
          id: "test2",
          email: "test2@bloqo.com",
          username: "test2",
          fullName: "test2",
          isFullNameVisible: true,
          pictureUrl: "none",
          followers: ["test"],
          following: [],
        ),
        testCourseCreated = BloqoUserCourseCreatedData(
          courseId: "test",
          courseName: "test",
          numSectionsCreated: 1,
          numChaptersCreated: 1,
          authorId: "test",
          published: false,
          lastUpdated: Timestamp.now(),
        ),
        testCourseEnrolled = BloqoUserCourseEnrolledData(
          courseId: "test3",
          publishedCourseId: "test3",
          courseAuthor: "test",
          enrolledUserId: "test",
          courseName: "test_enrolled",
          sectionsCompleted: [],
          chaptersCompleted: [],
          totNumSections: 1,
          authorId: "test2",
          lastUpdated: Timestamp.now(),
          enrollmentDate: Timestamp.now(),
          isRated: false,
          isCompleted: false,
        ),
        testNotification = BloqoNotificationData(
          id: "test",
          userId: "test",
          type: BloqoNotificationType.courseEnrollmentRequest.toString(),
          timestamp: Timestamp.now(),
          privatePublishedCourseId: "test",
          applicantId: "test",
        ),
        testCourse = BloqoCourseData(
          id: "test",
          name: "test",
          authorId: "test",
          creationDate: Timestamp.now(),
          published: false,
          description: "test",
          chapters: ["test"]
        ),
        testPublishedCourse2 = BloqoPublishedCourseData(
            publishedCourseId: "test2",
            originalCourseId: "test2",
            courseName: "test",
            authorUsername: "test",
            authorId: "test2",
            isPublic: true,
            publicationDate: Timestamp.now(),
            language: BloqoLanguageTagValue.other.toString(),
            modality: BloqoModalityTagValue.lessonsOnly.toString(),
            subject: BloqoSubjectTagValue.other.toString(),
            difficulty: BloqoDifficultyTagValue.forEveryone.toString(),
            duration: BloqoDurationTagValue.lessThanOneHour.toString(),
            reviews: [],
            rating: 0
        ),
        testCourse2 = BloqoCourseData(
            id: "test2",
            name: "test",
            authorId: "test2",
            creationDate: Timestamp.now(),
            publicationDate: Timestamp.now(),
            published: true,
            description: "test",
            chapters: ["test"]
        ),
        testPublishedCourse3 = BloqoPublishedCourseData(
            publishedCourseId: "test3",
            originalCourseId: "test3",
            courseName: "test_enrolled",
            authorUsername: "test",
            authorId: "test2",
            isPublic: true,
            publicationDate: Timestamp.now(),
            language: BloqoLanguageTagValue.other.toString(),
            modality: BloqoModalityTagValue.lessonsOnly.toString(),
            subject: BloqoSubjectTagValue.other.toString(),
            difficulty: BloqoDifficultyTagValue.forEveryone.toString(),
            duration: BloqoDurationTagValue.lessThanOneHour.toString(),
            reviews: [],
            rating: 0
        ),
        testCourse3 = BloqoCourseData(
            id: "test3",
            name: "test_enrolled",
            authorId: "test2",
            creationDate: Timestamp.now(),
            publicationDate: Timestamp.now(),
            published: true,
            description: "test",
            chapters: ["test"]
        ),
        testPublishedCourse4 = BloqoPublishedCourseData(
            publishedCourseId: "test4",
            originalCourseId: "test4",
            courseName: "private_test",
            authorUsername: "test",
            authorId: "test2",
            isPublic: false,
            publicationDate: Timestamp.now(),
            language: BloqoLanguageTagValue.other.toString(),
            modality: BloqoModalityTagValue.lessonsOnly.toString(),
            subject: BloqoSubjectTagValue.other.toString(),
            difficulty: BloqoDifficultyTagValue.forEveryone.toString(),
            duration: BloqoDurationTagValue.lessThanOneHour.toString(),
            reviews: [],
            rating: 0
        ),
        testCourse4 = BloqoCourseData(
            id: "test4",
            name: "private_test",
            authorId: "test2",
            creationDate: Timestamp.now(),
            publicationDate: Timestamp.now(),
            published: true,
            description: "test",
            chapters: ["test"]
        ),
        testChapter = BloqoChapterData(
          id: "test",
          number: 1,
          name: "test",
          sections: ["test"],
          description: "test"
        ),
        testSection = BloqoSectionData(
          id: "test",
          number: 1,
          name: "test",
          blocks: ["test1"]
        ),
        testBlock1 = BloqoBlockData(
          id: "test1",
          superType: BloqoBlockSuperType.text.toString(),
          type: BloqoBlockType.text.toString(),
          name: BloqoBlockSuperType.text.toString(),
          number: 1,
          content: "test"
        ),
        testReview = BloqoReviewData(
          authorUsername: "test",
          authorId: "test",
          rating: 5,
          id: "test",
          commentTitle: "test",
          comment: "test"
        ),

        mockFirebaseAuth = CustomMockFirebaseAuth(
          mockUser: MockUser(
            isAnonymous: false,
            uid: 'test',
            email: 'test@bloqo.com',
            displayName: 'test',
          ),
        );

  Future<void> prepare() async {
    await fakeFirestore.collection('users').doc('test').set(testUser.toFirestore());
    await fakeFirestore.collection('users').doc('test2').set(testUser2.toFirestore());
    await fakeFirestore.collection('user_course_created').doc('test').set(testCourseCreated.toFirestore());
    await fakeFirestore.collection('user_course_enrolled').doc('test').set(testCourseEnrolled.toFirestore());
    await fakeFirestore.collection('courses').doc('test').set(testCourse.toFirestore());
    await fakeFirestore.collection('published_courses').doc('test2').set(testPublishedCourse2.toFirestore());
    await fakeFirestore.collection('courses').doc('test2').set(testCourse2.toFirestore());
    await fakeFirestore.collection('published_courses').doc('test3').set(testPublishedCourse3.toFirestore());
    await fakeFirestore.collection('courses').doc('test3').set(testCourse3.toFirestore());
    await fakeFirestore.collection('published_courses').doc('test4').set(testPublishedCourse4.toFirestore());
    await fakeFirestore.collection('courses').doc('test4').set(testCourse4.toFirestore());
    await fakeFirestore.collection('chapters').doc('test').set(testChapter.toFirestore());
    await fakeFirestore.collection('sections').doc('test').set(testSection.toFirestore());
    await fakeFirestore.collection('blocks').doc('test1').set(testBlock1.toFirestore());
    await fakeFirestore.collection('notifications').doc('test').set(testNotification.toFirestore());
    await fakeFirestore.collection('reviews').doc('test').set(testReview.toFirestore());
  }
}

class CustomMockFirebaseAuth extends MockFirebaseAuth {
  CustomMockFirebaseAuth({required MockUser mockUser}) : super(mockUser: mockUser);

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email != 'test@bloqo.com') {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    if (password != 'Test123!') {
      throw FirebaseAuthException(code: 'wrong-password');
    }
    return super.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    if (email == 'test@bloqo.com') {
      throw FirebaseAuthException(code: 'email-already-in-use');
    }
    return super.createUserWithEmailAndPassword(email: email, password: password);
  }

}