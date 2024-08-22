import 'package:flutter/material.dart';

import '../../app_state/application_settings_app_state.dart';

class BloqoRatingBar extends StatefulWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;

  const BloqoRatingBar({
    super.key,
    this.rating = 0,
    this.onRatingChanged,
  });

  @override
  State<BloqoRatingBar> createState() => _BloqoRatingBarState();

}

class _BloqoRatingBarState extends State<BloqoRatingBar> {

  late int rating;

  @override
  void initState(){
    super.initState();
    rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    var theme = getAppThemeFromAppState(context: context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            if (widget.onRatingChanged != null) {
              widget.onRatingChanged!(index + 1); // Notify the parent about the selected rating
            }
            setState(() {
              rating = index + 1;
            });
          },
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: theme.colors.tertiary,
            size: 40,
          ),
        );
      }),
    );
  }
}