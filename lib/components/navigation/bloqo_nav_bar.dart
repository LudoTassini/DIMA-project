import 'package:flutter/material.dart';

import '../../style/app_colors.dart';

class BloqoNavBar extends StatefulWidget {
  const BloqoNavBar({super.key});

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
                ? const TextStyle(color: AppColors.russianViolet)
                : const TextStyle(color: AppColors.seasalt),
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
              selectedIcon: Icon(Icons.home_outlined, color: AppColors.russianViolet),
              icon: Icon(Icons.home_outlined, color: AppColors.seasalt,),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.book, color: AppColors.russianViolet),
              icon: Icon(Icons.book, color: AppColors.seasalt,),
              label: 'Learn',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.search, color: AppColors.russianViolet),
              icon: Icon(Icons.search, color: AppColors.seasalt,),
              label: 'Search',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.edit, color: AppColors.russianViolet),
              icon: Icon(Icons.edit, color: AppColors.seasalt,),
              label: 'Editor',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person, color: AppColors.russianViolet),
              icon: Icon(Icons.person, color: AppColors.seasalt,),
              label: 'Account',
            ),
          ],
        )
    );
  }
}