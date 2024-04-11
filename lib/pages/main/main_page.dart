import 'package:bloqo/pages/main/search_page.dart';
import 'package:bloqo/pages/main/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state/navigation_app_state.dart';
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

  @override
  Widget build(BuildContext context) {

    final int currentMainPageIndex = Provider.of<NavigationAppState>(context).get();
    final String title;
    final Widget body;
    switch(currentMainPageIndex){
      case 0:
        title = "Welcome, ${Provider.of<UserAppState>(context, listen: false).get()!.username}!";
        body = const HomePage();
        break;
      case 1:
        title = "Learn";
        body = const LearnPage();
        break;
      case 2:
        title = "Search";
        body = const SearchPage();
        break;
      case 3:
        title = "Editor";
        body = const EditorPage();
        break;
      case 4:
        title = "Account and Settings";
        body = const UserPage();
        break;
      default:
        title = "Error";
        body = const Text("Error");
        break;
    }

    return Scaffold(
        appBar: BloqoAppBar.get(context: context, title: title),
        bottomNavigationBar: const BloqoNavBar(),
        body: body,
        resizeToAvoidBottomInset: false
    );
  }

}