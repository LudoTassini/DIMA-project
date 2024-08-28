import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:flutter/material.dart';
import '../../model/courses/bloqo_block_data.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../buttons/bloqo_filled_button.dart';
import '../containers/bloqo_seasalt_container.dart';
import '../custom/bloqo_snack_bar.dart';

class BloqoOpenQuestionQuiz extends StatefulWidget {

  const BloqoOpenQuestionQuiz({
    super.key,
    required this.block,
    required this.onQuestionAnsweredCorrectly,
    this.isQuizCompleted = false,
  });

  final BloqoBlockData block;
  final VoidCallback onQuestionAnsweredCorrectly;
  final bool isQuizCompleted;

  @override
  State<BloqoOpenQuestionQuiz> createState() => _BloqoOpenQuestionQuizState();

}

class _BloqoOpenQuestionQuizState extends State<BloqoOpenQuestionQuiz> {

  bool isAnswerCorrect = false;
  late GlobalKey<FormState> formKeyAnswer;
  late TextEditingController controller;
  late String correctAnswer;
  late String question;
  late String flags;
  late bool isAnswerGiven;

  @override
  void initState(){
    super.initState();
    correctAnswer = _extractAnswer(widget.block.content);
    question = _extractQuestion(widget.block.content);
    flags = _extractFlags(widget.block.content);
    isAnswerGiven = false;
    formKeyAnswer = GlobalKey<FormState>();
    controller = TextEditingController();

    // Automatically mark the answer as correct if the quiz is completed
    if (widget.isQuizCompleted) {
      String correctAnswer = _extractAnswer(widget.block.content);
      controller.text = correctAnswer;
      isAnswerCorrect = true;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);

    return BloqoSeasaltContainer(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  localizedText.quiz,
                  style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                    color: theme.colors.leadingColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                if (isAnswerGiven)
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                        child: Text(
                          isAnswerCorrect
                              ? localizedText.correct
                              : localizedText.wrong,
                          style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                            color: isAnswerCorrect
                                ? theme.colors.success
                                : theme.colors.error,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  question,
                  style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                    color: theme.colors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Form(
                    key: formKeyAnswer,
                    child: BloqoTextField(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                      isTextArea: true,
                      controller: controller,
                      formKey: formKeyAnswer,
                      labelText: localizedText.answer,
                      hintText: localizedText.your_answer,
                      maxInputLength: Constants.maxQuizAnswerLength,
                      isDisabled: isAnswerCorrect || widget.isQuizCompleted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 15),
            child: !isAnswerCorrect?
              BloqoFilledButton(
                onPressed: () {
                  _checkAnswer(
                    controller: controller,
                    correctAnswer: correctAnswer,
                    flags: flags,
                    localizedText: localizedText,
                    theme: theme);
              },
              color: theme.colors.leadingColor,
              text: localizedText.confirm,
            )
                : Container(
              decoration: BoxDecoration(
                color: theme.colors.highContrastColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colors.success,
                  width: 3,
                ),
              ),
              child: Padding(
                padding:
                const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                child: Text(
                  localizedText.correct,
                  style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                      color: theme.colors.success,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extractQuestion(String text) {
    final questionRegExp = RegExp(r'q:(.*?)\$a');
    final match = questionRegExp.firstMatch(text);

    if (match != null) {
      return match.group(1)?.trim() ?? '';
    } else {
      return '';
    }
  }

  String _extractAnswer(String text) {
    final answerRegExp = RegExp(r'\$a<([yn]{2})>:(.*)');
    final match = answerRegExp.firstMatch(text);

    if (match != null) {
      String answer = match.group(2) ?? '';
      return answer;
    } else {
      return '';
    }
  }

  String _extractFlags(String text) {
    final flagsRegExp = RegExp(r'\$a<([yn]{2})>');
    final match = flagsRegExp.firstMatch(text);
    return match?.group(1) ?? '';
  }

  bool _checkConditions(String userAnswer, String correctAnswer, String flags) {
    String answerToCheck = userAnswer;

    // Determine if we need to trim extra whitespaces
    if (flags.isNotEmpty && flags[0] == 'y') {
      answerToCheck = answerToCheck.trim();
      correctAnswer = correctAnswer.trim();
    }

    // Determine if we need to ignore case
    if (flags.isNotEmpty && flags[1] == 'y') {
      answerToCheck = answerToCheck.toLowerCase();
      correctAnswer = correctAnswer.toLowerCase();
    }

    return answerToCheck == correctAnswer;
  }

  void _checkAnswer({
    required TextEditingController controller,
    required String correctAnswer,
    required String flags,
    required var localizedText,
    required var theme,
  }) {
    setState(() {
      isAnswerGiven = true;
      if (_checkConditions(controller.text, correctAnswer, flags)) {
        isAnswerCorrect = true;
        widget.onQuestionAnsweredCorrectly(); // Invoke the callback
      } else {
        isAnswerCorrect = false;
      }
    });

    showBloqoSnackBar(
        context: context,
        text: isAnswerCorrect ? localizedText.correct : localizedText.wrong,
        backgroundColor: isAnswerCorrect ? theme.colors.success : theme.colors.error
    );
  }
}