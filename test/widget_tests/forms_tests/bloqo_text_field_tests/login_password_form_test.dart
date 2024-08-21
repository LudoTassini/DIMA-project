import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:bloqo/utils/text_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
        ],
        child: Builder(
          builder: (BuildContext context) {
            var localizedText = getAppLocalizations(context)!;
            return Scaffold(
              body: Form(
                key: formKey,
                child: BloqoTextField(
                  formKey: formKey,
                  controller: controller,
                  labelText: localizedText.password,
                  hintText: localizedText.password_hint,
                  maxInputLength: Constants.maxPasswordLength,
                  obscureText: true,
                  validator: (password) {
                    return passwordValidator(
                        password: password, localizedText: localizedText);
                  },
                ),
              ),
            );
          },
        ),
      )
    );
  }

  testWidgets('Login password form present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoTextField), findsOneWidget);
  });

  testWidgets('Login password form registers text even if it is obscured', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'Password123!');
    await tester.pump(); // Let the form update

    expect(controller.text, 'Password123!');

    // Verify the obscureText property is true in the TextField widget
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.obscureText, isTrue);

    // Verify that the text is not displayed in plain text
    final editableTextFinder = find.descendant(
      of: find.byType(TextField),
      matching: find.byType(EditableText),
    );
    final editableText = tester.widget<EditableText>(editableTextFinder);
    expect(editableText.controller.text, 'Password123!');
    expect(editableText.obscureText, isTrue);
  });
}