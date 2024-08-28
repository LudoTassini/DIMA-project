import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:flutter/material.dart';

class BloqoAppBar {
  static PreferredSizeWidget get({
    required BuildContext context,
    required String title,
    required bool canPop,
    required VoidCallback? onPop,
    VoidCallback? onNotificationIconPressed,
    int notificationCount = 0,
  }) {
    var theme = getAppThemeFromAppState(context: context);
    return AppBar(
      backgroundColor: theme.colors.leadingColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (canPop)
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.colors.highContrastColor,
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
                style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                  color: theme.colors.highContrastColor,
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
                    icon: Icon(
                      Icons.notifications,
                      color: theme.colors.highContrastColor,
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
                          color: theme.colors.error,
                          borderRadius: BorderRadius.circular(12), // Increased radius for larger circle
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18, // Increased minWidth to accommodate larger font size
                          minHeight: 18, // Increased minHeight to accommodate larger font size
                        ),
                        child: Text(
                          notificationCount < 10 ? '$notificationCount' : "9+",
                          style: TextStyle(
                            color: theme.colors.highContrastColor,
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