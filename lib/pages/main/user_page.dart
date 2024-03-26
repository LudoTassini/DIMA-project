import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'nav_bar.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});

  final String title;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.russianViolet,
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}