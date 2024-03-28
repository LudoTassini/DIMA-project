import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../style/app_colors.dart';

class BloqoTextField extends StatefulWidget {
  const BloqoTextField({
    super.key,

    required this.formKey,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.maxInputLength,

    this.initialValue,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final int maxInputLength;

  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  State<BloqoTextField> createState() => _BloqoTextFieldState();
}

class _BloqoTextFieldState extends State<BloqoTextField> {

  final _focusNode = FocusNode();

  String? value;

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
        padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.seasalt,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.russianViolet
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
                  color: AppColors.secondaryText
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.always
              ),
              style: Theme.of(context).textTheme.bodySmall,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxInputLength),
              ],
              autovalidateMode: AutovalidateMode.disabled,
              validator: widget.validator,
              onChanged: (String? value) {
                if (widget.formKey.currentState!.validate()) {
                  setState(() {
                    this.value = value;
                  });
                }
              },
            )
          )
        )
    );
  }
}