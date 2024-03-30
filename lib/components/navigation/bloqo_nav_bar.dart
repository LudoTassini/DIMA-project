import 'package:flutter/material.dart';

import '../../style/app_colors.dart';

class BloqoNavBar extends StatefulWidget {
  const BloqoNavBar({super.key});

  static const navBarIconSize = 30.0;

  @override
  State<BloqoNavBar> createState() => _BloqoNavBarState();
}

class _BloqoNavBarState extends State<BloqoNavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme (
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) => states.contains(MaterialState.selected)
                ? const TextStyle(
                    color: AppColors.russianViolet,
                    fontSize: 14
                )
                : const TextStyle(
                    color: AppColors.seasalt,
                    fontSize: 14
                ),
          ),
        ),

        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: AppColors.newFuchsiaRose,
          animationDuration: const Duration(),
          elevation: 2,
          overlayColor: MaterialStateProperty.all(AppColors.fuchsiaRose),
          selectedIndex: currentPageIndex,
          backgroundColor: AppColors.fuchsiaRose,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home_outlined, color: AppColors.russianViolet, size: BloqoNavBar.navBarIconSize,),
              icon: Icon(Icons.home_outlined, color: AppColors.seasalt, size: BloqoNavBar.navBarIconSize,),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.book, color: AppColors.russianViolet, size: BloqoNavBar.navBarIconSize,),
              icon: Icon(Icons.book, color: AppColors.seasalt, size: BloqoNavBar.navBarIconSize,),
              label: 'Learn',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.search, color: AppColors.russianViolet, size: BloqoNavBar.navBarIconSize,),
              icon: Icon(Icons.search, color: AppColors.seasalt, size: BloqoNavBar.navBarIconSize,),
              label: 'Search',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.edit, color: AppColors.russianViolet, size: BloqoNavBar.navBarIconSize,),
              icon: Icon(Icons.edit, color: AppColors.seasalt, size: BloqoNavBar.navBarIconSize,),
              label: 'Editor',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person, color: AppColors.russianViolet, size: BloqoNavBar.navBarIconSize,),
              icon: Icon(Icons.person, color: AppColors.seasalt, size: BloqoNavBar.navBarIconSize,),
              label: 'Account',
            ),
          ],
        )
    );
  }
}