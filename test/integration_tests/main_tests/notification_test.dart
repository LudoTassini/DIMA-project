import 'package:bloqo/components/notifications/bloqo_course_enrollment_request_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Users can open notifications and remove one test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.byType(Positioned).first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 1));
    });

    expect(find.byType(BloqoCourseEnrollmentRequestNotification), findsOne);

    await tester.tap(find.text("Deny").first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("OK").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 1));
    });

    expect(find.byType(BloqoCourseEnrollmentRequestNotification), findsNothing);

    await binding.setSurfaceSize(null);
  });
}