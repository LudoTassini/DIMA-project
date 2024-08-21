import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/learn_course_app_state.dart';
import 'package:bloqo/components/complex/bloqo_course_section.dart';
import 'package:bloqo/model/courses/bloqo_course_data.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  bool tapped = false;

  Widget buildTestWidget({
    required bool isClickable,
    required bool isInLearnPage
  }) {
    return MaterialApp(
        localizationsDelegates: getLocalizationDelegates(),
        supportedLocales: getSupportedLocales(),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
            ChangeNotifierProvider(create: (_) => LearnCourseAppState())
          ],
          child: Builder(
              builder: (BuildContext context) {
                Map<String, List<BloqoSectionData>> map = {};
                map["test"] = [BloqoSectionData(
                    id: "test",
                    number: 1,
                    name: "test",
                    blocks: ["test"]
                )];
                saveLearnCourseToAppState(
                    context: context,
                    course: BloqoCourseData(
                      id: "test",
                      name: "test",
                      authorId: "test",
                      creationDate: Timestamp.now(),
                      chapters: ["test"],
                      description: "test",
                      published: true,
                      publicationDate: Timestamp.now()
                    ),
                    chapters: [BloqoChapterData(
                      id: "test",
                      number: 1,
                      name: "test",
                      sections: ["test"]
                    )],
                    sections: map,
                    enrollmentDate: Timestamp.now(),
                    sectionsCompleted: [],
                    totNumSections: 1,
                    chaptersCompleted: []
                );
                return Scaffold(
                  body: BloqoCourseSection(
                    isClickable: isClickable,
                    isInLearnPage: isInLearnPage,
                    index: 0,
                    onPressed: () {
                      tapped = true;
                    },
                    section: BloqoSectionData(
                      id: "test",
                      number: 1,
                      name: "test",
                      blocks: ["test1", "test2"]
                    )
                  ),
                );
              }
          ),
        )
    );
  }

  setUp(() {
    tapped = false;
  });

  testWidgets('Course section present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(isClickable: false, isInLearnPage: false));
    expect(find.byType(BloqoCourseSection), findsOneWidget);
  });

  testWidgets('Course section should be clickable if it is in learn page and is declared clickable', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(isClickable: true, isInLearnPage: true));
    await tester.tap(find.byType(BloqoCourseSection));
    await tester.pump();
    expect(tapped, isTrue);
    expect(find.byType(Icon), findsOne);
  });

  testWidgets('Course section should not be clickable if it is in learn page and is not declared clickable', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(isClickable: false, isInLearnPage: true));
    await tester.tap(find.byType(BloqoCourseSection));
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('Course section should not be clickable ans should not show any icon if it is not in learn page and is not declared clickable', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(isClickable: false, isInLearnPage: false));
    await tester.tap(find.byType(BloqoCourseSection));
    await tester.pump();
    expect(tapped, isFalse);
    expect(find.byType(Icon), findsNothing);
  });

}