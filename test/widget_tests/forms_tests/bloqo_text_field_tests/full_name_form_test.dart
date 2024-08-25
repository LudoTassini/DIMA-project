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
        child:  Builder(
          builder: (BuildContext context) {
            var localizedText = getAppLocalizations(context)!;
            return Scaffold(
              body: Form(
                key: formKey,
                child: BloqoTextField(
                  formKey: formKey,
                  controller: controller,
                  labelText: localizedText.full_name,
                  hintText: localizedText.full_name_hint,
                  maxInputLength: Constants.maxFullNameLength,
                  validator: (fullName) {
                    return fullNameValidator(fullName: fullName, localizedText: localizedText);
                  },
                ),
              ),
            );
          },
        ),
      )
    );
  }

  testWidgets('Full name form present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoTextField), findsOneWidget);
  });

  testWidgets('Full name form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    const enteredText = "testfullname";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();
    expect(find.text(enteredText), findsOneWidget);
    expect(controller.text, enteredText);
  });

  testWidgets('Full name form displays error when no full name is given', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    var errorText = getAppLocalizations(tester.element(find.byType(BloqoTextField)))!.error_full_name_empty;
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    // Enter text and then clear it to trigger validation
    await tester.enterText(foundWidget, 'test');
    await tester.enterText(foundWidget, '');
    await tester.pumpAndSettle();
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });

  testWidgets('Full name form displays error when wrong full name is given (not alphanumeric)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    const enteredText = "test_";
    var errorText = getAppLocalizations(tester.element(find.byType(BloqoTextField)))!.error_full_name_alphanumeric;
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });
}
