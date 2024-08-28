import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:flutter/material.dart';

class BloqoSeasaltContainer extends StatelessWidget {
  const BloqoSeasaltContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
    this.borderColor,
    this.borderRadius = 15,
    this.borderWidth,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final double borderRadius;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    var theme = getAppThemeFromAppState(context: context);
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.highContrastColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderWidth == null? null : Border.all(
            width: borderWidth!,
            color: borderColor ?? theme.colors.highContrastColor,
          ),
        ),
        child: child
      )
    );
  }
}