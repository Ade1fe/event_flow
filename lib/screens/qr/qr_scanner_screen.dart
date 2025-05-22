import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  final String eventId;

  const QRScannerScreen({super.key, required this.eventId});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;
  String? lastScanned;
  bool isFlashOn = false;
  bool isFrontCamera = false;
  bool isRequestSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          // Flash toggle button
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: isFlashOn ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
                cameraController.toggleTorch();
              });
            },
          ),
          // Camera switch button
          IconButton(
            icon: Icon(isFrontCamera ? Icons.camera_front : Icons.camera_rear),
            onPressed: () {
              setState(() {
                isFrontCamera = !isFrontCamera;
                cameraController.switchCamera();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child:
                isScanning
                    ? MobileScanner(
                      controller: cameraController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          if (barcode.rawValue != null &&
                              barcode.rawValue != lastScanned &&
                              !isRequestSending) {
                            setState(() {
                              isScanning = false;
                              lastScanned = barcode.rawValue;
                            });
                            _processQRCode(barcode.rawValue!);
                            break;
                          }
                        }
                      },
                    )
                    : Center(
                      child:
                          isRequestSending
                              ? _buildRequestSendingUI()
                              : _buildScannedResultUI(),
                    ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scanning Instructions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Point your camera at the QR code',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '2. Hold steady until the code is recognized',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '3. Review the details and submit for approval',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestSendingUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 24),
        const Text(
          'Sending Request...',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Please wait while we process your request',
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScannedResultUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.qr_code_scanner, color: Colors.blue, size: 80),
        const SizedBox(height: 16),
        const Text(
          'QR Code Scanned!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            lastScanned ?? '',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isScanning = true;
                  lastScanned = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                _sendApprovalRequest(lastScanned ?? '');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Request Approval'),
            ),
          ],
        ),
      ],
    );
  }

  void _processQRCode(String data) {
    // Check if it's a valid event-flow QR code
    if (data.contains('event-flow.app') || data.contains('http')) {
      // Valid QR code - show the scanned result UI
      // The user will need to confirm before sending the approval request
    } else {
      // Invalid QR code
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid QR code. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        isScanning = true;
        lastScanned = null;
      });
    }
  }

  Future<void> _sendApprovalRequest(String qrData) async {
    // Set loading state
    setState(() {
      isRequestSending = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would send the data to your backend:
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/check-in-requests'),
      //   body: {
      //     'eventId': widget.eventId,
      //     'qrData': qrData,
      //     'timestamp': DateTime.now().toIso8601String(),
      //   },
      // );

      // Show success dialog
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: const Text('Request Sent'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Your request has been sent for approval',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The event organizer will review your request shortly.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Return to previous screen
                  },
                  child: const Text('Done'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    setState(() {
                      isScanning = true;
                      lastScanned = null;
                      isRequestSending = false;
                    });
                  },
                  child: const Text('Scan Another'),
                ),
              ],
            ),
      );
    } catch (e) {
      // Show error
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending request: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        isRequestSending = false;
      });
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
