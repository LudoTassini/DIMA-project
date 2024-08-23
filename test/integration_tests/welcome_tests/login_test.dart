import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/bloqo_external_services.dart';
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
}