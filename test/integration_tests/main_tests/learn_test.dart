import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/complex/bloqo_course_enrolled.dart';
import 'package:bloqo/components/complex/bloqo_course_section.dart';
import 'package:bloqo/components/complex/bloqo_user_details.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/bloqo_certificate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Users can see the content of a course they are following test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(1));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can view the QR code of a course they are following test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 3000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(1));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byIcon(Icons.qr_code_2));
    await tester.pump();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 2));
    });

    expect(find.byType(QrImageView), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can see the profile page of the author of a course they are following test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(1));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byType(BloqoTextButton).first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoUserDetails), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can collapse and expand the chapters of a course they are following test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(1));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsNothing);

    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(1));

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can unsubscribe from a course they are following test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(1));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pump();

    await tester.tap(find.text("OK").last);
    await tester.pump();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoCourseSection), findsNothing);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users cannot open a section that comes after a section that has not been completed test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(2));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byType(BloqoCourseSection).last);
    await tester.pump();

    expect(find.byType(BloqoCourseSection), findsAtLeast(2));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byType(BloqoCourseSection).first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoCourseSection), findsNothing);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can learn a section by clicking the first non-completed section test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(BloqoCourseSection), findsAtLeast(2));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byType(BloqoCourseSection).first);
    await tester.pump();

    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(BloqoCourseSection), findsNothing);
    expect(find.text("Learned!"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can learn the next section by clicking the specific button test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(2));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoCourseSection), findsNothing);
    expect(find.text("Learned!"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can complete a section test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(2));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await completeFirstSectionAndTest(tester: tester);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users cannot complete a section if (at least) one of the quizzes has not been submitted test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(2));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

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

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 1));
    });

    expect(find.byType(AlertDialog), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users know that a wrong open question answer is wrong, when it is confirmed test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(2));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoCourseSection), findsNothing);
    expect(find.text("Learned!"), findsOne);

    await tester.enterText(find.byType(BloqoTextField).first, "3");
    await tester.pump();

    await tester.tap(find.text("Confirm").first);
    await tester.pump();

    expect(find.text("Wrong..."), findsExactly(2));

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users know that a wrong multiple choice answer is wrong, when it is confirmed test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(2));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoCourseSection), findsNothing);
    expect(find.text("Learned!"), findsOne);

    await tester.tap(find.text("3").first);
    await tester.pump();

    await tester.tap(find.text("Confirm").last);
    await tester.pump();

    expect(find.text("Wrong..."), findsExactly(2));

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can complete a section test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(2));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await completeFirstSectionAndTest(tester: tester);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can complete a course test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await completeCourseAndTest(tester: tester);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can view any section when a course is completed test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await completeCourseAndTest(tester: tester);

    await tester.pumpAndSettle();
    await tester.tap(find.byType(BloqoCourseSection).first);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(BloqoCourseSection), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoCourseSection).last);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(BloqoCourseSection), findsNothing);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can view the completed course in the specific section test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await completeCourseAndTest(tester: tester);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    await tester.tap(find.text("Completed").first);
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(BloqoFilledButton), findsExactly(2));
    expect(find.text("Rate"), findsOne);
    expect(find.text("Get certificate"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can rate a completed course test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await completeCourseAndTest(tester: tester);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    await tester.tap(find.text("Completed").first);
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text("Rate"));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.star_border).at(2));
    await tester.pump();

    await tester.enterText(find.byType(BloqoTextField).first, "Title");
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(BloqoTextField).last, "Content");
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pump();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.text("Rate"), findsNothing);
    expect(find.text("Rated"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can view but cannot modify a review they have published about a completed course test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await completeCourseAndTest(tester: tester);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    await tester.tap(find.text("Completed").first);
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text("Rate"));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.star_border).at(2));
    await tester.pump();

    await tester.enterText(find.byType(BloqoTextField).first, "Title");
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(BloqoTextField).last, "Content");
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pump();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    await tester.tap(find.text("Rated"));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(BloqoFilledButton), findsNothing);

    await tester.tap(find.byIcon(Icons.star_border).at(0));
    await tester.pump();

    expect(find.byIcon(Icons.star), findsExactly(3));

    await tester.enterText(find.byType(BloqoTextField).first, "New Title");
    await tester.pumpAndSettle();

    expect(find.text("New Title"), findsNothing);

    await tester.enterText(find.byType(BloqoTextField).last, "New Content");
    await tester.pumpAndSettle();

    expect(find.text("New Content"), findsNothing);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users cannot rate a completed course if only partial review content is given test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await completeCourseAndTest(tester: tester);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    await tester.tap(find.text("Completed").first);
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text("Rate"));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.star_border).at(2));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOne);

    await tester.tap(find.text("OK"));
    await tester.pump();

    await tester.enterText(find.byType(BloqoTextField).first, "Title");
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can get the certificate for a completed course test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    await completeCourseAndTest(tester: tester);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    await tester.tap(find.text("Completed").first);
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text("Get certificate"));
    await tester.pump();

    expect(find.byType(BloqoCertificate), findsOne);

    await binding.setSurfaceSize(null);
  });

}