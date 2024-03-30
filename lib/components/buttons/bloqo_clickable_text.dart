import 'package:flutter/material.dart';

class BloqoClickableText extends StatelessWidget{
  const BloqoClickableText({
    super.key,
    required this.text,
    required this.color
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: color,
        decoration: TextDecoration.underline
      )
    );
  }

}