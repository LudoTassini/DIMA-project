import 'package:flutter/material.dart';

class BloqoTextButton extends StatelessWidget{
  const BloqoTextButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed
  });

  final String text;
  final Color color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.resolveWith((states) => const TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline
        )),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color,
        )
      ),
    );
  }

}