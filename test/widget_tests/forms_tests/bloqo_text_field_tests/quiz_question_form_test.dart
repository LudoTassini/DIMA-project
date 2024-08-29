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
                    labelText: localizedText.question,
                    hintText: localizedText.enter_question_here,
                    maxInputLength: Constants.maxQuizQuestionLength,
                    isTextArea: true,
                    validator: (question) {
                      return quizQuestionValidator(quizQuestion: question, localizedText: localizedText);
                    },
                  ),
                ),
              );
            },
          ),
        )
    );
  }

  testWidgets('Quiz question form present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoTextField), findsOneWidget);
  });

  testWidgets('Quiz question form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    const enteredText = "What is 1+1?";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();
    expect(find.text(enteredText), findsOneWidget);
    expect(controller.text, enteredText);
  });

  testWidgets('Quiz question form displays error when badly-formatted question is given', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    const enteredText = "What is 1+1?\$a:2";
    var errorText = getAppLocalizations(tester.element(find.byType(BloqoTextField)))!.error_quiz_question_invalid;
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.tap(find.byType(Form));
    await tester.pumpAndSettle();
    expect(find.descendant(of: foundWidget, matching: find.text(errorText)), findsOneWidget);
  });
}