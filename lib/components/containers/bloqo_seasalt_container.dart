import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';

class BloqoSeasaltContainer extends StatelessWidget {
  const BloqoSeasaltContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
    final double? height,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: BloqoColors.seasalt,
          borderRadius: BorderRadius.circular(15),
        ),
        child: child
      )
    );
  }
}