import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';
import '../../utils/constants.dart';

class BloqoSnackBar {
  static SnackBar get({required BuildContext context, required Widget child, Color backgroundColor = BloqoColors.russianViolet}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    return SnackBar(
      content: child,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(24),
      duration: const Duration(seconds: Constants.snackBarDuration),
    );
  }
}