import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../app_state/application_settings_app_state.dart';
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
    var theme = getAppThemeFromAppState(context: context);
    return SizedBox(
      width: width + 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            width: 2,
            color: theme.colors.leadingColor,
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
              progressColor: theme.colors.success,
              backgroundColor: theme.colors.inactiveTracker,
              center: Text(
                (percentage * 100).toStringAsFixed(0) + localizedText.progress_bar_completion,
                style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                  fontSize: fontSize,
                  fontFamily: 'Outfit',
                  color: Colors.black
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