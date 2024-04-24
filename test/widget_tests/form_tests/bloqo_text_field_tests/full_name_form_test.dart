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
            var loc = getAppLocalizations(sharedContext)!;
            return Scaffold(
                body: Form(
                  key: formKey,
                  child: BloqoTextField(
                      formKey: formKey,
                      controller: controller,
                      labelText: loc.full_name,
                      hintText: loc.full_name_hint,
                      maxInputLength: Constants.maxFullNameLength,
                      validator: (fullName) {
                        return fullNameValidator(fullName: fullName, localizedText: loc);
                      }
                  ),
                )
            );
          }
      )
  );

  testWidgets('Full name form present', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    expect(find.text(getAppLocalizations(sharedContext)!.full_name), findsOneWidget);
  });

  testWidgets('Full name form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "testfullname";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    expect(find.text(enteredText), findsOneWidget);
  });

  //TODO: don't know how to fix this code
  /*testWidgets('Full name form displays error when no full name is given', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "test";
    const errorText = "The full name must not be empty.";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.enterText(foundWidget, '');
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });*/

  testWidgets('Full name form displays error when wrong full name is given (not alphanumeric)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "test_";
    const errorText = "The full name must be alphanumeric (spaces are allowed).";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

}