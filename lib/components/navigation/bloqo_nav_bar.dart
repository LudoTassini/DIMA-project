import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';

class BloqoNavBar extends StatefulWidget {
  const BloqoNavBar({
    super.key,
    required this.onDestinationSelected,
  });

  final Function(int) onDestinationSelected;

  @override
  State<StatefulWidget> createState() => _BloqoNavBarState();

}

class _BloqoNavBarState extends State<BloqoNavBar>{

  static const navBarIconSize = 30.0;

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    return NavigationBar(
      onDestinationSelected: (index) {
        widget.onDestinationSelected(index);
        setState(() {
          currentPageIndex = index;
        });
      },
      indicatorColor: BloqoColors.newDarkFuchsia,
      animationDuration: const Duration(),
      elevation: 2,
      overlayColor: MaterialStateProperty.all(BloqoColors.newDarkFuchsia),
      selectedIndex: currentPageIndex,
      backgroundColor: BloqoColors.darkFuchsia,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: const Icon(
            Icons.home_outlined, color: BloqoColors.russianViolet,
            size: navBarIconSize,),
          icon: const Icon(Icons.home_outlined, color: BloqoColors.seasalt,
            size: navBarIconSize,),
          label: localizedText.home,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.book, color: BloqoColors.russianViolet,
            size: navBarIconSize,),
          icon: const Icon(Icons.book, color: BloqoColors.seasalt,
            size: navBarIconSize,),
          label: localizedText.learn,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.search, color: BloqoColors.russianViolet,
            size: navBarIconSize,),
          icon: const Icon(Icons.search, color: BloqoColors.seasalt,
            size: navBarIconSize,),
          label: localizedText.search,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.edit, color: BloqoColors.russianViolet,
            size: navBarIconSize,),
          icon: const Icon(Icons.edit, color: BloqoColors.seasalt,
            size: navBarIconSize,),
          label: localizedText.editor,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.person, color: BloqoColors.russianViolet,
            size: navBarIconSize,),
          icon: const Icon(Icons.person, color: BloqoColors.seasalt,
            size: navBarIconSize,),
          label: localizedText.account,
        ),
      ],
    );
  }

}