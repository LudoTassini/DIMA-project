import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:bloqo/utils/text_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  late BuildContext sharedContext;

  // Initializing BloqoTextField outside the testWidgets function
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  final testedWidget = MaterialApp(
    localizationsDelegates: getLocalizationDelegates(),
    supportedLocales: getSupportedLocales(),
    home: Builder(
      builder: (BuildContext context) {
        sharedContext = context;
        var localizedText = getAppLocalizations(sharedContext)!;
        return Scaffold(
          body: Form(
            key: formKey,
            child: BloqoTextField(
                formKey: formKey,
                controller: controller,
                labelText: localizedText.email,
                hintText: localizedText.email_hint,
                maxInputLength: Constants.maxEmailLength,
                validator: (email) {
                  return emailValidator(email: email, localizedText: localizedText);
                }
            ),
          )
        );
      }
    )
  );

  testWidgets('Email form present', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    expect(find.byType(BloqoTextField), findsOneWidget);
  });

  testWidgets('Email form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "testmail@bloqo.com";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    expect(find.text(enteredText), findsOneWidget);
    expect(controller.text, enteredText);
  });

  testWidgets('Email form displays error when wrong email is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "testmail@bloqo.";
    var errorText = getAppLocalizations(sharedContext)!.error_enter_valid_email;
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

}