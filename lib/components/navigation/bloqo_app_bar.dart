import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';

class BloqoAppBar {
  static PreferredSizeWidget get({
    required BuildContext context,
    required String title,
    required bool canPop,
    required VoidCallback? onPop,
    VoidCallback? onNotificationIconPressed,
  }) {
    return AppBar(
      backgroundColor: BloqoColors.russianViolet,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (canPop)
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: BloqoColors.seasalt,
              ),
              onPressed: onPop,
              padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
            )
          else
            const SizedBox(width: 48), // Placeholder for back button
          Expanded(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: BloqoColors.seasalt,
                ),
              ),
            ),
          ),
          if (onNotificationIconPressed != null)
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: BloqoColors.seasalt,
              ),
              onPressed: onNotificationIconPressed,
            )
          else
            const SizedBox(width: 48), // Placeholder for symmetry
        ],
      ),
    );
  }
}
