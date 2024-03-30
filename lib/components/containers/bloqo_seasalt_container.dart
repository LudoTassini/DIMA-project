import 'package:flutter/material.dart';

import '../../style/app_colors.dart';

class BloqoSeasaltContainer extends StatelessWidget {
  const BloqoSeasaltContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.seasalt,
          borderRadius: BorderRadius.circular(15),
        ),
        child: child
      )
    );
  }
}