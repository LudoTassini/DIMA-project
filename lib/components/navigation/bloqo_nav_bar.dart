import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state/navigation_app_state.dart';
import '../../style/bloqo_colors.dart';

class BloqoNavBar extends StatelessWidget {
  const BloqoNavBar({super.key});

  static const navBarIconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme (
      data: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) => states.contains(MaterialState.selected)
              ? const TextStyle(
              color: BloqoColors.russianViolet,
              fontWeight: FontWeight.w500,
              fontSize: 15
          )
              : const TextStyle(
              color: BloqoColors.seasalt,
              fontWeight: FontWeight.w500,
              fontSize: 15
          ),
        ),
      ),
      child: Consumer<NavigationAppState>(
        builder: (context, navigationAppState, child) {
          return NavigationBar(
            onDestinationSelected: (int index) {
              navigationAppState.set(index);
            },
            indicatorColor: BloqoColors.newDarkFuchsia,
            animationDuration: const Duration(),
            elevation: 2,
            overlayColor: MaterialStateProperty.all(BloqoColors.newDarkFuchsia),
            selectedIndex: navigationAppState.get(),
            backgroundColor: BloqoColors.darkFuchsia,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.home_outlined, color: BloqoColors.russianViolet,
                  size: BloqoNavBar.navBarIconSize,),
                icon: Icon(Icons.home_outlined, color: BloqoColors.seasalt,
                  size: BloqoNavBar.navBarIconSize,),
                label: 'Home',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.book, color: BloqoColors.russianViolet,
                  size: BloqoNavBar.navBarIconSize,),
                icon: Icon(Icons.book, color: BloqoColors.seasalt,
                  size: BloqoNavBar.navBarIconSize,),
                label: 'Learn',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.search, color: BloqoColors.russianViolet,
                  size: BloqoNavBar.navBarIconSize,),
                icon: Icon(Icons.search, color: BloqoColors.seasalt,
                  size: BloqoNavBar.navBarIconSize,),
                label: 'Search',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.edit, color: BloqoColors.russianViolet,
                  size: BloqoNavBar.navBarIconSize,),
                icon: Icon(Icons.edit, color: BloqoColors.seasalt,
                  size: BloqoNavBar.navBarIconSize,),
                label: 'Editor',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person, color: BloqoColors.russianViolet,
                  size: BloqoNavBar.navBarIconSize,),
                icon: Icon(Icons.person, color: BloqoColors.seasalt,
                  size: BloqoNavBar.navBarIconSize,),
                label: 'Account',
              ),
            ],
          );
        }
      )
    );
  }

}