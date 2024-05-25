import 'package:bloqo/components/forms/bloqo_dropdown.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final formKey = GlobalKey<FormState>();
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      localizationsDelegates: getLocalizationDelegates(),
      supportedLocales: getSupportedLocales(),
      home: Scaffold(
        body: BloqoDropdown(
          controller: controller,
          dropdownMenuEntries: const [
            DropdownMenuEntry(value: "Test 1", label: "Test 1"),
            DropdownMenuEntry(value: "Test 2", label: "Test 2"),
          ],
        ),
      ),
    );
  }

  testWidgets('Dropdown form present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoDropdown), findsOneWidget);
  });

  testWidgets('Dropdown form shows all the entries', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.byType(BloqoDropdown));
    await tester.pump(); // Wait for the dropdown to open

    expect(find.text("Test 1").evaluate().length, 2); // One for menu entry, one for selected value
    expect(find.text("Test 2").evaluate().length, 2); // One for menu entry, one for selected value
  });

  testWidgets('Dropdown form registers a choice', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.byType(BloqoDropdown));
    await tester.pump(); // Wait for the dropdown to open

    await tester.tap(find.text("Test 1").last);
    await tester.pump(); // Wait for the dropdown to close

    expect(controller.text, "Test 1");
  });

  testWidgets('Dropdown form allows changing a previously done choice', (WidgetTester tester) async {
    controller.text = "Test 1";
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.byType(BloqoDropdown));
    await tester.pump(); // Wait for the dropdown to open

    await tester.tap(find.text("Test 2").last);
    await tester.pump(); // Wait for the dropdown to close

    expect(controller.text, "Test 2");
  });
}
