import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  bool isScanned = false;

  @override
  void reassemble() {
    super.reassemble();
    MobileScannerController controller = MobileScannerController();
    if (Platform.isAndroid) {
      controller.stop();
    } else if (Platform.isIOS) {
      controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: MobileScanner(
        controller: MobileScannerController(facing: CameraFacing.back),
        onDetect: (BarcodeCapture capture) {
          if (isScanned) return;

          final Barcode? barcode = capture.barcodes.firstOrNull;
          final String? scannedUrl = barcode?.rawValue;

          if (scannedUrl != null && scannedUrl.contains('/event/')) {
            isScanned = true;
            final eventId = scannedUrl.split('/event/').last;
            context.go('/event/$eventId');
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Invalid QR Code')));
          }
        },
      ),
    );
  }
}
