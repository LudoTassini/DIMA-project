import 'package:flutter/material.dart';

import '../../app_state/application_settings_app_state.dart';
import '../../utils/constants.dart';

class BloqoSnackBar {
  static SnackBar get({required BuildContext context, required String text, required Color? backgroundColor}) {
    var theme = getAppThemeFromAppState(context: context);
    backgroundColor ??= theme.colors.leadingColor;
    ScaffoldMessenger.of(context).clearSnackBars();
    return SnackBar(
      content: Text(
        text,
        style: theme.getThemeData().textTheme.displaySmall?.copyWith(
          color: theme.colors.highContrastColor,
          fontSize: 18
        )
      ),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(24),
      duration: const Duration(seconds: Constants.snackBarDuration),
    );
  }
}

showBloqoSnackBar({required BuildContext context, required String text, Color? backgroundColor}){
  ScaffoldMessenger.of(context).showSnackBar(
    BloqoSnackBar.get(
      context: context,
      text: text,
      backgroundColor: backgroundColor
    ),
  );
}