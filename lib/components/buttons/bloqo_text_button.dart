import 'package:flutter/material.dart';

class BloqoTextButton extends StatelessWidget{

  const BloqoTextButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.fontSize
  });

  final String text;
  final Color color;
  final Function() onPressed;

  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.resolveWith((states) => const TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline
        )),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.zero)
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize
        )
      ),
    );
  }

}