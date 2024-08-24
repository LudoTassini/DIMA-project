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

  testWidgets('Users can navigate back thanks to the app bar', (WidgetTester tester) async {
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

    expect(find.byIcon(Icons.arrow_back), findsNothing);

    await tester.tap(find.text("Search"));
    await tester.pump();

    expect(find.byIcon(Icons.arrow_back), findsNothing);

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back), findsOne);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back), findsNothing);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can view notifications and go back to the previous page', (WidgetTester tester) async {
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

    expect(find.byIcon(Icons.arrow_back), findsNothing);

    await tester.tap(find.byIcon(Icons.notifications), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.notifications), findsNothing);
    expect(find.byIcon(Icons.arrow_back), findsOne);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byIcon(Icons.notifications), findsOne);

    await binding.setSurfaceSize(null);
  });

}