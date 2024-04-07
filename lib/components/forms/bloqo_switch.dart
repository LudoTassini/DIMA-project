import 'package:flutter/material.dart';

import '../../style/app_colors.dart';
import '../../utils/toggle.dart';

class BloqoSwitch extends StatefulWidget{
  const BloqoSwitch({
    super.key,
    required this.value,
  });

  final Toggle value;

  @override
  State<BloqoSwitch> createState() => _BloqoSwitchState();
}

class _BloqoSwitchState extends State<BloqoSwitch>{

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
              15, 0, 5, 0),
          child: Switch.adaptive(
            value: widget.value.get(),
            onChanged: (newValue) async {
              setState(() => widget.value.toggle());
            },
            activeColor: AppColors.russianViolet,
            activeTrackColor: AppColors.russianViolet,
            inactiveTrackColor: AppColors.inactiveTracker,
            inactiveThumbColor: AppColors.seasalt,
          ),
        ),
        Text(
          widget.value.get() ? 'Yes': 'No',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.russianViolet,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

}