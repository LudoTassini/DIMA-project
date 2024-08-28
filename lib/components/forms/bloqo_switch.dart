import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:flutter/material.dart';

import '../../utils/localization.dart';
import '../../utils/toggle.dart';

class BloqoSwitch extends StatefulWidget {
  const BloqoSwitch({
    super.key,
    required this.value,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 0, 5, 0),
    this.editable = true,
  });

  final Toggle value;
  final EdgeInsetsGeometry padding;
  final bool editable;

  @override
  State<BloqoSwitch> createState() => _BloqoSwitchState();
}

class _BloqoSwitchState extends State<BloqoSwitch> {
  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: widget.padding,
          child: Switch.adaptive(
            value: widget.value.get(),
            onChanged: widget.editable
                ? (newValue) async {
              setState(() => widget.value.toggle());
            }
                : null,
            activeColor: theme.colors.leadingColor,
            activeTrackColor: theme.colors.leadingColor,
            inactiveTrackColor: theme.colors.inactiveTracker,
            inactiveThumbColor: theme.colors.highContrastColor,
          ),
        ),
        Text(
          widget.value.get() ? localizedText.yes : localizedText.no,
          style: theme
              .getThemeData()
              .textTheme
              .displaySmall
              ?.copyWith(
            color: theme.colors.leadingColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}