import 'package:flutter/material.dart';

class BloqoFilledButton extends StatelessWidget{
  const BloqoFilledButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.text,
    this.icon,
    this.fontSize = 20,
    this.height = 48,
  });

  final Color color;
  final Function() onPressed;
  final String text;

  final IconData? icon;
  final double fontSize;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: Theme.of(context).filledButtonTheme.style?.copyWith(
        textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        )),
        backgroundColor: MaterialStateProperty.resolveWith((_) => color),
        fixedSize: MaterialStateProperty.resolveWith((_) => Size(double.infinity, height)),
        padding: MaterialStateProperty.resolveWith((_) => EdgeInsetsDirectional.fromSTEB(22 * fontSize/20, 12 * fontSize/20, 22 * fontSize/20, 12 * fontSize/20)),
      ),
      onPressed: onPressed,
      child: icon == null ? Text(text) : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
            child: Icon(icon),
          ),
          Text(text)
        ],
      ),
    );
  }

}