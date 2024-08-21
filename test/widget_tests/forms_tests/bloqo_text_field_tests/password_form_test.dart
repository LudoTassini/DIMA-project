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
                  validator: (password) {
                    return passwordValidator(password: password, localizedText: localizedText);
                  },
                ),
              ),
            );
          },
        ),
      )
    );
  }

  testWidgets('Password form present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoTextField), findsOneWidget);
  });

  testWidgets('Password form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'Password123!');
    await tester.pump(); // Let the form update

    expect(controller.text, 'Password123!');
  });

  testWidgets('Password form shows error if the password is too short', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'short');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a special character', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'Password123');
    await tester.pump(); // Let the form validate

    expect(
      find.text(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a number', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'Password!');
    await tester.pump(); // Let the form validate

    expect(
      find.text(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain an uppercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'password123!');
    await tester.pump(); // Let the form validate

    expect(
      find.text(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'PASSWORD123!');
    await tester.pump(); // Let the form validate

    expect(
      find.text(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form does not accept more than max length characters', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    // Generate a long string
    String longPassword = 'a' * (Constants.maxPasswordLength + 1);
    await tester.enterText(find.byType(TextField), longPassword);
    await tester.pump(); // Let the form update

    // The text in the controller should be truncated to max length
    expect(controller.text.length, Constants.maxPasswordLength);
  });

  testWidgets('Password form shows error if the password is too short and does not contain a special character', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'Short1');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short and does not contain a number', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'Short!');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short and does not contain an uppercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'short1!');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'SHORT1!');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a special character and does not contain a number', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'Password');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a special character and does not contain an uppercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'password123');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a special character and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'PASSWORD123');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a number and does not contain an uppercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'password!');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a number and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'PASSWORD!');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain an uppercase letter and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), '123456789!');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain a special character, and does not contain a number', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'short');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain a special character, and does not contain an uppercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'short');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain a special character, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'SHORT1');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain a number, and does not contain an uppercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'short');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain a number, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'SHORT!');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain an uppercase letter, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), '123!');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a special character, does not contain a number, and does not contain an uppercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'password');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a special character, does not contain a number, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'PASSWORD');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a special character, does not contain an uppercase letter, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), '123456789');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a number, does not contain an uppercase letter, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), '!!!!!!!!!!');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain a special character, does not contain a number, and does not contain an uppercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'short');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain a special character, does not contain a number, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'SHORT');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain a special character, does not contain an uppercase letter, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), '12345');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain a number, does not contain an uppercase letter, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), '!!!!!');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password does not contain a special character, does not contain a number, does not contain an uppercase letter, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), ' ' * 8);
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });

  testWidgets('Password form shows error if the password is too short, does not contain a special character, does not contain a number, does not contain an uppercase letter, and does not contain a lowercase letter', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.enterText(find.byType(TextField), 'test');
    await tester.enterText(find.byType(TextField), '');
    await tester.pump(); // Let the form validate

    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_short(Constants.minPasswordLength.toString())),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_special_char),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_number),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_uppercase),
      findsOneWidget,
    );
    expect(
      find.textContaining(getAppLocalizations(tester.element(find.byType(BloqoTextField)))!
          .error_password_lowercase),
      findsOneWidget,
    );
  });


}