import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:flutter/material.dart';
import '../../model/courses/bloqo_block_data.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../buttons/bloqo_filled_button.dart';
import '../custom/bloqo_snack_bar.dart';

class BloqoOpenQuestionQuiz extends StatefulWidget {

  const BloqoOpenQuestionQuiz({
    super.key,
    required this.block
  });

  final BloqoBlockData block;

  @override
  State<BloqoOpenQuestionQuiz> createState() => _BloqoOpenQuestionQuizState();

}

class _BloqoOpenQuestionQuizState extends State<BloqoOpenQuestionQuiz> {

  bool isAnswerCorrect = false;
  late TextEditingController controller;

  @override
  void initState(){
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);

    String correctAnswer = _extractAnswer(widget.block.content);
    String question = _extractQuestion(widget.block.content);
    String flags = _extractFlags(widget.block.content);

    final formKeyAnswer = GlobalKey<FormState>();

    return Column(
      mainAxisSize: MainAxisSize.min, // Adjust the main axis size
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                localizedText.quiz,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: theme.colors.leadingColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              if (controller.text != '')
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Text(
                        isAnswerCorrect ? localizedText.correct : localizedText.wrong,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: isAnswerCorrect ? theme.colors.success : theme.colors.error,
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
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                    controller: controller,
                    formKey: formKeyAnswer,
                    labelText: localizedText.answer,
                    hintText: localizedText.your_answer,
                    maxInputLength: Constants.maxQuizAnswerLength,
                    isDisabled: isAnswerCorrect,
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
                  theme: theme
                );
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
              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
              child: Text(
                localizedText.correct,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: theme.colors.success,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
        ),
      ],
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

  void _checkAnswer({required TextEditingController controller, required String correctAnswer, required String flags,
    required var localizedText, required var theme}) {
    setState(() {
      if (_checkConditions(controller.text, correctAnswer, flags)) {
        isAnswerCorrect = true;
      } else {
        isAnswerCorrect = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      BloqoSnackBar.get(
        context: context,
        child: Text(
            isAnswerCorrect ? localizedText.correct
                : localizedText.wrong
        ),
        backgroundColor: isAnswerCorrect ? theme.colors.success
            : theme.colors.error,
      ),
    );
  }

}