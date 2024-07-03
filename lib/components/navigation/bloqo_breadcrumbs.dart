import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';
import '../buttons/bloqo_text_button.dart';

class BloqoBreadcrumbs extends StatelessWidget {
  const BloqoBreadcrumbs({
    super.key,
    required this.breadcrumbs,
  });

  final List<String> breadcrumbs;

  @override
  Widget build(BuildContext context) {
    List<Widget> breadcrumbWidgets = [];

    for (int i = 0; i < breadcrumbs.length; i++) {
      breadcrumbWidgets.add(
          i < breadcrumbs.length - 1 ? BloqoTextButton(
        text: breadcrumbs[i],
        color: BloqoColors.seasalt,
        onPressed: () {
          int popCount = breadcrumbs.length - i - 1;
          for (int j = 0; j < popCount; j++) {
            Navigator.of(context).pop();
          }
        },
      ) : Text(
            breadcrumbs[i],
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: BloqoColors.seasalt,
              fontWeight: FontWeight.w500
            )
          )
      );

      if (i < breadcrumbs.length - 1) {
        breadcrumbWidgets.add(const Icon(
          Icons.chevron_right,
          color: BloqoColors.seasalt,
        ));
      }
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
      child: Align(
        alignment: const AlignmentDirectional(-1, -1),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: breadcrumbWidgets,
        )
      )
    );
  }
}

