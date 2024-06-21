import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';

class BloqoNavBar extends StatelessWidget {
  const BloqoNavBar({
    super.key,
    required this.onItemTapped,
    required this.currentIndex,
  });

  final Function(int) onItemTapped;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    return BottomNavigationBar(
      onTap: (index) {
        onItemTapped(index);
      },
      currentIndex: currentIndex,
      selectedItemColor: BloqoColors.russianViolet,
      unselectedItemColor: BloqoColors.seasalt,
      backgroundColor: BloqoColors.darkFuchsia,
      elevation: 20,
      type: BottomNavigationBarType.fixed,
      iconSize: 30.0,
      selectedFontSize: 16.0,
      unselectedFontSize: 14.0,
      selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold
      ),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.home_outlined,
          ),
          label: localizedText.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.book,
          ),
          label: localizedText.learn,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.search,
          ),
          label: localizedText.search,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.edit,
          ),
          label: localizedText.editor,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.person,
          ),
          label: localizedText.account,
        ),
      ],
    );
  }
}
