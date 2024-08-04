import 'package:flutter/material.dart';
import 'bloqo_filled_button.dart';

class BloqoPopupMenuFilledButton extends StatelessWidget {
  const BloqoPopupMenuFilledButton({
    super.key,
    required this.mainColor,
    required this.onPressedList,
    required this.mainText,
    required this.texts,
    required this.colors,
    this.mainIcon,
    this.icons,
    this.fontSize = 20,
    this.height = 48,
  });

  final Color mainColor;
  final List<Function()> onPressedList;
  final String mainText;
  final List<Color> colors;
  final List<String> texts;

  final IconData? mainIcon;
  final List<IconData?>? icons;
  final double fontSize;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BloqoFilledButton(
      color: mainColor,
      text: mainText,
      onPressed: () {
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(0, 0, 0, 0),
          items: List<PopupMenuEntry<String>>.generate(onPressedList.length, (int index) {
            return PopupMenuItem<String>(
              child: BloqoFilledButton(
                color: colors[index],
                text: texts[index],
                onPressed: onPressedList[index],
              ),
            );
          }),
        );
      },
    );
  }
}