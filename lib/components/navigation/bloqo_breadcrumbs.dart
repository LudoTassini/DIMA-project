import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../buttons/bloqo_text_button.dart';

class BloqoBreadcrumbs extends StatelessWidget {
  const BloqoBreadcrumbs({
    super.key,
    required this.breadcrumbs,
    this.disable,
  });

  final List<String> breadcrumbs;
  final bool? disable;

  @override
  Widget build(BuildContext context) {

    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

    List<Widget> breadcrumbWidgets = [];

    for (int i = 0; i < breadcrumbs.length; i++) {
      // Check if disable is true or if it's the last breadcrumb
      if (disable == true || i == breadcrumbs.length - 1) {
        breadcrumbWidgets.add(Baseline(
          baseline: 21.5,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            breadcrumbs[i],
            style: theme.getThemeData().textTheme.displayMedium!.copyWith(
                color: theme.colors.highContrastColor, fontWeight: FontWeight.w500),
          ),
        ));
      } else {
        breadcrumbWidgets.add(BloqoTextButton(
          text: breadcrumbs[i],
          color: theme.colors.highContrastColor,
          fontSize: 20,
          onPressed: () {
            int popCount = breadcrumbs.length - i - 1;
            for (int j = 0; j < popCount; j++) {
              Navigator.of(context).pop();
            }
          },
        ));
      }

      if (i < breadcrumbs.length - 1) {
        breadcrumbWidgets.add(Baseline(
          baseline: 27.0,
          baselineType: TextBaseline.alphabetic,
          child: Icon(
            Icons.chevron_right,
            color: theme.colors.highContrastColor,
          ),
        ));
      }
    }

    return Padding(
      padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10)
          : Constants.tabletPaddingBreadcrumbs,
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: 5,
          runSpacing: 0,
          children: breadcrumbWidgets,
        ),
      ),
    );
  }
}