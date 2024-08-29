import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/complex/bloqo_editable_block.dart';
import 'package:bloqo/components/complex/bloqo_editable_chapter.dart';
import 'package:bloqo/components/complex/bloqo_editable_section.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Users can go back from editing block to editing section through breadcrumbs test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Editor");

    await createNewCourseAndTest(tester: tester);

    await createNewChapterAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await createNewSectionAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Text Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Text"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoBreadcrumbs), findsOne);
    expect(find.byType(BloqoEditableBlock), findsNothing);

    await tapBreadcrumbsByText(tester: tester, text: "Section 1");

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Text"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can go back from editing block to editing chapter through breadcrumbs test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Editor");

    await createNewCourseAndTest(tester: tester);

    await createNewChapterAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await createNewSectionAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Text Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Text"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoBreadcrumbs), findsOne);
    expect(find.byType(BloqoEditableBlock), findsNothing);

    await tapBreadcrumbsByText(tester: tester, text: "Chapter 1");

    expect(find.byType(BloqoEditableSection), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can go back from editing block to editing course through breadcrumbs test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Editor");

    await createNewCourseAndTest(tester: tester);

    await createNewChapterAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await createNewSectionAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Text Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Text"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoBreadcrumbs), findsOne);
    expect(find.byType(BloqoEditableBlock), findsNothing);

    await tapBreadcrumbsByText(tester: tester, text: "Course");

    expect(find.byType(BloqoEditableChapter), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can go back from editing section to editing chapter through breadcrumbs test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Editor");

    await createNewCourseAndTest(tester: tester);

    await createNewChapterAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await createNewSectionAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Text Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Text"), findsOne);

    await tapBreadcrumbsByText(tester: tester, text: "Chapter 1");

    expect(find.byType(BloqoEditableSection), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can go back from editing section to editing course through breadcrumbs test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Editor");

    await createNewCourseAndTest(tester: tester);

    await createNewChapterAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await createNewSectionAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Text Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Text"), findsOne);

    await tapBreadcrumbsByText(tester: tester, text: "Course");

    expect(find.byType(BloqoEditableChapter), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can go back from editing chapter to editing course through breadcrumbs test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Editor");

    await createNewCourseAndTest(tester: tester);

    await createNewChapterAndTest(tester: tester);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await createNewSectionAndTest(tester: tester);

    await tapBreadcrumbsByText(tester: tester, text: "Course");

    expect(find.byType(BloqoEditableChapter), findsOne);

    await binding.setSurfaceSize(null);
  });

}