import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';

class BloqoMainContainer extends StatelessWidget{
  const BloqoMainContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BloqoColors.russianViolet,
            BloqoColors.darkFuchsia
          ],
          stops: [0, 1],
          begin: AlignmentDirectional(0, -1),
          end: AlignmentDirectional(0, 1),
        ),
      ),
      alignment: const AlignmentDirectional(0, 0),
      child: SafeArea(
        bottom: false,
        child: child
      )
    );
  }

}