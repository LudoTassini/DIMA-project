import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:bloqo/utils/text_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Initializing BloqoTextField outside the testWidgets function
  final formKey = GlobalKey<FormState>();
  final testedWidget = MaterialApp(
      home: Scaffold(
          body: Form(
            key: formKey,
            child: BloqoTextField(
                formKey: formKey,
                controller: TextEditingController(),
                labelText: "Username",
                hintText: "hint",
                maxInputLength: Constants.maxUsernameLength,
                validator: (username) { return usernameValidator(username); }
            ),
          ),
      )
  );

  testWidgets('Username form present', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    expect(find.text('Username'), findsOneWidget);
  });

  testWidgets('Username form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "testusername";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    expect(find.text(enteredText), findsOneWidget);
  });

  testWidgets('Username form displays error when wrong username is given (too short)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "tst";
    const errorText = "The username must be at least ${Constants.minUsernameLength} characters long.";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Username form displays error when wrong username is given (not alphanumeric)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "test_";
    const errorText = "The username must be alphanumeric.";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

}