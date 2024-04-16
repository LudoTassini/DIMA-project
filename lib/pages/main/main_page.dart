import 'package:bloqo/pages/main/search_page.dart';
import 'package:bloqo/pages/main/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_app_state.dart';
import '../../components/navigation/bloqo_app_bar.dart';
import '../../components/navigation/bloqo_nav_bar.dart';
import 'editor_page.dart';
import 'home_page.dart';
import 'learn_page.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();

}

class _MainPageState extends State<MainPage>{

  int _selectedPageIndex = 0;
  late List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState(){
    super.initState();
    _selectedPageIndex = 0;
    _pages = [
      const HomePage(),
      const LearnPage(),
      const SearchPage(),
      const EditorPage(),
      const UserPage()
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    late String title;
    switch(_selectedPageIndex){
      case 0:
        title = "Welcome, ${Provider.of<UserAppState>(context, listen: false).get()!.username}!";
        break;
      case 1:
        title = "Learn";
        break;
      case 2:
        title = "Search";
        break;
      case 3:
        title = "Editor";
        break;
      case 4:
        title = "Account and Settings";
        break;
      default:
        title = "Error";
        break;
    }

    return Scaffold(
        appBar: BloqoAppBar.get(context: context, title: title),
        bottomNavigationBar: BloqoNavBar(
          onDestinationSelected: (int index) {
            setState(() {
              _selectedPageIndex = index;
              _pageController.jumpToPage(index);
            });
          },
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        resizeToAvoidBottomInset: false
    );
  }

}