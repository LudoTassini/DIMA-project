import 'package:flutter/material.dart';

class BloqoClickableText extends StatelessWidget{
  const BloqoClickableText({
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
        textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
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