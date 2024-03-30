import 'package:flutter/material.dart';

import '../../style/app_colors.dart';

class BloqoErrorText extends StatelessWidget{
  const BloqoErrorText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.bold,
        )
    );
  }

}