import 'package:event_flow/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Add this import

class EventRegistrationCard extends StatelessWidget {
  final String eventName;
  final String attendeeName;
  final String eventDetails;
  final String eventLocation;
  final String qrData;
  final double completionPercentage;

  const EventRegistrationCard({
    super.key,
    required this.eventName,
    required this.attendeeName,
    required this.eventDetails,
    required this.eventLocation,
    required this.qrData,
    this.completionPercentage = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.appGrey.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 26.0,
              left: 16.0,
              right: 16.0,
              bottom: 8.0,
            ),
            child: Text(
              'Event Registration',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Event Card with QR Code
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF7B8CDE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Left side - Event details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attendeeName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          eventDetails,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white30, thickness: 1),
                        const SizedBox(height: 8),
                        Text(
                          eventLocation,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8),
                  // Right side - QR Code
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: QrImageView(
                      // This is from qr_flutter package
                      data: qrData,
                      version: QrVersions.auto,
                      size: 100.0,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 📊 Poll Section as a Card
          Card(
            color: AppColors.surface.withValues(alpha: 0.9), // soft beige
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Poll',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: completionPercentage,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF7B8CDE),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
