import 'package:flutter/material.dart';

class BloqoFilledButton extends StatelessWidget{
  const BloqoFilledButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.text,
    this.iconData,
    this.fontSize = 20
  });

  final Color color;
  final Function() onPressed;
  final String text;

  final IconData? iconData;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: Theme.of(context).filledButtonTheme.style?.copyWith(
        textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        )),
        backgroundColor: MaterialStateProperty.resolveWith((_) => color),
        fixedSize: MaterialStateProperty.resolveWith((_) => const Size(double.infinity, double.infinity)),
        padding: MaterialStateProperty.resolveWith((_) => EdgeInsetsDirectional.fromSTEB(22 * fontSize/20, 12 * fontSize/20, 22 * fontSize/20, 12 * fontSize/20)),
      ),
      onPressed: onPressed,
      child: iconData == null ? Text(text) : Row(
        children: [
          Icon(iconData),
          Text(text)
        ],
      ),
    );
  }

}