import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';

class BloqoNavBar extends StatefulWidget {
  const BloqoNavBar({
    super.key,
    required this.onItemTapped,
  });

  final Function(int) onItemTapped;

  @override
  State<BloqoNavBar> createState() => _BloqoNavBarState();
}

class _BloqoNavBarState extends State<BloqoNavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          currentPageIndex = index;
        });
        widget.onItemTapped(index);
      },
      currentIndex: currentPageIndex,
      selectedItemColor: BloqoColors.russianViolet,
      unselectedItemColor: BloqoColors.seasalt,
      backgroundColor: BloqoColors.darkFuchsia,
      elevation: 2,
      type: BottomNavigationBarType.fixed,
      iconSize: 30.0,
      selectedFontSize: 16.0,
      unselectedFontSize: 14.0,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
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