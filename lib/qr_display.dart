import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDisplay extends StatelessWidget {
  final String qrString;

  QrDisplay({@required this.qrString}) : assert(qrString != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(12.0),
          child: QrImage(
            data: qrString,
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
      ),
    );
  }
}
