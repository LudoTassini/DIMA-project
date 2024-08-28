import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  bool confirmed = false;

  setUp(() {
    confirmed = false;
  });

  // Helper function to build the test app
  Widget buildTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
      ],
      child: MaterialApp(
        localizationsDelegates: getLocalizationDelegates(),
        supportedLocales: getSupportedLocales(),
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    showBloqoConfirmationAlert(
                      context: context,
                      title: 'Test Title',
                      description: 'Test Description',
                      backgroundColor: Colors.white,
                      confirmationFunction: () {
                        confirmed = true;
                      }
                    );
                  },
                  child: const Text('Show Alert'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  testWidgets('Confirmation alert is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.text('Show Alert'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    expect(find.byType(BloqoConfirmationAlert), findsOneWidget);
  });

  testWidgets('Confirmation alert closes when OK button is pressed and gives confirmation', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.text('Show Alert'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Close the alert
    await tester.tap(find.text(getAppLocalizations(tester.element(find.byType(BloqoConfirmationAlert)))!.ok));
    await tester.pumpAndSettle();

    // Verify the alert is dismissed
    expect(find.byType(BloqoConfirmationAlert), findsNothing);
    expect(confirmed, isTrue);
  });

  testWidgets('Confirmation alert closes when Cancel button is pressed and does not give confirmation', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.text('Show Alert'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Close the alert
    await tester.tap(find.text(getAppLocalizations(tester.element(find.byType(BloqoConfirmationAlert)))!.cancel));
    await tester.pumpAndSettle();

    // Verify the alert is dismissed
    expect(find.byType(BloqoConfirmationAlert), findsNothing);
    expect(confirmed, isFalse);
  });
}