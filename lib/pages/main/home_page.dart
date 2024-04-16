import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Text("Home page");
  }

  @override
  bool get wantKeepAlive => true;

}