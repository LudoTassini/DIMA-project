import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloqo/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login test', (WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle();

    // enters credentials
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // tap login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    // see if the home page has been loaded
    expect(find.text('Test'), findsOneWidget);
  });
}