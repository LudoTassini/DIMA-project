import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/complex/bloqo_editable_section.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/model/courses/bloqo_course_data.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  bool tapped = false;

  Widget buildTestWidget({
    required bool editable
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
                  body: BloqoEditableSection(
                    editable: editable,
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
                    chapter: BloqoChapterData(
                        id: "test",
                        number: 1,
                        name: "test",
                        sections: ["test"]
                    ),
                    section: BloqoSectionData(
                        id: "test",
                        number: 1,
                        name: "test",
                        blocks: ["test"]
                    ),
                    onPressed: () {
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

  testWidgets('Editable section present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: true));
    expect(find.byType(BloqoEditableSection), findsOneWidget);
  });

  testWidgets('Editable section can be tapped (if editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: true));
    await tester.tap(find.text("test"));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('Editable section can be tapped (if not editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: false));
    await tester.tap(find.text("test"));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('Editable section can be deleted (if editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: true));
    await tester.tap(find.byIcon(Icons.delete_forever));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    expect(tapped, isFalse);
    expect(find.byType(BloqoConfirmationAlert), findsOneWidget);
  });

  testWidgets('Editable section cannot be deleted (if not editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: false));

    expect(tapped, isFalse);
    expect(find.byType(BloqoConfirmationAlert), findsNothing);
    expect(find.byIcon(Icons.delete_forever), findsNothing);
  });

}