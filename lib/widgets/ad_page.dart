import 'package:flutter/material.dart';

class AdPage extends StatelessWidget {
  final String title;
  final String description;
  final String backgroundImage;
  final VoidCallback? onAction;
  final String? buttonText;

  const AdPage({
    super.key,
    required this.title,
    required this.description,
    required this.backgroundImage,
    this.onAction,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, // ✅ Give it a fixed height
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: .4),
            BlendMode.darken,
          ),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onAction != null)
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(buttonText ?? 'Learn More'),
              ),
            ),
        ],
      ),
    );
  }
}
