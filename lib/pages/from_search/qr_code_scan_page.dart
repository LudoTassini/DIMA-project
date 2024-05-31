import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../components/containers/bloqo_main_container.dart';

class QrCodeScanPage extends StatefulWidget {

  const QrCodeScanPage({
    super.key,
    required this.onPush,
  });

  final void Function(Widget) onPush;

  @override
  State<QrCodeScanPage> createState() => _QrCodeScanPageState();

}

class _QrCodeScanPageState extends State<QrCodeScanPage> with AutomaticKeepAliveClientMixin<QrCodeScanPage>{

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BloqoMainContainer(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('ID Utente: ${result!.code}') //TODO
                  : Text('Scansiona un QR code'),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (result != null) {
        // TODO need to understand if code is user or course
        // TODO widget.onPush();
      }
    });
  }

}