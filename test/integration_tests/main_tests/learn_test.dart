import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/complex/bloqo_course_enrolled.dart';
import 'package:bloqo/components/complex/bloqo_course_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Users can see the content of a course they are following test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

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
    await binding.setSurfaceSize(const Size(1000, 2000));

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

}