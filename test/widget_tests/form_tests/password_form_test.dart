import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:bloqo/utils/text_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //TODO
  // Initializing BloqoTextField outside the testWidgets function
  final formKey = GlobalKey<FormState>();
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
              validator: (String? value) {
                if(value == null){
                  return "The password cannot be empty.";
                }
                List<bool> results = TextParser.validatePassword(value);
                int count = 0;
                for (bool result in results){
                  if(result){
                    count++;
                  }
                }
                if(count==results.length){
                  return null;
                }
                else {
                  String errorMessage = createPasswordErrorString(results);
                  return errorMessage;
                }
              },
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

  // FIXME: test failed
  testWidgets('Password form displays error when wrong password is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "Pass";
    const errorText = 'Password must be at least ${Constants
        .minPasswordLength} characters long.\n';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

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