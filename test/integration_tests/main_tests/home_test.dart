import 'package:bloqo/components/complex/bloqo_course_created.dart';
import 'package:bloqo/components/complex/bloqo_course_enrolled.dart';
import 'package:bloqo/components/complex/bloqo_course_section.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Users can easily start modifying a course they have already created by clicking the correct instance test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.byType(BloqoCourseCreated).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoTextField), findsExactly(2));

    await binding.setSurfaceSize(null);
  });

  testWidgets(
      'Users can easily continue learning from a course they have already enrolled in test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.byType(BloqoCourseEnrolled).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoCourseSection), findsAtLeast(1));

    await binding.setSurfaceSize(null);
  });

}