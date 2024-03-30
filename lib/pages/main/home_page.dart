import 'package:bloqo/components/navigation/bloqo_app_bar.dart';
import 'package:bloqo/components/navigation/bloqo_nav_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BloqoAppBar.get(context: context, title: widget.title),
      bottomNavigationBar: const BloqoNavBar(),
      );
  }

}