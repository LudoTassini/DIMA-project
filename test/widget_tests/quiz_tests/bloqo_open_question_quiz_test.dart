import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/components/quiz/bloqo_open_question_quiz.dart';
import 'package:bloqo/model/courses/bloqo_block_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  Widget buildTestWidget({bool trimExtraWhitespaces = true, bool ignoreCase = true}) {
    return MaterialApp(
        localizationsDelegates: getLocalizationDelegates(),
        supportedLocales: getSupportedLocales(),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
          ],
          child: Builder(
              builder: (BuildContext context) {
                String trimExtraWhitespacesChar = trimExtraWhitespaces ? "y" : "n";
                String ignoreCaseChar = ignoreCase ? "y" : "n";
                return Scaffold(
                    body: BloqoOpenQuestionQuiz(
                        block: BloqoBlockData(
                            id: "test",
                            superType: BloqoBlockSuperType.quiz.toString(),
                            name: BloqoBlockType.quizOpenQuestion.toString(),
                            number: 1,
                            content: "q:What’s one+one?\$a<$trimExtraWhitespacesChar$ignoreCaseChar>:two"
                        )
                    )
                );
              }
          ),
        )
    );
  }

  testWidgets('Open question quiz present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoOpenQuestionQuiz), findsOneWidget);
  });

  testWidgets('Open question quiz shows wrong if wrong answer is given', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    const enteredText = "three";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsOneWidget);
  });

  testWidgets('Open question quiz shows wrong if correct answer is given in the wrong format (with extra whitespaces)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(trimExtraWhitespaces: false));

    const enteredText = " two ";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsOneWidget);
  });

  testWidgets('Open question quiz shows wrong if correct answer is given in the wrong format (different case)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(ignoreCase: false));

    const enteredText = "TWO";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsOneWidget);
  });

  testWidgets('Open question quiz shows correct if correct answer is given', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    const enteredText = "two";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsNothing);
  });

  testWidgets('Open question quiz shows correct if correct answer is given (with extra whitespaces)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    const enteredText = " two ";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsNothing);
  });

  testWidgets('Open question quiz shows correct if correct answer is given (different case)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    const enteredText = "TWO";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsNothing);
  });

  testWidgets('Open question quiz shows correct if correct answer is given (extra whitespaces and different case)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    const enteredText = " TWO ";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsNothing);
  });

}