import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/quiz/bloqo_multiple_choice_quiz.dart';
import 'package:bloqo/model/courses/bloqo_block_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  Widget buildTestWidget({required bool oneAnswerCorrect}) {
    return MaterialApp(
        localizationsDelegates: getLocalizationDelegates(),
        supportedLocales: getSupportedLocales(),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
          ],
          child: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                    body: BloqoMultipleChoiceQuiz(
                        block: BloqoBlockData(
                            id: "test",
                            superType: BloqoBlockSuperType.quiz.toString(),
                            name: BloqoBlockType.quizMultipleChoice.toString(),
                            number: 1,
                            content: oneAnswerCorrect ? "q:Quale di queste risposte contiene la parola “corretto” o un suo derivato?\$a:<n>sbagliato<y>corretto<n>sbagliatissimo" : "q:Quale di queste risposte contiene la parola “corretto” o un suo derivato?\$a:<n>sbagliato<y>corretto<y>correttissimo"
                        ),
                        onQuestionAnsweredCorrectly: () { },
                    )
                );
              }
          ),
        )
    );
  }

  testWidgets('Multiple choice quiz present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(oneAnswerCorrect: true));
    expect(find.byType(BloqoMultipleChoiceQuiz), findsOneWidget);
  });

  testWidgets('Multiple choice quiz shows wrong if wrong answer is given', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(oneAnswerCorrect: true));

    await tester.tap(find.text('sbagliato'));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsOneWidget);
  });

  testWidgets('Multiple choice quiz shows correct if correct answer is given', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(oneAnswerCorrect: true));

    await tester.tap(find.text('corretto'));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsNothing);
  });

  testWidgets('Multiple choice quiz shows wrong if wrong answer is given', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(oneAnswerCorrect: false));

    await tester.tap(find.text('sbagliato'));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsOneWidget);
  });

  testWidgets('Multiple choice quiz shows wrong if incomplete answer is given', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(oneAnswerCorrect: false));

    await tester.tap(find.text('corretto'));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsOneWidget);
  });

  testWidgets('Multiple choice quiz shows correct if correct answer is given', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(oneAnswerCorrect: false));

    await tester.tap(find.text('corretto'));
    await tester.tap(find.text('correttissimo'));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();

    expect(find.byType(BloqoFilledButton), findsNothing);
  });

}