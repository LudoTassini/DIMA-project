import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';

class BloqoSeasaltContainer extends StatelessWidget {
  const BloqoSeasaltContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
    this.borderColor = BloqoColors.seasalt,
    this.borderRadius = 15,
    this.borderWidth,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final double borderRadius;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: BloqoColors.seasalt,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderWidth == null? null : Border.all(
            width: borderWidth!,
            color: borderColor,
          ),
        ),
        child: child
      )
    );
  }
}