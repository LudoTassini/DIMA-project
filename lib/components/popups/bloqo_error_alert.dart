import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:flutter/material.dart';

import '../../utils/localization.dart';

class BloqoErrorAlert extends StatelessWidget{
  const BloqoErrorAlert({
    super.key,
    required this.title,
    required this.description
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      backgroundColor: theme.colors.error,
      titleTextStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
        color: theme.colors.highContrastColor,
        fontSize: 24
      ),
      contentTextStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
          color: theme.colors.highContrastColor,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: [
        FilledButton(
          style: Theme.of(context).filledButtonTheme.style?.copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((_) => theme.colors.highContrastColor)
          ),
          onPressed: () => Navigator.pop(context, "OK"),
          child: Text(localizedText.ok, style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: theme.colors.error,
            fontWeight: FontWeight.bold
          )),
        )
      ],
    );
  }

}

showBloqoErrorAlert({required BuildContext context, required String title, required String description}){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BloqoErrorAlert(
          title: title,
          description: description
      );
    },
  );
}