import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:flutter/material.dart';

class BloqoSetting extends StatelessWidget{
  const BloqoSetting({
    super.key,
    required this.onPressed,
    required this.settingTitle,
    required this.settingDescription,
    required this.settingIcon
  });

  final Function() onPressed;
  final String settingTitle;
  final String settingDescription;
  final IconData settingIcon;

  @override
  Widget build(BuildContext context) {
    var theme = getAppThemeFromAppState(context: context);
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
        child: ElevatedButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.resolveWith((states) => const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8)),
            backgroundColor: WidgetStateProperty.resolveWith((states) => theme.colors.highContrastColor),
            shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 10, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settingTitle,
                        style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 50, 10),
                        child: Text(
                          settingDescription,
                          textAlign: TextAlign.start,
                          style: theme.getThemeData().textTheme.bodyMedium?.copyWith(
                            fontSize: 18,
                            letterSpacing: 0,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  settingIcon,
                  color: theme.colors.leadingColor,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
    );
  }
}