import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/complex/bloqo_course_created.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_created_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  bool tapped = false;

  Widget buildTestWidget({
    required bool showEditOptions,
    required bool showPublishedOptions
  }) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
        ],
        child: MaterialApp(
          localizationsDelegates: getLocalizationDelegates(),
          supportedLocales: getSupportedLocales(),
          home: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: BloqoCourseCreated(
                    course: BloqoUserCourseCreatedData(
                      courseId: "test",
                      courseName: "test",
                      authorId: "test",
                      numChaptersCreated: 1,
                      numSectionsCreated: 1,
                      published: false,
                      lastUpdated: Timestamp.now()
                    ),
                    onPressed: () {
                      tapped = true;
                    },
                    showEditOptions: showEditOptions,
                    showPublishedOptions: showPublishedOptions,
                    onPreview: () {
                      tapped = true;
                    },
                    onGetQrCode: () {
                      tapped = true;
                    },
                    onViewStatistics: () {
                      tapped = true;
                    },
                    onPublish: () {
                      tapped = true;
                    },
                    onDismiss: () {
                      tapped = true;
                    },
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

  testWidgets('Course created present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showEditOptions: false, showPublishedOptions: false));
    expect(find.byType(BloqoCourseCreated), findsOneWidget);
  });

  testWidgets('Course created can be tapped and has no extra filled buttons (home page)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showEditOptions: false, showPublishedOptions: false));
    await tester.tap(find.byType(BloqoCourseCreated));
    await tester.pump();
    expect(tapped, isTrue);
    expect(find.byType(BloqoFilledButton), findsNothing);
  });

  testWidgets('Course created can be tapped and has three filled buttons (editor page: in progress)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showEditOptions: true, showPublishedOptions: false));
    await tester.tap(find.text("test"));
    await tester.pump();
    expect(tapped, isTrue);
    expect(find.byType(BloqoFilledButton), findsExactly(3));
    expect(find.text("Preview"), findsOne);
  });

  testWidgets('Course created can be tapped and has three filled buttons (editor page: published)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showEditOptions: false, showPublishedOptions: true));
    await tester.tap(find.text("test"));
    await tester.pump();
    expect(tapped, isTrue);
    expect(find.byType(BloqoFilledButton), findsExactly(3));
    expect(find.text("Dismiss"), findsOne);
  });

  testWidgets('Course created delete button can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showEditOptions: true, showPublishedOptions: false));
    await tester.tap(find.text("Delete"));
    await tester.pump();
    expect(find.byType(AlertDialog), findsOne);
  });

  testWidgets('Course created publish button can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showEditOptions: true, showPublishedOptions: false));
    await tester.tap(find.text("Publish"));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('Course created preview button can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showEditOptions: true, showPublishedOptions: false));
    await tester.tap(find.text("Preview"));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('Course created QR code button can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showEditOptions: false, showPublishedOptions: true));
    await tester.tap(find.text("Get QR Code"));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('Course created view statistics button can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showEditOptions: false, showPublishedOptions: true));
    await tester.tap(find.text("View statistics"));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('Course created dismiss button can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showEditOptions: false, showPublishedOptions: true));
    await tester.tap(find.text("Dismiss"));
    await tester.pump();
    expect(tapped, isTrue);
  });

}