import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:bloqo/utils/text_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/widget_test.dart';

Future<void> main() async {

  //late BuildContext sharedContext;

  // Initializing BloqoTextField outside the testWidgets function
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  /*final testedWidget = MaterialApp(
    localizationsDelegates: getLocalizationDelegates(),
    supportedLocales: getSupportedLocales(),
    home: Builder(
      builder: (BuildContext context) {
        sharedContext = context;
        var loc = getAppLocalizations(sharedContext)!;
        return Scaffold(
          body: Form(
            key: formKey,
            child: BloqoTextField(
                formKey: formKey,
                controller: controller,
                labelText: loc.email,
                hintText: loc.email_hint,
                maxInputLength: Constants.maxEmailLength,
                validator: (email) {
                  return emailValidator(email: email, context: context);
                }
            ),
          )
        );
      }
    )
  );*/

  WidgetTest test = await initWidgetTest();
  test.pumpWidget(
    widget: Form(
      key: formKey,
        child: BloqoTextField(
          formKey: formKey,
          controller: controller,
          labelText: test.localizedText.email,
          hintText: test.localizedText.email_hint,
          maxInputLength: Constants.maxEmailLength,
          validator: (email) { return emailValidator(email: email, localizedText: test.localizedText);}
        ),
      )
  );

  testWidgets('Email form present', (WidgetTester tester) async {
    await tester.pumpWidget(test.app);
    expect(find.text(getAppLocalizations(test.context)!.email), findsOneWidget);
  });

  testWidgets('Email form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(test.app);
    const enteredText = "testmail@bloqo.com";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    expect(find.text(enteredText), findsOneWidget);
    expect(controller.text, enteredText);
  });

  testWidgets('Email form displays error when wrong email is given', (WidgetTester tester) async {
    await tester.pumpWidget(test.app);
    const enteredText = "testmail@bloqo.";
    const errorText = 'Please enter a valid email address.';
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

}