import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';

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
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(
            Icons.home_outlined, color: BloqoColors.russianViolet,
            size: navBarIconSize,),
          icon: Icon(Icons.home_outlined, color: BloqoColors.seasalt,
            size: navBarIconSize,),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.book, color: BloqoColors.russianViolet,
            size: navBarIconSize,),
          icon: Icon(Icons.book, color: BloqoColors.seasalt,
            size: navBarIconSize,),
          label: 'Learn',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.search, color: BloqoColors.russianViolet,
            size: navBarIconSize,),
          icon: Icon(Icons.search, color: BloqoColors.seasalt,
            size: navBarIconSize,),
          label: 'Search',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.edit, color: BloqoColors.russianViolet,
            size: navBarIconSize,),
          icon: Icon(Icons.edit, color: BloqoColors.seasalt,
            size: navBarIconSize,),
          label: 'Editor',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person, color: BloqoColors.russianViolet,
            size: navBarIconSize,),
          icon: Icon(Icons.person, color: BloqoColors.seasalt,
            size: navBarIconSize,),
          label: 'Account',
        ),
      ],
    );
  }

}