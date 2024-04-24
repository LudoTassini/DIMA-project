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
                      labelText: loc.username,
                      hintText: loc.username_hint,
                      maxInputLength: Constants.maxUsernameLength,
                      validator: (username) {
                        return usernameValidator(username: username, localizedText: loc);
                      }
                  ),
                )
            );
          }
      )
  );

  testWidgets('Username form present', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    expect(find.text(getAppLocalizations(sharedContext)!.username), findsOneWidget);
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
    var errorText = getAppLocalizations(sharedContext)!.error_username_short(Constants.minUsernameLength.toString());
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Username form displays error when wrong username is given (not alphanumeric)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    const enteredText = "test_";
    var errorText = getAppLocalizations(sharedContext)!.error_username_alphanumeric;
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pump(const Duration(milliseconds: 100)); // delay for validation
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

}