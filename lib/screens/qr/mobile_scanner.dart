// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:go_router/go_router.dart';

// class QRScannerPage extends StatefulWidget {
//   const QRScannerPage({super.key});

//   @override
//   State<QRScannerPage> createState() => _QRScannerPageState();
// }

// class _QRScannerPageState extends State<QRScannerPage> {
//   final GlobalKey<MobileScannerState> qrKey = GlobalKey<MobileScannerState>();
//   bool isScanned = false;

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       qrKey.currentState?.pause();
//     } else if (Platform.isIOS) {
//       qrKey.currentState?.resume();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Scan QR Code')),
//       body: MobileScanner(
//         key: qrKey,
//         onDetect: (barcode, args) {
//           if (!isScanned) {
//             isScanned = true;
//             final scannedUrl = barcode.rawValue;
//             debugPrint('Scanned: $scannedUrl');

//             if (scannedUrl != null && scannedUrl.contains('/event/')) {
//               final eventId = scannedUrl.split('/event/').last;
//               context.go('/event/$eventId'); // Adjust route if using GoRouter
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Invalid QR Code')),
//               );
//               Navigator.pop(context);
//             }
//           }
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
