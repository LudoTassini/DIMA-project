import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/complex/bloqo_course_enrolled.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_enrolled_data.dart';
import 'package:bloqo/style/themes/purple_orchid_theme.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  bool tapped = false;

  Widget buildTestWidget({
    required bool isCompleted,
    required bool isRated
  }) {
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
                  body: BloqoCourseEnrolled(
                    course: BloqoUserCourseEnrolledData(
                        courseId: "test",
                        courseName: "test_course",
                        authorId: "test",
                        lastUpdated: Timestamp.now(),
                        publishedCourseId: "test",
                        courseAuthor: "test",
                        enrolledUserId: "test",
                        sectionsCompleted: ["test1", "test2"],
                        chaptersCompleted: ["test1"],
                        totNumSections: 8,
                        enrollmentDate: Timestamp.now(),
                        isCompleted: isCompleted,
                        isRated: isRated
                    ),
                    onPressed: () {
                      tapped = true;
                    },
                    showCompleted: isCompleted,
                    showInProgress: !isCompleted,
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

  testWidgets('Course enrolled present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(isCompleted: false, isRated: false));
    expect(find.byType(BloqoCourseEnrolled), findsOneWidget);
  });

  testWidgets('Course created can be tapped and has no extra filled buttons (home page and learn page: enrollings)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(isCompleted: false, isRated: false));
    await tester.tap(find.byType(BloqoCourseEnrolled));
    await tester.pump();
    expect(tapped, isTrue);
    expect(find.byType(BloqoFilledButton), findsNothing);
  });

  testWidgets('Course created can be tapped and has two filled buttons, none of which have the inactive color (learn page: completed)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(isCompleted: true, isRated: false));
    await tester.tap(find.text("test_course"));
    await tester.pump();
    expect(tapped, isTrue);
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    final buttons = tester.widgetList<BloqoFilledButton>(find.byType(BloqoFilledButton));
    for (final button in buttons) {
      expect(button.color, isNot(PurpleOrchidTheme().colors.inactive));
    }
  });

  testWidgets('Course created can be tapped and has two filled buttons, of which one has the inactive color (learn page: completed)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(isCompleted: true, isRated: true));
    await tester.tap(find.text("test_course"));
    await tester.pump();
    expect(tapped, isTrue);
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    final buttons = tester.widgetList<BloqoFilledButton>(find.byType(BloqoFilledButton));
    int inactiveButtonCount = 0;
    for (final button in buttons) {
      if (button.color == PurpleOrchidTheme().colors.inactive) {
        inactiveButtonCount++;
      }
    }
    expect(inactiveButtonCount, 1);
  });

}