import 'package:flutter/material.dart';

import '../../app_state/application_settings_app_state.dart';
import '../../utils/constants.dart';

class BloqoSnackBar {
  static SnackBar get({required BuildContext context, required Widget child, Color? backgroundColor}) {
    backgroundColor ??= getAppThemeFromAppState(context: context).colors.leadingColor;
    ScaffoldMessenger.of(context).clearSnackBars();
    return SnackBar(
      content: child,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(24),
      duration: const Duration(seconds: Constants.snackBarDuration),
    );
  }
}