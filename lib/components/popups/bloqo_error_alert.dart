import 'package:flutter/material.dart';

import '../../style/app_colors.dart';

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
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      backgroundColor: AppColors.error,
      titleTextStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
        color: AppColors.seasalt,
        fontSize: 24
      ),
      contentTextStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
          color: AppColors.seasalt,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: [
        FilledButton(
          style: Theme.of(context).filledButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.resolveWith((_) => AppColors.seasalt)
          ),
          onPressed: () => Navigator.pop(context, "OK"),
          child: Text("OK", style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold
          )),
        )
      ],
    );
  }

}

showErrorAlert({required BuildContext context, required String title, required String description}){
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