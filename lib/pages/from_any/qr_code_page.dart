import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../components/containers/bloqo_main_container.dart';

class QrCodePage extends StatelessWidget {

  const QrCodePage({
    super.key,
    required this.qrCodeTitle,
    required this.qrCodeContent
  });

  final String qrCodeTitle;
  final String qrCodeContent;

  @override
  Widget build(BuildContext context) {
    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

    return BloqoMainContainer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            child: Text(
              qrCodeTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: theme.colors.highContrastColor
              ),
            )
          ),
          Padding(
            padding: !isTablet ? const EdgeInsets.all(20) : const EdgeInsets.all(60),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: QrImageView(
                  data: qrCodeContent,
                  version: QrVersions.auto,
                ),
              )
            )
          )
        ],
      ),
    );
  }

}
