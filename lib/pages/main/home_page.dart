import 'package:bloqo/components/navigation/bloqo_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../style/app_colors.dart';

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
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.russianViolet,
      ),
      bottomNavigationBar: const BloqoNavBar(),
      );
  }

}