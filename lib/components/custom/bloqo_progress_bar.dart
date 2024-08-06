import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';

class BloqoProgressBar extends StatelessWidget{
  const BloqoProgressBar({
    super.key,
    required this.percentage,
    required this.width,
    this.fontSize = 10,
  });

  final double percentage;
  final double width;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    return SizedBox(
      width: width + 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            width: 2,
            color: BloqoColors.russianViolet,
          ),
        ),
        alignment: const AlignmentDirectional(0, 0),
        child: Column (
          children: [
            LinearPercentIndicator(
              percent: percentage,
              width: width,
              lineHeight: 15,
              animation: true,
              animateFromLastPercent: true,
              progressColor: BloqoColors.success,
              backgroundColor: BloqoColors.inactiveTracker,
              center: Text(
                (percentage * 100).toStringAsFixed(0) + localizedText.progress_bar_completion,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: fontSize,
                  fontFamily: 'Outfit',
                ),
              ),
              barRadius: const Radius.circular(5),
              padding: EdgeInsets.zero,
              ),
            ],
          ),
      ),
    );
  }

}