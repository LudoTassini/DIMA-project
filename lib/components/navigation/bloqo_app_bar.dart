import 'package:bloqo/components/buttons/bloqo_help_button.dart';
import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';

class BloqoAppBar{

  static PreferredSize get({required BuildContext context, required String title}){
    return PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text(title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: BloqoColors.seasalt
            ),
          ),
          actions: const <Widget>[
            BloqoHelpButton(), // TODO: controllare che help button vada bene e che funzioni
          ],
          backgroundColor: BloqoColors.russianViolet,
        )
    );
  } 
}