import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:flutter/material.dart';

import '../../pages/main/help_page.dart';
import '../../style/bloqo_colors.dart';

class BloqoAppBar{


  static PreferredSize get({required BuildContext context, required String title}){
    return PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 2,
          backgroundColor: BloqoColors.russianViolet,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: BloqoColors.seasalt,
                  fontSize: 22,
                ),
              ),
              BloqoFilledButton(
                color: BloqoColors.darkFuchsia,
                text: 'Need help?',
                fontSize: 13,
                height: 20,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpPage(), // TODO: pagina help,
                    )
                  );
                },
              ),
            ],
          ),
        )
    );
  }
}