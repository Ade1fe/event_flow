import 'package:event_flow/screens/qr/approval_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:event_flow/theme/theme.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onProfilePressed;
  final String title;
  final String? profileImageUrl;

  const AppHeader({
    super.key,
    required this.onMenuPressed,
    required this.onProfilePressed,
    this.title = 'Designer',
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // To avoid default back button
      backgroundColor: AppColors.background, // Clean background color
      elevation: 0, // No shadow for a flat design
      centerTitle: true, // Center the title
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackground,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, color: AppColors.onBackground), // Menu button
        onPressed: onMenuPressed,
      ),
      actions: [
        // Notification Icon with Badge
        Stack(
          clipBehavior: Clip.none, // To position the badge outside
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: AppColors.onBackground,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApprovalRequestsScreen(),
                  ),
                );
              },
              splashRadius: 24, // Make the tap area larger for better UX
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: const Text(
                  '3', // You can replace this dynamically
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),

        // Profile Avatar with a smooth rounded effect
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: onProfilePressed,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.secondary,
              backgroundImage:
                  profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : null,
              child:
                  profileImageUrl == null
                      ? Icon(Icons.person, color: AppColors.onSecondary)
                      : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Standard height
}
