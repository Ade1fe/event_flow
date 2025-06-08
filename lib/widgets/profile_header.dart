// import 'package:flutter/material.dart';
// import '../models/user_profile.dart';

// class ProfileHeader extends StatelessWidget {
//   final UserProfile? userProfile;

//   const ProfileHeader({
//     super.key,
//     required this.userProfile,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Avatar
//         CircleAvatar(
//           radius: 50,
//           backgroundColor:
//               Theme.of(context).colorScheme.primary.withValues(alpha:0.2),
//           child: userProfile?.photoUrl != null
//               ? ClipOval(
//                   child: Image.network(
//                     userProfile!.photoUrl!,
//                     width: 100,
//                     height: 100,
//                     fit: BoxFit.cover,
//                   ),
//                 )
//               : Text(
//                   userProfile?.initials ?? 'U',
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//         ),
//         SizedBox(height: 16),

//         // Name
//         Text(
//           userProfile?.displayName ?? 'User',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 4),

//         // Email
//         Text(
//           userProfile?.email ?? '',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey,
//           ),
//         ),
//         SizedBox(height: 16),

//         // Stats
//         Container(
//           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStat(
//                 context,
//                 'Tasks',
//                 userProfile?.taskCount.toString() ?? '0',
//               ),
//               _buildDivider(),
//               _buildStat(
//                 context,
//                 'Completed',
//                 userProfile?.completedTaskCount.toString() ?? '0',
//               ),
//               _buildDivider(),
//               _buildStat(
//                 context,
//                 'Success Rate',
//                 '${((userProfile?.completionRate ?? 0) * 100).toStringAsFixed(0)}%',
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStat(BuildContext context, String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDivider() {
//     return Container(
//       height: 30,
//       width: 1,
//       color: Colors.grey.withValues(alpha:0.3),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  // Make userProfile optional
  final UserProfile? userProfile;

  const ProfileHeader({super.key, this.userProfile});

  @override
  Widget build(BuildContext context) {
    // If userProfile is not provided, get it from the provider
    final profile =
        userProfile ?? Provider.of<AuthProvider>(context).userProfile;
    final taskProvider = Provider.of<TaskProvider>(context);

    // Calculate stats if not available in profile
    final taskCount = profile?.taskCount ?? taskProvider.totalTasks;
    final completedTaskCount =
        profile?.completedTaskCount ?? taskProvider.completedTasks;
    final completionRate =
        profile?.completionRate ?? taskProvider.completionRate;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 14, left: 1, right: 1),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: isDark
                    ? theme.colorScheme.primary.withValues(alpha: 0.9)
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                child: profile?.photoUrl != null
                    ? ClipOval(
                        child: Image.network(
                          profile!.photoUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              profile.initials,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: theme
                                    .colorScheme
                                    .onPrimary, // for good contrast
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        profile?.initials ?? 'U',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          // color: theme
                          //     .colorScheme
                          //     .onPrimary, // matches avatar bg contrast
                          color: isDark
                              ? theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.9,
                                )
                              : theme.colorScheme.primary,
                        ),
                      ),
              ),

              const SizedBox(width: 16), // space between avatar and text
              // Name & Email
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile?.displayName ?? 'User',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface, // adaptive text color
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.email ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ), // softer subtitle
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Stats
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
            color: isDark
                ? theme.colorScheme.primary.withValues(alpha: .9)
                : theme.colorScheme.primary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(context, 'Tasks', taskCount.toString()),
              _buildDivider(),
              _buildStat(context, 'Completed', completedTaskCount.toString()),
              _buildDivider(),
              _buildStat(
                context,
                'Success Rate',
                '${(completionRate * 100).toStringAsFixed(0)}%',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            // color: Theme.of(context).colorScheme.primary,
            color: isDark ? Colors.white : theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey.shade300 : theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.3),
    );
  }
}
