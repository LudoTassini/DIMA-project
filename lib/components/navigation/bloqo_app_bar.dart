import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';

class BloqoAppBar {
  static PreferredSizeWidget get({
    required BuildContext context,
    required String title,
    required bool canPop,
    required VoidCallback? onPop,
  }) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          color: BloqoColors.seasalt,
        ),
      ),
      backgroundColor: BloqoColors.russianViolet,
      leading: canPop ?
      IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: BloqoColors.seasalt
        ),
        onPressed: onPop,
      ) : null,
    );
  }
}
