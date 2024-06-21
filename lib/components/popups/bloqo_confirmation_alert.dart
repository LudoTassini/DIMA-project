import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';

class BloqoConfirmationAlert extends StatelessWidget{
  const BloqoConfirmationAlert({
    super.key,
    required this.title,
    required this.description,
    required this.confirmationFunction
  });

  final String title;
  final String description;
  final Function() confirmationFunction;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      backgroundColor: BloqoColors.russianViolet,
      titleTextStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
          color: BloqoColors.seasalt,
          fontSize: 24
      ),
      contentTextStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
        color: BloqoColors.seasalt,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: [
        FilledButton(
          style: Theme.of(context).filledButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.resolveWith((_) => BloqoColors.seasalt)
          ),
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(localizedText.cancel, style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: BloqoColors.russianViolet,
              fontWeight: FontWeight.bold
          )),
        ),
        FilledButton(
          style: Theme.of(context).filledButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.resolveWith((_) => BloqoColors.seasalt)
          ),
          onPressed: () {
            confirmationFunction();
            Navigator.pop(context, "OK");
          },
          child: Text(localizedText.ok, style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: BloqoColors.error,
              fontWeight: FontWeight.bold
          )),
        )
      ],
    );
  }

}

showBloqoConfirmationAlert({required BuildContext context, required String title, required String description, required Function() confirmationFunction}){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BloqoConfirmationAlert(
          title: title,
          description: description,
          confirmationFunction: confirmationFunction,
      );
    },
  );
}