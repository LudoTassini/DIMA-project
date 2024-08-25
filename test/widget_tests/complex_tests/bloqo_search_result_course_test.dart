import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/complex/bloqo_search_result_course.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_published_course_data.dart';
import 'package:bloqo/model/courses/tags/bloqo_difficulty_tag.dart';
import 'package:bloqo/model/courses/tags/bloqo_duration_tag.dart';
import 'package:bloqo/model/courses/tags/bloqo_language_tag.dart';
import 'package:bloqo/model/courses/tags/bloqo_modality_tag.dart';
import 'package:bloqo/model/courses/tags/bloqo_subject_tag.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  bool tapped = false;
  
  Widget buildTestWidget() {
    return MaterialApp(
        localizationsDelegates: getLocalizationDelegates(),
        supportedLocales: getSupportedLocales(),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
          ],
          child: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: BloqoSearchResultCourse(
                    onPressed: () {
                      tapped = true;
                    },
                    course: BloqoPublishedCourseData(
                      publishedCourseId: "test",
                      originalCourseId: "test",
                      courseName: "test",
                      authorId: "test",
                      authorUsername: "test",
                      isPublic: true,
                      publicationDate: Timestamp.now(),
                      language: BloqoLanguageTagValue.english.toString(),
                      modality: BloqoModalityTagValue.lessonsAndQuizzes.toString(),
                      difficulty: BloqoDifficultyTagValue.forEveryone.toString(),
                      duration: BloqoDurationTagValue.lessThanOneHour.toString(),
                      subject: BloqoSubjectTagValue.other.toString(),
                      rating: 5,
                      reviews: ["test"]
                    )
                  )
                );
              }
          ),
        )
    );
  }

  setUp(() {
    tapped = false;
  });

  testWidgets('Search result course present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoSearchResultCourse), findsOneWidget);
  });

  testWidgets('Search result course can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.byType(BloqoSearchResultCourse));
    await tester.pump();
    expect(tapped, isTrue);
  });
  
}