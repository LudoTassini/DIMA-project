import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:flutter/material.dart';
import '../../app_state/application_settings_app_state.dart';
import '../../model/courses/bloqo_block_data.dart';
import '../../utils/localization.dart';
import '../buttons/bloqo_filled_button.dart';
import '../custom/bloqo_snack_bar.dart';

class BloqoMultipleChoiceQuiz extends StatefulWidget {

  const BloqoMultipleChoiceQuiz({
    super.key,
    required this.block,
    required this.onQuestionAnsweredCorrectly,
    this.isQuizCompleted = false,
  });

  final BloqoBlockData block;
  final VoidCallback onQuestionAnsweredCorrectly;
  final bool isQuizCompleted;

  @override
  State<BloqoMultipleChoiceQuiz> createState() => _BloqoMultipleChoiceQuizState();
}

class _BloqoMultipleChoiceQuizState extends State<BloqoMultipleChoiceQuiz> {
  bool isAnswerCorrect = false;
  bool isAnswerGiven = false;

  String? selectedRadioAnswer;
  List<String> selectedCheckboxAnswers = [];

  late final String question;
  late final List<String> possibleAnswers;
  late final List<String> correctAnswers;
  late bool isSingleCorrectAnswer;

  @override
  void initState() {
    super.initState();
    selectedRadioAnswer = '';
    question = _extractQuestion(widget.block.content);
    possibleAnswers = _extractPossibleAnswers(widget.block.content);
    correctAnswers = _extractCorrectAnswers(widget.block.content);
    isSingleCorrectAnswer = correctAnswers.length == 1;

    if (widget.isQuizCompleted) {
      _markAsCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);

    return BloqoSeasaltContainer(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
              if (isAnswerGiven || widget.isQuizCompleted)
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Text(
                        isAnswerCorrect || widget.isQuizCompleted
                            ? localizedText.correct
                            : localizedText.wrong,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: isAnswerCorrect || widget.isQuizCompleted
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    question,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: theme.colors.primaryText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BloqoSeasaltContainer(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 10),
              borderColor: theme.colors.leadingColor,
              borderWidth: 3,
              borderRadius: 10,
              child: isSingleCorrectAnswer
                  ? _buildRadioButtons(possibleAnswers: possibleAnswers)
                  : _buildCheckboxes(possibleAnswers: possibleAnswers),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
              child: Align(
                alignment: Alignment.center,
                child: (!isAnswerGiven || !isAnswerCorrect) && !widget.isQuizCompleted
                    ? BloqoFilledButton(
                  onPressed: () {
                    setState(() {
                      isAnswerGiven = true;
                      _checkAnswer(
                          correctAnswers: correctAnswers,
                          localizedText: localizedText,
                          theme: theme);
                    });
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      ),
    );
  }

  String _extractQuestion(String text) {
    final questionRegExp = RegExp(r'q:(.*?)\$a:');
    final match = questionRegExp.firstMatch(text);
    if (match != null) {
      return match.group(1)?.trim() ?? '';
    } else {
      return '';
    }
  }

  List<String> _extractPossibleAnswers(String text) {
    final possibleAnswersRegExp = RegExp(r'<[yn]>([^<]*)');
    final matches = possibleAnswersRegExp.allMatches(text);
    return matches.map((match) => match.group(1)?.trim() ?? '').toList();
  }

  List<String> _extractCorrectAnswers(String text) {
    final correctAnswersRegExp = RegExp(r'<y>([^<]*)');
    final matches = correctAnswersRegExp.allMatches(text);
    return matches.map((match) => match.group(1)?.trim() ?? '').toList();
  }

  Widget _buildRadioButtons({required List<String> possibleAnswers}) {
    return Column(
      children: possibleAnswers.map((answer) {
        return RadioListTile<String>(
          title: Text(answer),
          value: answer,
          groupValue: selectedRadioAnswer,
          onChanged: widget.isQuizCompleted || isAnswerCorrect
              ? null : (value) {
            setState(() {
              selectedRadioAnswer = value;
              isAnswerGiven = false;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildCheckboxes({required List<String> possibleAnswers}) {
    return Column(
      children: possibleAnswers.map((answer) {
        return CheckboxListTile(
          title: Text(answer),
          value: selectedCheckboxAnswers.contains(answer),
          onChanged: widget.isQuizCompleted || isAnswerCorrect
              ? null : (bool? value) {
            setState(() {
              if (value == true) {
                selectedCheckboxAnswers.add(answer);
              } else {
                selectedCheckboxAnswers.remove(answer);
              }
              isAnswerGiven = false;
            });
          },
        );
      }).toList(),
    );
  }

  void _checkAnswer({required List<String> correctAnswers, required var localizedText, required var theme}) {
    if (correctAnswers.length == 1) {
      isAnswerCorrect = selectedRadioAnswer == correctAnswers.first;
    } else {
      bool allCorrect = correctAnswers.every((answer) => selectedCheckboxAnswers.contains(answer)) &&
          selectedCheckboxAnswers.length == correctAnswers.length;
      isAnswerCorrect = allCorrect;
    }

    if (isAnswerCorrect) {
      widget.onQuestionAnsweredCorrectly();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      BloqoSnackBar.get(
        context: context,
        child: Text(
          isAnswerCorrect ? localizedText.correct : localizedText.wrong,
        ),
        backgroundColor: isAnswerCorrect ? theme.colors.success : theme.colors.error,
      ),
    );
  }

  void _markAsCompleted() {
    final List<String> correctAnswers = _extractCorrectAnswers(widget.block.content);

    if (correctAnswers.length == 1) {
      selectedRadioAnswer = correctAnswers.first;
    } else {
      selectedCheckboxAnswers = List<String>.from(correctAnswers);
    }

    isAnswerCorrect = true;
    isAnswerGiven = true;
  }
}