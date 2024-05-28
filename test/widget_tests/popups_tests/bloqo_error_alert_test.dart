import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloqo/components/popups/bloqo_error_alert.dart';

void main() {
  // Helper function to build the test app
  Widget buildTestWidget() {
    return MaterialApp(
      localizationsDelegates: getLocalizationDelegates(),
      supportedLocales: getSupportedLocales(),
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  showBloqoErrorAlert(
                    context: context,
                    title: 'Test Title',
                    description: 'Test Description',
                  );
                },
                child: const Text('Show Alert'),
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('Error alert is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.text('Show Alert'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    expect(find.byType(BloqoErrorAlert), findsOneWidget);
  });

  testWidgets('Error alert closes when OK button is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.text('Show Alert'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Close the alert
    await tester.tap(find.text(getAppLocalizations(tester.element(find.byType(BloqoErrorAlert)))!.ok));
    await tester.pumpAndSettle();

    // Verify the alert is dismissed
    expect(find.byType(BloqoErrorAlert), findsNothing);
  });
}
