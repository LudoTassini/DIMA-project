import 'package:flutter/material.dart';

import '../../style/app_colors.dart';

class BloqoMainContainer extends StatelessWidget{
  const BloqoMainContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.russianViolet,
            AppColors.fuchsiaRose
          ],
          stops: [0, 1],
          begin: AlignmentDirectional(0.87, -1),
          end: AlignmentDirectional(-0.87, 1),
        ),
      ),
      alignment: const AlignmentDirectional(0, 0),
      child: SingleChildScrollView(
        child: child
      )
    );
  }

}