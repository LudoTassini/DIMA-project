import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/forms/bloqo_switch.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../../utils/toggle.dart';
import '../forms/bloqo_text_field.dart';
import '../popups/bloqo_confirmation_alert.dart';

class BloqoEditableQuizAnswer extends StatefulWidget {

  const BloqoEditableQuizAnswer({
    super.key,
    required this.controller,
    required this.toggle,
    required this.answerNumber,
    required this.editable,
    required this.onDelete,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
  });

  final TextEditingController controller;
  final Toggle toggle;
  final int answerNumber;
  final bool editable;
  final Function() onDelete;
  final EdgeInsetsDirectional padding;

  @override
  State<BloqoEditableQuizAnswer> createState() => _BloqoEditableQuizAnswerState();

}

class _BloqoEditableQuizAnswerState extends State<BloqoEditableQuizAnswer>{

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    return Padding(
        padding: widget.padding,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colors.leadingColor,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 15, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${localizedText.answer} ${widget.answerNumber}",
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: theme.colors.leadingColor,
                              fontWeight: FontWeight.w600
                            )
                          ),
                          if(widget.editable)
                            IconButton(
                              padding: const EdgeInsets.only(left: 5.0),
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                Icons.delete_forever,
                                color: theme.colors.error,
                                size: 24,
                              ),
                              onPressed: () {
                                showBloqoConfirmationAlert(
                                    context: context,
                                    title: localizedText.warning,
                                    description: localizedText.delete_answer_confirmation,
                                    confirmationFunction: widget.onDelete,
                                    backgroundColor: theme.colors.error
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: BloqoTextField(
                    formKey: formKey,
                    controller: widget.controller,
                    labelText: localizedText.answer,
                    hintText: localizedText.enter_answer_here,
                    maxInputLength: Constants.maxQuizAnswerLength,
                    isTextArea: true,
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 5, 15),
                    isDisabled: !widget.editable
                  )
                ),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    Text(
                        localizedText.is_answer_correct,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: theme.colors.leadingColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        )
                    ),
                    BloqoSwitch(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      value: widget.toggle,
                      editable: widget.editable,
                    )
                  ]
                )
              ],
            ),
          ),
        )
    );
  }
}