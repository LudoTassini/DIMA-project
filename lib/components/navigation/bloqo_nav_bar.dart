import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state/navigation_app_state.dart';
import '../../style/app_colors.dart';

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
              color: AppColors.russianViolet,
              fontWeight: FontWeight.w500,
              fontSize: 15
          )
              : const TextStyle(
              color: AppColors.seasalt,
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
            indicatorColor: AppColors.newDarkFuchsia,
            animationDuration: const Duration(),
            elevation: 2,
            overlayColor: MaterialStateProperty.all(AppColors.newDarkFuchsia),
            selectedIndex: navigationAppState.get(),
            backgroundColor: AppColors.darkFuchsia,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.home_outlined, color: AppColors.russianViolet,
                  size: BloqoNavBar.navBarIconSize,),
                icon: Icon(Icons.home_outlined, color: AppColors.seasalt,
                  size: BloqoNavBar.navBarIconSize,),
                label: 'Home',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.book, color: AppColors.russianViolet,
                  size: BloqoNavBar.navBarIconSize,),
                icon: Icon(Icons.book, color: AppColors.seasalt,
                  size: BloqoNavBar.navBarIconSize,),
                label: 'Learn',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.search, color: AppColors.russianViolet,
                  size: BloqoNavBar.navBarIconSize,),
                icon: Icon(Icons.search, color: AppColors.seasalt,
                  size: BloqoNavBar.navBarIconSize,),
                label: 'Search',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.edit, color: AppColors.russianViolet,
                  size: BloqoNavBar.navBarIconSize,),
                icon: Icon(Icons.edit, color: AppColors.seasalt,
                  size: BloqoNavBar.navBarIconSize,),
                label: 'Editor',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person, color: AppColors.russianViolet,
                  size: BloqoNavBar.navBarIconSize,),
                icon: Icon(Icons.person, color: AppColors.seasalt,
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