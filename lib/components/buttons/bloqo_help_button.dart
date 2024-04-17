import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';

class BloqoHelpButton extends StatelessWidget {
  const BloqoHelpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: Theme
          .of(context)
          .filledButtonTheme
          .style
          ?.copyWith(
        backgroundColor: MaterialStateProperty.resolveWith((_) =>
        BloqoColors.darkFuchsia),
      ),
      onPressed: () {
        print('Button pressed ...');
        // TODO: pagina help
      },
      child: Text(
        'Need help?',
        style: Theme
            .of(context)
            .textTheme
            .displaySmall
            ?.copyWith(
          color: BloqoColors.seasalt,
          fontSize: 12,
        ),
      ),
    );
  }
}