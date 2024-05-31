import 'package:flutter/material.dart';

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
    return BloqoMainContainer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(qrCodeTitle),
          /*QrImage(
            data: qrCodeContent,
            version: QrVersions.auto,
            size: 200.0,
          ),*/
        ],
      ),
    );
  }

}
