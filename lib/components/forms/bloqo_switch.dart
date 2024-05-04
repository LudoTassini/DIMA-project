import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';
import '../../utils/toggle.dart';

class BloqoSwitch extends StatefulWidget{
  const BloqoSwitch({
    super.key,
    required this.value,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 0, 5, 0)
  });

  final Toggle value;
  final EdgeInsetsGeometry padding;

  @override
  State<BloqoSwitch> createState() => _BloqoSwitchState();
}

class _BloqoSwitchState extends State<BloqoSwitch>{

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: widget.padding,
          child: Switch.adaptive(
            value: widget.value.get(),
            onChanged: (newValue) async {
              setState(() => widget.value.toggle());
            },
            activeColor: BloqoColors.russianViolet,
            activeTrackColor: BloqoColors.russianViolet,
            inactiveTrackColor: BloqoColors.inactiveTracker,
            inactiveThumbColor: BloqoColors.seasalt,
          ),
        ),
        Text(
          widget.value.get() ? localizedText.yes : localizedText.no,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: BloqoColors.russianViolet,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

}