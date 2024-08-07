import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../style/bloqo_colors.dart';
import '../../utils/constants.dart';

class BloqoTextField extends StatefulWidget {
  const BloqoTextField({
    super.key,

    required this.formKey,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.maxInputLength,

    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.padding = const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
    this.isTextArea = false,

    this.initialValue,
    this.validator,
    this.onTap,
    this.isDisabled = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final int maxInputLength;

  final bool obscureText;
  final TextInputType keyboardType;
  final EdgeInsetsDirectional padding;
  final bool isTextArea;

  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final Function()? onTap;
  final bool isDisabled;

  @override
  State<BloqoTextField> createState() => _BloqoTextFieldState();
}

class _BloqoTextFieldState extends State<BloqoTextField> {

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if(!_focusNode.hasFocus){
        widget.formKey.currentState!.save();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding,
        child: Container(
          height: widget.isTextArea ? Constants.textAreaContainerHeight : null,
          decoration: BoxDecoration(
            color: BloqoColors.seasalt,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: BloqoColors.russianViolet
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 10),
            child: TextFormField(
              controller: widget.controller,
              initialValue: widget.initialValue,
              autofocus: false,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                labelText: widget.labelText,
                labelStyle: Theme.of(context).textTheme.labelMedium,
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: BloqoColors.secondaryText
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorMaxLines: 10,
              ),
              style: Theme.of(context).textTheme.bodySmall,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxInputLength),
              ],
              autovalidateMode: AutovalidateMode.disabled,
              validator: widget.validator,
              onChanged: (String? value) {
                widget.formKey.currentState!.validate();
              },
              onTap: widget.onTap,
              maxLines: widget.isTextArea ? null : 1,
              expands: widget.isTextArea ? true : false,
              enabled: !widget.isDisabled,
            )
          )
        )
    );
  }
}