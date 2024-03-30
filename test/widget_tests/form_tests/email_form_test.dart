import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:bloqo/utils/text_parser.dart';
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
          labelText: "Email",
          hintText: "hint",
          maxInputLength: Constants.maxEmailLength,
          validator: (String? value) {
            return (value == null || !TextParser.isEmail(value)) ? 'Please enter a valid email address.' : null;
          }
        ),
      )
    )
  );

  testWidgets('Email form present', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    expect(find.text('Email'), findsOneWidget);
  });

  testWidgets('Email form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "testmail@bloqo.com";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    expect(find.text(enteredText), findsOneWidget);
  });

  testWidgets('Email form displays error when wrong email is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "testmail@bloqo.";
    const errorText = 'Please enter a valid email address.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

}

