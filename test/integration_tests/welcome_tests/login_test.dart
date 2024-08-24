import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/bloqo_external_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bloqo/main.dart' as app;

import '../../mocks/mock_external_services.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login test', (WidgetTester tester) async {
    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.text('test'), findsAtLeast(1));
  });

  testWidgets('Cannot login with wrong email test', (WidgetTester tester) async {
    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.en');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOne);
  });

  testWidgets('Cannot login with wrong password test', (WidgetTester tester) async {
    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test12!');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOne);
  });

  testWidgets('Cannot login with no credentials', (WidgetTester tester) async {
    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOne);
  });

}