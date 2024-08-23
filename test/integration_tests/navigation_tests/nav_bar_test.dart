import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/bloqo_external_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bloqo/main.dart' as app;

import '../../mocks/mock_external_services.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Users can navigate from and to main stacks test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Learn"));
    await tester.pump();

    expect(find.text("Learn"), findsExactly(2));

    await tester.tap(find.text("Search"));
    await tester.pump();
    expect(find.text("Search"), findsExactly(3));

    await tester.tap(find.text("Editor"));
    await tester.pump();
    expect(find.text("Editor"), findsExactly(2));

    await tester.tap(find.text("Account"));
    await tester.pump();
    expect(find.text("Account"), findsExactly(1));

    await tester.tap(find.text("Home"));
    await tester.pump();
    expect(find.text("Home"), findsExactly(1));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can go back to the origin of the main stack by clicking on the same icon test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();
    expect(find.byType(BloqoFilledButton), findsNothing);

    await tester.tap(find.text("Search").last);
    await tester.pump();
    expect(find.text("Search"), findsExactly(3));

    await binding.setSurfaceSize(null);
  });

}