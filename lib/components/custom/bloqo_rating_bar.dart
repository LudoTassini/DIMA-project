import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';

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
            color: BloqoColors.tertiary,
            size: 40,
          ),
        );
      }),
    );
  }
}