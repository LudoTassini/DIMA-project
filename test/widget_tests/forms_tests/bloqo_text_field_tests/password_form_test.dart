import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:bloqo/utils/text_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //TODO
  // Initializing BloqoTextField outside the testWidgets function
  final formKey = GlobalKey<FormState>();
  BuildContext context;
  final localizedText = getAppLocalizations(context)!;
  final testedWidget = MaterialApp(
      home: Scaffold(
          body: Form(
            key: formKey,
            child: BloqoTextField(
              formKey: formKey,
              controller: TextEditingController(),
              labelText: "Password",
              hintText: "type your password here",
              maxInputLength: Constants.maxPasswordLength,
              validator: (password) { return passwordValidator(password: password, localizedText: localizedText); },
          ),
        )
      )
  );

  testWidgets('Password form present', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('Password form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "Password81!";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    expect(find.text(enteredText), findsOneWidget);
  });

// --------------------------------------------------------------------------------------------------------
// Tests on one single condition of the password

  testWidgets('Password form displays error when password with less than 8 characters is given',
          (WidgetTester tester) async {
        await tester.pumpWidget(testedWidget);
        const enteredText = "Pas8!";
        const errorText = 'Password must be at least ${Constants.minPasswordLength} characters long.';
        final foundWidget = find.byType(BloqoTextField);
        expect(foundWidget, findsOneWidget);

        await tester.enterText(foundWidget, enteredText);
        await tester.pump(const Duration(milliseconds: 100)); // delay for validation
        expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
      });

  // FIXME: failed
  testWidgets('Password form displays error when password with more than 32 characters is given',
          (WidgetTester tester) async {
        await tester.pumpWidget(testedWidget);
        const enteredText = "PasswordPasswordPasswordPasswo8!";
        const errorText = 'Password must be at most ${Constants.maxPasswordLength} characters long.';
        final foundWidget = find.byType(BloqoTextField);
        expect(foundWidget, findsOneWidget);

        await tester.enterText(foundWidget, enteredText);
        await tester.pump(const Duration(milliseconds: 100)); // delay for validation
        expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
      });

  testWidgets('Password form displays error when password without at least one special character is given',
          (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "Password81";
    const errorText = 'Password must contain at least one special character.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Password form displays error when password without at least a number is given',
          (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "Password!";
    const errorText = 'Password must contain at least one number.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Password form displays error when password without at least one upper case character is given',
          (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "password!8";
    const errorText = 'Password must contain at least one uppercase letter.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Password form displays error when password without at least one lower case character is given',
          (WidgetTester tester) async {
        await tester.pumpWidget(testedWidget);
        const enteredText = "PASSWORD!8";
        const errorText = 'Password must contain at least one lowercase letter.';
        final foundWidget = find.byType(BloqoTextField);
        expect(foundWidget, findsOneWidget);

        await tester.enterText(foundWidget, enteredText);
        await tester.pump(const Duration(milliseconds: 100)); // delay for validation
        expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
      });

  // --------------------------------------------------------------------------------------------------------
  // Tests on two conditions of the password
  // Tests where the password is less than 8 characters + other conditions

  testWidgets('Password form displays error when password with less than 8 characters and without at least one '
      'special character is given', (WidgetTester tester) async {
        await tester.pumpWidget(testedWidget);
        const enteredText = "Pas8";
        const errorText = 'Password must be at least ${Constants.minPasswordLength} characters long.\n'
            'Password must contain at least one special character.';
        final foundWidget = find.byType(BloqoTextField);
        expect(foundWidget, findsOneWidget);

        await tester.enterText(foundWidget, enteredText);
        await tester.pump(const Duration(milliseconds: 100)); // delay for validation
        expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
      });

  testWidgets('Password form displays error when password with less than 8 characters and without at least one '
      'number is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "Pas!";
    const errorText = 'Password must be at least ${Constants.minPasswordLength} characters long.\n'
        'Password must contain at least one number.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Password form displays error when password with less than 8 characters and without at least one '
      'uppercase character is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "pas8!";
    const errorText = 'Password must be at least ${Constants.minPasswordLength} characters long.\n'
        'Password must contain at least one uppercase letter.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Password form displays error when password with less than 8 characters and without at least one '
      'lowercase character is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "PAS8!";
    const errorText = 'Password must be at least ${Constants.minPasswordLength} characters long.\n'
        'Password must contain at least one lowercase letter.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  // --------------------------------------------------------------------------------------------------------
  // Tests on two conditions of the password
  // Tests where the password is more than 32 characters + other conditions

  // FIXME: failed
  testWidgets('Password form displays error when password with more than 32 characters and without at least one '
      'special character is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "PasswordPasswordPasswordPasswordPassword88";
    const errorText = 'Password must be at most ${Constants.maxPasswordLength} characters long.\n'
        'Password must contain at least one special character.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  // FIXME: failed
  testWidgets('Password form displays error when password with more than 32 characters and without at least one '
      'number is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "PasswordPasswordPasswordPasswordPassword!!!";
    const errorText = 'Password must be at most ${Constants.maxPasswordLength} characters long.\n'
        'Password must contain at least one number.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  // FIXME: failed
  testWidgets('Password form displays error when password with more than 32 characters and without at least one '
      'uppercase character is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "passwordpasswordpasswordpasswordpassword88!!!";
    const errorText = 'Password must be at most ${Constants.maxPasswordLength} characters long.\n'
        'Password must contain at least one uppercase letter.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  // FIXME: failed
  testWidgets('Password form displays error when password with more than 32 characters and without at least one '
      'lowercase character is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "PASSWORDPASSWORDPASSWORDPASSWORDPASSWORDPASSWORDPASSWORD88!!!";
    const errorText = 'Password must be at most ${Constants.maxPasswordLength} characters long.\n'
        'Password must contain at least one lowercase letter.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  // --------------------------------------------------------------------------------------------------------
  // Tests on two conditions of the password
  // Tests where the password does not contain at least one special character + other conditions

  testWidgets('Password form displays error when password without at least one special character'
      'and without at least one number is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "Password";
    const errorText = 'Password must contain at least one special character.\n'
        'Password must contain at least one number.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Password form displays error when password without at least one special character'
      ' and without at least one uppercase character is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "password88";
    const errorText = 'Password must contain at least one special character.\n'
        'Password must contain at least one uppercase letter.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Password form displays error when password without at least one special character'
      ' and without at least one lowercase character is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "PASSWORD88";
    const errorText = 'Password must contain at least one special character.\n'
        'Password must contain at least one lowercase letter.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  // --------------------------------------------------------------------------------------------------------
  // Tests on two conditions of the password
  // Tests where the password does not contain at least one uppercase character + other conditions

}

String createPasswordErrorString(List<bool> validationResults) {
  String messages = "";

  if (!validationResults[0]) {
    messages += 'Password must be at least ${Constants
        .minPasswordLength} characters long.\n';
  }
  if (!validationResults[1]) {
    messages += 'Password must be at most ${Constants
        .maxPasswordLength} characters long.\n';
  }
  if (!validationResults[2]) {
    messages += 'Password must contain at least one special character.\n';
  }
  if (!validationResults[3]) {
    messages += 'Password must contain at least one number.\n';
  }
  if (!validationResults[4]) {
    messages += 'Password must contain at least one uppercase letter.\n';
  }
  if (!validationResults[5]) {
    messages += 'Password must contain at least one lowercase letter.\n';
  }
  return messages.trim();
}