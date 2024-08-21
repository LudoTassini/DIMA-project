import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/complex/bloqo_editable_block.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/model/courses/bloqo_block_data.dart';
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
                  body: BloqoEditableBlock(
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
                    block: BloqoBlockData(
                      id: "test",
                      superType: BloqoBlockSuperType.text.toString(),
                      name: BloqoBlockSuperType.text.toString(),
                      number: 1,
                      content: ""
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

  testWidgets('Editable block present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: true));
    expect(find.byType(BloqoEditableBlock), findsOneWidget);
  });

  testWidgets('Editable block can be tapped (if editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: true));
    await tester.tap(find.text(BloqoBlockSuperType.text.toString()));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('Editable block can be tapped (if not editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: false));
    await tester.tap(find.text(BloqoBlockSuperType.text.toString()));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('Editable block can be deleted (if editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: true));
    await tester.tap(find.byIcon(Icons.delete_forever));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    expect(tapped, isFalse);
    expect(find.byType(BloqoConfirmationAlert), findsOneWidget);
  });

  testWidgets('Editable block cannot be deleted (if not editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: false));

    expect(tapped, isFalse);
    expect(find.byType(BloqoConfirmationAlert), findsNothing);
    expect(find.byIcon(Icons.delete_forever), findsNothing);
  });

}