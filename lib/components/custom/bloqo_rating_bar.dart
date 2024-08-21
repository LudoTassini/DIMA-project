import 'package:bloqo/utils/check_device.dart';
import 'package:flutter/material.dart';

import '../../app_state/application_settings_app_state.dart';

class BloqoRatingBar extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;

  const BloqoRatingBar({
    super.key,
    this.rating = 0,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            if (onRatingChanged != null) {
              onRatingChanged!(index + 1); // Notify the parent about the selected rating
            }
          },
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: theme.colors.tertiary,
            size: !isTablet ? 40 : 46,
          ),
        );
      }),
    );
  }
}