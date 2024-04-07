import 'package:flutter/material.dart';

import '../../style/app_colors.dart';
import '../../components/navigation/bloqo_nav_bar.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});

  final String title;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: const BloqoNavBar()
    );
  }
}