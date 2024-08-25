import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/bloqo_external_services.dart';
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