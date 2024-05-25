import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:bloqo/utils/text_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Initializing BloqoTextField outside the testWidgets function
  final formKey = GlobalKey<FormState>();
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      localizationsDelegates: getLocalizationDelegates(),
      supportedLocales: getSupportedLocales(),
      home: Builder(
        builder: (BuildContext context) {
          var localizedText = getAppLocalizations(context)!;
          return Scaffold(
            body: Form(
              key: formKey,
              child: BloqoTextField(
                formKey: formKey,
                controller: controller,
                labelText: localizedText.username,
                hintText: localizedText.username_hint,
                maxInputLength: Constants.maxUsernameLength,
                validator: (username) {
                  return usernameValidator(username: username, localizedText: localizedText);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  testWidgets('Username form present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoTextField), findsOneWidget);
  });

  testWidgets('Username form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    const enteredText = "testusername";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();
    expect(find.text(enteredText), findsOneWidget);
    expect(controller.text, enteredText);
  });

  testWidgets('Username form displays error when wrong username is given (too short)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    const enteredText = "tst";
    var errorText = getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
        .error_username_short(Constants.minUsernameLength.toString());
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.tap(find.byType(Form)); // Trigger validation by tapping outside the text field
    await tester.pumpAndSettle(); // Wait for the error message to appear
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Username form displays error when wrong username is given (not alphanumeric)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    const enteredText = "test_";
    var errorText = getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
        .error_username_alphanumeric;
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.tap(find.byType(Form)); // Trigger validation by tapping outside the text field
    await tester.pumpAndSettle(); // Wait for the error message to appear
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });
}
