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
    final GlobalKey mainButtonKey = GlobalKey();

    return BloqoFilledButton(
      key: mainButtonKey,
      color: mainColor,
      text: mainText,
      icon: mainIcon,
      fontSize: fontSize,
      height: height,
      onPressed: () {
        final RenderBox button = mainButtonKey.currentContext!.findRenderObject() as RenderBox;
        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

        // Calculate the position and size of the button
        final buttonSize = button.size;
        final buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);

        // Show the menu at the calculated position
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            buttonPosition.dx,
            buttonPosition.dy + buttonSize.height,
            overlay.size.width - (buttonPosition.dx + buttonSize.width),
            0,
          ),
          items: List<PopupMenuEntry<String>>.generate(onPressedList.length, (int index) {
            return PopupMenuItem<String>(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: BloqoFilledButton(
                  color: colors[index],
                  text: texts[index],
                  onPressed: onPressedList[index],
                  icon: icons?[index],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}