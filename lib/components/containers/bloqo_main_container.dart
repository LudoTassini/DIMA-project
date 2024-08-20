import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:flutter/material.dart';

class BloqoMainContainer extends StatefulWidget {
  const BloqoMainContainer({
    super.key,
    required this.child,
    this.alignment = const AlignmentDirectional(0, 0)
  });

  final Widget child;
  final AlignmentGeometry alignment;

  @override
  State<BloqoMainContainer> createState() => _BloqoMainContainerState();

}

class _BloqoMainContainerState extends State<BloqoMainContainer> {

  @override
  Widget build(BuildContext context) {
    var theme = getAppThemeFromAppState(context: context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colors.leadingColor,
            theme.colors.trailingColor
          ],
          stops: const [0, 1],
          begin: const AlignmentDirectional(0, -1),
          end: const AlignmentDirectional(0, 1),
        ),
      ),
      alignment: widget.alignment,
      child: SafeArea(
        bottom: false,
        child: widget.child
      )
    );
  }

}