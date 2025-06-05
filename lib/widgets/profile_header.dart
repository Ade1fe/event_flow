import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile? userProfile;

  const ProfileHeader({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        CircleAvatar(
          radius: 50,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.2),
          child: userProfile?.photoUrl != null
              ? ClipOval(
                  child: Image.network(
                    userProfile!.photoUrl!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : Text(
                  userProfile?.initials ?? 'U',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
        ),
        SizedBox(height: 16),

        // Name
        Text(
          userProfile?.displayName ?? 'User',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),

        // Email
        Text(
          userProfile?.email ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 16),

        // Stats
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(
                context,
                'Tasks',
                userProfile?.taskCount.toString() ?? '0',
              ),
              _buildDivider(),
              _buildStat(
                context,
                'Completed',
                userProfile?.completedTaskCount.toString() ?? '0',
              ),
              _buildDivider(),
              _buildStat(
                context,
                'Success Rate',
                '${((userProfile?.completionRate ?? 0) * 100).toStringAsFixed(0)}%',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}
