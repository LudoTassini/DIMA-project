import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
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
          BloqoSeasaltContainer(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: QrImageView(
                data: qrCodeContent,
                version: QrVersions.auto,
              ),
            )
          )
        ],
      ),
    );
  }

}
