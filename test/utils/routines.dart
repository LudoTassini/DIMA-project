import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/complex/bloqo_course_created.dart';
import 'package:bloqo/components/complex/bloqo_course_enrolled.dart';
import 'package:bloqo/components/complex/bloqo_course_section.dart';
import 'package:bloqo/components/complex/bloqo_editable_chapter.dart';
import 'package:bloqo/components/complex/bloqo_editable_section.dart';
import 'package:bloqo/components/forms/bloqo_dropdown.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/bloqo_external_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloqo/main.dart' as app;

import 'mock_external_services.dart';

Future<void> initTestApp({required WidgetTester tester}) async {
  MockExternalServices mockExternalServices = MockExternalServices();
  await mockExternalServices.prepare();

  await app.main(externalServices: BloqoExternalServices(
      firestore: mockExternalServices.fakeFirestore,
      auth: mockExternalServices.mockFirebaseAuth,
      storage: mockExternalServices.mockFirebaseStorage
  ));
  await tester.pumpAndSettle();
}

Future<void> doLogin({required WidgetTester tester}) async {
  await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
  await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
  await tester.pumpAndSettle();

  await tester.tap(find.byType(BloqoFilledButton).first);
  await tester.pumpAndSettle();
}

Future<void> goToStack({required WidgetTester tester, required String stack}) async {
  await tester.tap(find.text(stack));
  await tester.pump();
}

Future<void> createNewCourseAndTest({required WidgetTester tester, bool andComeBack = false}) async {
  expect(find.byType(BloqoCourseCreated), findsOne);

  await tester.tap(find.byType(BloqoFilledButton).last);
  await tester.pumpAndSettle();

  expect(find.text("Course"), findsOne);

  if(andComeBack) {
    await tester.tap(find.byIcon(Icons.arrow_back).last);
    await tester.pump();

    expect(find.byType(BloqoCourseCreated), findsExactly(2));
  }
}

Future<void> createNewChapterAndTest({required WidgetTester tester}) async {
  await tester.tap(find.byType(BloqoFilledButton).first);
  await tester.pumpAndSettle();

  expect(find.byType(BloqoEditableChapter), findsOne);
}

Future<void> createNewSectionAndTest({required WidgetTester tester}) async {
  await tester.tap(find.byType(BloqoFilledButton).first);
  await tester.pumpAndSettle();

  expect(find.byType(BloqoEditableSection), findsOne);
}

Future<void> publishCourseAndTest({required WidgetTester tester}) async {
  
  await tester.tap(find.text("Publish").first);
  await tester.pump();

  var textMap = {
    0: "English",
    1: "Education",
    2: "1 hour or less",
    3: "Lessons only",
    4: "For everyone"
  };

  for(int i = 0; i < 5; i++){
    await tester.tap(find.byType(BloqoDropdown).at(i));
    await tester.pumpAndSettle();
    await tester.tap(find.text(textMap[i]!).last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).at(i));
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, textMap[i]!);
  }

  await tester.tap(find.byType(BloqoFilledButton).last);
  await tester.pump();

  await tester.tap(find.text("OK").last);
  await tester.pump();

  await tester.runAsync(() async {
    await Future.delayed(const Duration(seconds: 3));
  });

  expect(find.byType(BloqoCourseCreated), findsOne);
}

Future<void> _completeSection({required WidgetTester tester}) async {

  await tester.runAsync(() async {
    await Future.delayed(const Duration(seconds: 3));
  });

  expect(find.byType(BloqoCourseSection), findsNothing);
  expect(find.text("Learned!"), findsOne);

  await tester.enterText(find.byType(BloqoTextField).first, "2");
  await tester.pump();

  await tester.tap(find.text("Confirm").first);
  await tester.pump();

  expect(find.text("Correct!"), findsExactly(3));

  await tester.tap(find.text("2").last);
  await tester.pump();

  await tester.tap(find.text("Confirm").first);
  await tester.pump();

  expect(find.text("Correct!"), findsExactly(5));

  await tester.tap(find.byType(BloqoFilledButton).last);
  await tester.pumpAndSettle();

  await tester.runAsync(() async {
    await Future.delayed(const Duration(seconds: 3));
  });
}

Future<void> completeFirstSectionAndTest({required WidgetTester tester}) async {
  await tester.tap(find.text("Start learning!").last);
  await tester.pumpAndSettle();

  await _completeSection(tester: tester);

  expect(find.text("50% of course completed"), findsOne);
}

Future<void> completeFinalSectionAndTest({required WidgetTester tester}) async {

  await tester.pumpAndSettle();
  await tester.tap(find.text("Continue learning!").last);
  await tester.pumpAndSettle();

  await _completeSection(tester: tester);

  expect(find.text("Course completed!"), findsOne);
}

Future<void> completeCourseAndTest({required WidgetTester tester}) async {

  await tester.tap(find.byType(BloqoCourseEnrolled).first);
  await tester.pumpAndSettle();

  expect(find.byType(BloqoCourseSection), findsAtLeast(2));
  expect(find.byType(BloqoFilledButton), findsExactly(2));

  await completeFirstSectionAndTest(tester: tester);

  await completeFinalSectionAndTest(tester: tester);

}

Future<void> tapBreadcrumbsByText({required WidgetTester tester, required String text}) async {
  final breadcrumbFinder = find.byWidgetPredicate(
        (widget) =>
    widget is RichText &&
        widget.text.toPlainText().contains(text),
  );
  await tester.tap(breadcrumbFinder);
  await tester.pumpAndSettle();
}