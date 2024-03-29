import 'package:flutter/material.dart';

import '../../style/app_colors.dart';

class BloqoAppBar extends StatefulWidget {
  const BloqoAppBar({super.key, required this.title});

  final String title;

  @override
  State<BloqoAppBar> createState() => _BloqoAppBarState();
}

class _BloqoAppBarState extends State<BloqoAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      backgroundColor: AppColors.russianViolet,
    );
  }

}