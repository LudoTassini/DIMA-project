import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper function to build the test app
  Widget buildTestWidget(TextEditingController controller) {
    return MaterialApp(
      localizationsDelegates: getLocalizationDelegates(),
      supportedLocales: getSupportedLocales(),
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            final localizedText = getAppLocalizations(context)!;
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2024),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2100),
                    keyboardType: TextInputType.datetime,
                    confirmText: localizedText.ok,
                    cancelText: localizedText.cancel,
                    errorFormatText: localizedText.error_invalid_date_format,
                    errorInvalidText: localizedText.error_date_out_of_range
                  );

                  if (selectedDate != null) {
                    controller.text = selectedDate.toIso8601String();
                  } else {
                    controller.clear();
                  }
                },
                child: const Text('Show Date Picker'),
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('Date picker is displayed', (WidgetTester tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(buildTestWidget(controller));
    await tester.tap(find.text('Show Date Picker'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('Date picker registers date when a date is chosen and OK button is pressed', (WidgetTester tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(buildTestWidget(controller));
    await tester.tap(find.text('Show Date Picker'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Select a date
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    // Press OK button
    await tester.tap(find.text(getAppLocalizations(tester.element(find.byType(DatePickerDialog)))!.ok));
    await tester.pumpAndSettle();

    // Ensure that the dialog is dismissed
    expect(find.byType(DatePickerDialog), findsNothing);

    // Verify that the date is set in the controller
    expect(controller.text.isNotEmpty, true);
  });

  testWidgets('Date picker allows to change month', (WidgetTester tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(buildTestWidget(controller));
    await tester.tap(find.text('Show Date Picker'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Tap the next month button
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    // Verify that the month has changed (e.g., checking if the month text has changed)
    expect(find.text('February 2024'), findsOneWidget);
  });

  testWidgets('Date picker allows to change from day selection to year selection', (WidgetTester tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(buildTestWidget(controller));
    await tester.tap(find.text('Show Date Picker'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Tap to open year selection dropdown
    await tester.tap(find.text('January 2024'));
    await tester.pumpAndSettle();

    expect(find.text('2024'), findsOneWidget);
  });

  testWidgets('Date picker allows to change year from year selection', (WidgetTester tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(buildTestWidget(controller));
    await tester.tap(find.text('Show Date Picker'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Tap to open year selection dropdown
    await tester.tap(find.text('January 2024'));
    await tester.pumpAndSettle();

    // Select a different year
    await tester.tap(find.text('2025'));
    await tester.pumpAndSettle();

    // Verify that the year has changed
    expect(find.text('January 2025'), findsOneWidget);
  });

  testWidgets('Date picker allows to change date selection mode', (WidgetTester tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(buildTestWidget(controller));
    await tester.tap(find.text('Show Date Picker'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Tap to switch to manual input mode (in Flutter, this is often represented by an icon button to switch input modes)
    await tester.tap(find.byIcon(Icons.edit_outlined));  // Assumption: There is an icon button for switching to manual input mode
    await tester.pumpAndSettle();

    // Ensure that the text field for manual date input is displayed
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Date picker allows to change date selection mode and enter a date in such way', (WidgetTester tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(buildTestWidget(controller));
    await tester.tap(find.text('Show Date Picker'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Tap to switch to manual input mode
    await tester.tap(find.byIcon(Icons.edit_outlined));  // Assumption: There is an icon button for switching to manual input mode
    await tester.pumpAndSettle();

    // Enter a date manually
    await tester.enterText(find.byType(TextField), '6/15/2025');
    await tester.pumpAndSettle();

    // Press OK button
    await tester.tap(find.text(getAppLocalizations(tester.element(find.byType(DatePickerDialog)))!.ok));
    await tester.pumpAndSettle();

    // Ensure that the dialog is dismissed
    expect(find.byType(DatePickerDialog), findsNothing);

    // Verify that the date is set in the controller
    expect(controller.text, '2025-06-15T00:00:00.000'); // assuming the text is stored in ISO 8601 format
  });

  testWidgets('Date picker allows to change date selection mode and shows an error if the entered date is badly formatted', (WidgetTester tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(buildTestWidget(controller));
    await tester.tap(find.text('Show Date Picker'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Tap to switch to manual input mode
    await tester.tap(find.byIcon(Icons.edit_outlined));  // Assumption: There is an icon button for switching to manual input mode
    await tester.pumpAndSettle();

    // Enter a badly formatted date
    await tester.enterText(find.byType(TextField), 'bad-date-format');
    await tester.pumpAndSettle();

    // Press OK button
    await tester.tap(find.text(getAppLocalizations(tester.element(find.byType(DatePickerDialog)))!.ok));
    await tester.pumpAndSettle();

    // Verify that an error is shown (assume an error message widget is shown)
    expect(find.text(getAppLocalizations(tester.element(find.byType(DatePickerDialog)))!.error_invalid_date_format), findsOneWidget);
  });

  testWidgets('Date picker allows to change date selection mode and shows an error if the entered date is out of range', (WidgetTester tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(buildTestWidget(controller));
    await tester.tap(find.text('Show Date Picker'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Tap to switch to manual input mode
    await tester.tap(find.byIcon(Icons.edit_outlined));  // Assumption: There is an icon button for switching to manual input mode
    await tester.pumpAndSettle();

    // Enter a date out of range
    await tester.enterText(find.byType(TextField), '1/1/2101');
    await tester.pumpAndSettle();

    // Press OK button
    await tester.tap(find.text(getAppLocalizations(tester.element(find.byType(DatePickerDialog)))!.ok));
    await tester.pumpAndSettle();

    // Verify that an error is shown (assume an error message widget is shown)
    expect(find.text(getAppLocalizations(tester.element(find.byType(DatePickerDialog)))!.error_date_out_of_range), findsOneWidget);
  });

  testWidgets('Date picker allows to clear date when cancel is pressed', (WidgetTester tester) async {
    TextEditingController controller = TextEditingController();
    await tester.pumpWidget(buildTestWidget(controller));
    await tester.tap(find.text('Show Date Picker'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Press the Cancel button
    await tester.tap(find.text(getAppLocalizations(tester.element(find.byType(DatePickerDialog)))!.cancel));
    await tester.pumpAndSettle();

    // Ensure that the dialog is dismissed
    expect(find.byType(DatePickerDialog), findsNothing);

    // Verify that no date was selected (controller should be cleared)
    expect(controller.text.isEmpty, true);
  });
}
