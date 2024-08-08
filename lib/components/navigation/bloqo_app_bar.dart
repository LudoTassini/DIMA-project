import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';

class BloqoAppBar {
  static PreferredSizeWidget get({
    required BuildContext context,
    required String title,
    required bool canPop,
    required VoidCallback? onPop,
    VoidCallback? onNotificationIconPressed,
    int notificationCount = 0,
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
            GestureDetector(
              onTap: onNotificationIconPressed,
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: BloqoColors.seasalt,
                    ),
                    onPressed: onNotificationIconPressed,
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: BloqoColors.error,
                          borderRadius: BorderRadius.circular(12), // Increased radius for larger circle
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18, // Increased minWidth to accommodate larger font size
                          minHeight: 18, // Increased minHeight to accommodate larger font size
                        ),
                        child: Text(
                          notificationCount < 10 ? '$notificationCount' : "9+",
                          style: const TextStyle(
                            color: BloqoColors.seasalt,
                            fontSize: 10, // Set font size to 10
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            const SizedBox(width: 48), // Placeholder for symmetry
        ],
      ),
    );
  }
}