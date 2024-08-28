import 'package:flutter/material.dart';

import '../../app_state/application_settings_app_state.dart';
import '../../utils/localization.dart';

class BloqoConfirmationAlert extends StatelessWidget{
  const BloqoConfirmationAlert({
    super.key,
    required this.title,
    required this.description,
    required this.confirmationFunction,
    required this.backgroundColor,
    required this.confirmationColor
  });

  final String title;
  final String description;
  final Function() confirmationFunction;
  final Color backgroundColor;
  final Color confirmationColor;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      backgroundColor: backgroundColor,
      titleTextStyle: theme.getThemeData().textTheme.displayLarge?.copyWith(
          color: theme.colors.highContrastColor,
          fontSize: 24
      ),
      contentTextStyle: theme.getThemeData().textTheme.displayMedium?.copyWith(
        color: theme.colors.highContrastColor,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: [
        FilledButton(
          style: theme.getThemeData().filledButtonTheme.style?.copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((_) => theme.colors.highContrastColor)
          ),
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(localizedText.cancel, style: theme.getThemeData().textTheme.displayMedium?.copyWith(
              color: theme.colors.leadingColor,
              fontWeight: FontWeight.bold
          )),
        ),
        FilledButton(
          style: theme.getThemeData().filledButtonTheme.style?.copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((_) => theme.colors.highContrastColor)
          ),
          onPressed: () {
            confirmationFunction();
            if(context.mounted) {
              Navigator.pop(context, "OK");
            }
          },
          child: Text(localizedText.ok, style: theme.getThemeData().textTheme.displayMedium?.copyWith(
              color: confirmationColor,
              fontWeight: FontWeight.bold
          )),
        )
      ],
    );
  }

}

showBloqoConfirmationAlert({
  required BuildContext context,
  required String title,
  required String description,
  required Function() confirmationFunction,
  required Color backgroundColor,
  Color? confirmationColor}){
  var theme = getAppThemeFromAppState(context: context);
  confirmationColor ??= theme.colors.error;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BloqoConfirmationAlert(
        title: title,
        description: description,
        confirmationFunction: confirmationFunction,
        backgroundColor: backgroundColor,
        confirmationColor: confirmationColor!,
      );
    },
  );
}