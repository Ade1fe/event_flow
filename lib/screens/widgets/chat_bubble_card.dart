import 'package:flutter/material.dart';

class ChatBubbleCard extends StatelessWidget {
  const ChatBubbleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://i.pravatar.cc/150?img=8', // Replace with your background image URL
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(
              alpha: .3,
            ), // Add overlay for text visibility
            BlendMode.darken,
          ),
        ),
        color: Colors.white, // Fallback color if image is not loaded
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(0), // Tail side should not have a radius
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align everything to the left
        children: [
          // Event Title
          Text(
            'Event Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text for visibility
            ),
          ),
          SizedBox(height: 8),
          // Event Description
          Text(
            'Check out the latest event details. Join us for an exciting experience!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70, // Slightly muted text
            ),
          ),
          SizedBox(height: 16),
          // Button inside the chat bubble
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue.shade600,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'View Details',
              style: TextStyle(
                color: Colors.blue.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
