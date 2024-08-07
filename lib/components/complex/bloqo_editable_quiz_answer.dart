import 'package:bloqo/components/forms/bloqo_switch.dart';
import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../../utils/toggle.dart';
import '../forms/bloqo_text_field.dart';
import '../popups/bloqo_confirmation_alert.dart';

class BloqoEditableQuizAnswer extends StatelessWidget {
  BloqoEditableQuizAnswer({
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

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    return Padding(
        padding: padding,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: BloqoColors.russianViolet,
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
                            "${localizedText.answer} $answerNumber",
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: BloqoColors.russianViolet,
                              fontWeight: FontWeight.w600
                            )
                          ),
                          if(editable)
                            IconButton(
                              padding: const EdgeInsets.only(left: 5.0),
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.delete_forever,
                                color: BloqoColors.error,
                                size: 24,
                              ),
                              onPressed: () {
                                showBloqoConfirmationAlert(
                                    context: context,
                                    title: localizedText.warning,
                                    description: localizedText.delete_answer_confirmation,
                                    confirmationFunction: onDelete,
                                    backgroundColor: BloqoColors.error
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
                    controller: controller,
                    labelText: localizedText.answer,
                    hintText: localizedText.enter_answer_here,
                    maxInputLength: Constants.maxQuizAnswerLength,
                    isTextArea: true,
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 5, 15)
                  )
                ),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: [
                    Text(
                        localizedText.is_answer_correct,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: BloqoColors.russianViolet,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        )
                    ),
                    BloqoSwitch(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      value: toggle
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