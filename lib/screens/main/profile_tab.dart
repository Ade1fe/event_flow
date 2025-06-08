// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../../providers/auth_provider.dart';
// // import '../../providers/theme_provider.dart';
// // import '../../widgets/profile_header.dart';
// // import '../../widgets/settings_tile.dart';
// // import '../auth/login_screen.dart';

// // class ProfileTab extends StatelessWidget {
// //   const ProfileTab({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final authProvider = Provider.of<AuthProvider>(context);
// //     final themeProvider = Provider.of<ThemeProvider>(context);

// //     Future<void> deleteAccountData() async {
// //       final prefs = await SharedPreferences.getInstance();

// //       // Remove individual keys
// //       await prefs.remove('userToken');
// //       await prefs.remove('userEmail');
// //       await prefs.remove('userId');
// //       // Add other keys as needed
// //     }

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Profile'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.edit),
// //             onPressed: () {
// //               // TODO: Navigate to edit profile
// //             },
// //           ),
// //         ],
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             // Profile header
// //             ProfileHeader(
// //               userProfile: authProvider.userProfile,
// //             ),
// //             SizedBox(height: 32),

// //             // Settings section
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Theme.of(context).colorScheme.surface,
// //                 borderRadius: BorderRadius.circular(16),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withValues(alpha:0.1),
// //                     blurRadius: 8,
// //                     offset: Offset(0, 2),
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 children: [
// //                   SettingsTile(
// //                     icon: Icons.person_outline,
// //                     title: 'Account Settings',
// //                     onTap: () {
// //                       // TODO: Navigate to account settings
// //                     },
// //                   ),
// //                   Divider(height: 1),
// //                   SettingsTile(
// //                     icon: Icons.notifications_outlined,
// //                     title: 'Notifications',
// //                     onTap: () {
// //                       // TODO: Navigate to notifications settings
// //                     },
// //                   ),
// //                   Divider(height: 1),
// //                   SettingsTile(
// //                     icon: themeProvider.isDarkMode
// //                         ? Icons.light_mode_outlined
// //                         : Icons.dark_mode_outlined,
// //                     title: 'Dark Mode',
// //                     trailing: Switch(
// //                       value: themeProvider.isDarkMode,
// //                       onChanged: (value) {
// //                         themeProvider.setThemeMode(
// //                           value ? ThemeMode.dark : ThemeMode.light,
// //                         );
// //                       },
// //                     ),
// //                     onTap: () {
// //                       themeProvider.toggleTheme();
// //                     },
// //                   ),
// //                   Divider(height: 1),
// //                   SettingsTile(
// //                     icon: Icons.language_outlined,
// //                     title: 'Language',
// //                     subtitle: 'English',
// //                     onTap: () {
// //                       // TODO: Navigate to language settings
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: 24),

// //             // Support section
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Theme.of(context).colorScheme.surface,
// //                 borderRadius: BorderRadius.circular(16),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withValues(alpha:0.1),
// //                     blurRadius: 8,
// //                     offset: Offset(0, 2),
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 children: [
// //                   SettingsTile(
// //                     icon: Icons.help_outline,
// //                     title: 'Help & Support',
// //                     onTap: () {
// //                       // TODO: Navigate to help & support
// //                     },
// //                   ),
// //                   Divider(height: 1),
// //                   SettingsTile(
// //                     icon: Icons.privacy_tip_outlined,
// //                     title: 'Privacy Policy',
// //                     onTap: () {
// //                       // TODO: Navigate to privacy policy
// //                     },
// //                   ),
// //                   Divider(height: 1),
// //                   SettingsTile(
// //                     icon: Icons.description_outlined,
// //                     title: 'Terms of Service',
// //                     onTap: () {
// //                       // TODO: Navigate to terms of service
// //                     },
// //                   ),
// //                   Divider(height: 1),
// //                   SettingsTile(
// //                     icon: Icons.info_outline,
// //                     title: 'About',
// //                     onTap: () {
// //                       // TODO: Navigate to about
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: 24),

// //             // Sign out button
// //             ElevatedButton.icon(
// //               onPressed: () async {
// //                 await deleteAccountData();
// //                 await authProvider.signOut();
// //                 Navigator.of(context).pushAndRemoveUntil(
// //                   MaterialPageRoute(builder: (context) => LoginScreen()),
// //                   (route) => false,
// //                 );
// //               },
// //               icon: Icon(Icons.logout),
// //               label: Text('Sign Out'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.red,
// //                 foregroundColor: Colors.white,
// //                 minimumSize: Size(double.infinity, 50),
// //               ),
// //             ),
// //             SizedBox(height: 32),

// //             // App version
// //             Text(
// //               'TaskMaster Pro v1.0.0',
// //               style: TextStyle(
// //                 color: Colors.grey,
// //                 fontSize: 12,
// //               ),
// //             ),
// //             SizedBox(height: 8),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:task_manager_clean/assets.dart';
// import 'package:task_manager_clean/widgets/ad_page.dart';
// import 'package:task_manager_clean/widgets/custom_app_bar.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/theme_provider.dart';
// import '../../widgets/profile_header.dart';
// import '../../widgets/settings_tile.dart';
// import '../auth/login_screen.dart';

// class ProfileTab extends StatelessWidget {
//   const ProfileTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     Future<void> deleteAccountData() async {
//       final prefs = await SharedPreferences.getInstance();

//       // Remove individual keys
//       await prefs.remove('userToken');
//       await prefs.remove('userEmail');
//       await prefs.remove('userId');
//       // Add other keys as needed
//     }

//     return Scaffold(
//       // appBar: CustomAppBar(
//       //   title: 'Settings',
//       //   showProfile: true,
//       //   showNotifications: true,
//       // ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Profile header with userProfile parameter
//             ProfileHeader(userProfile: authProvider.userProfile),
//             SizedBox(height: 32),

//             // Settings section
//             Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.surface,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.1),
//                     blurRadius: 8,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   SettingsTile(
//                     icon: Icons.person_outline,
//                     title: 'Account Settings',
//                     onTap: () {
//                       _showAccountSettings(context);
//                     },
//                   ),
//                   Divider(height: 1),
//                   SettingsTile(
//                     icon: Icons.notifications_outlined,
//                     title: 'Notifications',
//                     onTap: () {
//                       _showNotificationSettings(context);
//                     },
//                   ),
//                   Divider(height: 1),
//                   SettingsTile(
//                     icon: themeProvider.isDarkMode
//                         ? Icons.light_mode_outlined
//                         : Icons.dark_mode_outlined,
//                     title: 'Dark Mode',
//                     trailing: Switch(
//                       value: themeProvider.isDarkMode,
//                       onChanged: (value) {
//                         themeProvider.setThemeMode(
//                           value ? ThemeMode.dark : ThemeMode.light,
//                         );
//                       },
//                     ),
//                     onTap: () {
//                       themeProvider.toggleTheme();
//                     },
//                   ),
//                   Divider(height: 1),
//                   SettingsTile(
//                     icon: Icons.language_outlined,
//                     title: 'Language',
//                     subtitle: 'English',
//                     onTap: () {
//                       _showLanguageSettings(context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),

//             AdPage(
//               title: '50% Off All Items!',
//               description:
//                   'This weekend only. Don’t miss this limited-time offer.',
//               backgroundImage: AppAssets.sales,

//               buttonText: 'Shop Now',
//               onAction: () {
//                 Navigator.pop(context); // or open a promo page
//               },
//             ),

//             // Support section
//             Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.surface,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: .1),
//                     blurRadius: 8,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   SettingsTile(
//                     icon: Icons.help_outline,
//                     title: 'Help & Support',
//                     onTap: () {
//                       _showHelpDialog(context);
//                     },
//                   ),
//                   Divider(height: 1),
//                   SettingsTile(
//                     icon: Icons.privacy_tip_outlined,
//                     title: 'Privacy Policy',
//                     onTap: () {
//                       _showPrivacyPolicy(context);
//                     },
//                   ),
//                   Divider(height: 1),
//                   SettingsTile(
//                     icon: Icons.description_outlined,
//                     title: 'Terms of Service',
//                     onTap: () {
//                       _showTermsOfService(context);
//                     },
//                   ),
//                   Divider(height: 1),
//                   SettingsTile(
//                     icon: Icons.info_outline,
//                     title: 'About',
//                     onTap: () {
//                       _showAboutDialog(context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),

//             // Sign out button
//             ElevatedButton.icon(
//               onPressed: () async {
//                 _showSignOutDialog(context, deleteAccountData);
//               },
//               icon: Icon(Icons.logout),
//               label: Text('Sign Out'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//             SizedBox(height: 32),

//             // App version
//             Text(
//               'TaskMaster Pro v1.0.0',
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//             SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditProfileDialog(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final nameController = TextEditingController(
//       text: authProvider.userProfile?.displayName ?? '',
//     );

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Edit Profile'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: 'Display Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final success = await authProvider.updateProfile(
//                 displayName: nameController.text.trim(),
//               );

//               if (success) {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Profile updated successfully')),
//                 );
//               }
//             },
//             child: Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAccountSettings(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Account Settings'),
//         content: Text('Account settings feature coming soon!'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showNotificationSettings(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Notification Settings'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SwitchListTile(
//               title: Text('Task Reminders'),
//               subtitle: Text('Get notified about upcoming tasks'),
//               value: true,
//               onChanged: (value) {
//                 // TODO: Implement notification settings
//               },
//             ),
//             SwitchListTile(
//               title: Text('Overdue Alerts'),
//               subtitle: Text('Get notified about overdue tasks'),
//               value: true,
//               onChanged: (value) {
//                 // TODO: Implement notification settings
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showLanguageSettings(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Language Settings'),
//         content: Text('Language selection feature coming soon!'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showHelpDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Help & Support'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Need help with TaskMaster Pro?'),
//             SizedBox(height: 16),
//             Text('• Check our FAQ section'),
//             Text('• Contact support: support@taskmaster.com'),
//             Text('• Visit our website for tutorials'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showPrivacyPolicy(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Privacy Policy'),
//         content: Text('Privacy policy content would be displayed here.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showTermsOfService(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Terms of Service'),
//         content: Text('Terms of service content would be displayed here.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAboutDialog(BuildContext context) {
//     showAboutDialog(
//       context: context,
//       applicationName: 'TaskMaster Pro',
//       applicationVersion: '1.0.0',
//       applicationIcon: Icon(
//         Icons.check_circle_outline,
//         size: 48,
//         color: Theme.of(context).colorScheme.primary,
//       ),
//       children: [
//         Text('A powerful task management app built with Flutter and Firebase.'),
//         SizedBox(height: 16),
//         Text('© 2024 TaskMaster Pro. All rights reserved.'),
//       ],
//     );
//   }

//   void _showSignOutDialog(BuildContext context, Function deleteAccountData) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Sign Out'),
//         content: Text('Are you sure you want to sign out?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final authProvider = Provider.of<AuthProvider>(
//                 context,
//                 listen: false,
//               );
//               await deleteAccountData();
//               await authProvider.signOut();

//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => LoginScreen()),
//                 (route) => false,
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: Text('Sign Out'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_clean/assets.dart';
import 'package:task_manager_clean/widgets/ad_page.dart';
import 'package:task_manager_clean/widgets/professional_app_bar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/settings_tile.dart';
import '../auth/login_screen.dart';

class ProfileTab extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    Future<void> deleteAccountData() async {
      final prefs = await SharedPreferences.getInstance();

      // Remove individual keys
      await prefs.remove('userToken');
      await prefs.remove('userEmail');
      await prefs.remove('userId');
      // Add other keys as needed
    }

    return Scaffold(
      appBar: ProfessionalAppBar(
        title: 'Profile',
        showNotifications: true,
        showProfile: false,
        showSubtitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(userProfile: authProvider.userProfile),
            const SizedBox(height: 32),
            _buildSettingsSection(context, themeProvider),

            AdPage(
              title: '50% Off All Items!',
              description:
                  'This weekend only. Don’t miss this limited-time offer.',
              backgroundImage: AppAssets.sales,
              buttonText: 'Shop Now',
              onAction: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
            _buildSupportSection(context),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () async {
                _showSignOutDialog(context, deleteAccountData);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'TaskMaster Pro v1.0.0',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    return _buildCard(
      context,
      children: [
        SettingsTile(
          icon: Icons.person_outline,
          title: 'Account Settings',
          onTap: () => _showAccountSettings(context),
        ),
        _divider(context),
        SettingsTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () => _showNotificationSettings(context),
        ),
        _divider(context),
        SettingsTile(
          icon: themeProvider.isDarkMode
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined,
          title: 'Dark Mode',
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
          onTap: () => themeProvider.toggleTheme(),
        ),

        _divider(context),
        SettingsTile(
          icon: Icons.language_outlined,
          title: 'Language',
          subtitle: 'English',
          onTap: () => _showLanguageSettings(context),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildCard(
      context,
      children: [
        SettingsTile(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () => _showHelpDialog(context),
        ),
        _divider(context),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () => _showPrivacyPolicy(context),
        ),
        _divider(context),
        SettingsTile(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          onTap: () => _showTermsOfService(context),
        ),
        _divider(context),
        SettingsTile(
          icon: Icons.info_outline,
          title: 'About',
          onTap: () => _showAboutDialog(context),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark
            ? theme
                  .colorScheme
                  .surface // light for dark
            : theme.colorScheme.surfaceContainerHighest, // dark for light
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      color: Theme.of(
        context,
      ).dividerColor, // Uses the current theme's dividerColor
      height: 1,
    );
  }

  void _showAccountSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Settings'),
        content: const Text('Account settings feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Task Reminders'),
              subtitle: const Text('Get notified about upcoming tasks'),
              value: true,
              onChanged: (value) {
                // TODO: Implement notification settings
              },
            ),
            SwitchListTile(
              title: const Text('Overdue Alerts'),
              subtitle: const Text('Get notified about overdue tasks'),
              value: true,
              onChanged: (value) {
                // TODO: Implement notification settings
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language Settings'),
        content: const Text('Language selection feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Need help with TaskMaster Pro?'),
            SizedBox(height: 16),
            Text('• Check our FAQ section'),
            Text('• Contact support: support@taskmaster.com'),
            Text('• Visit our website for tutorials'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text('Privacy policy content would be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const Text(
          'Terms of service content would be displayed here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TaskMaster Pro',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.check_circle_outline,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: const [
        Text('A powerful task management app built with Flutter and Firebase.'),
        SizedBox(height: 16),
        Text('© 2024 TaskMaster Pro. All rights reserved.'),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context, Function deleteAccountData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              await deleteAccountData();
              await authProvider.signOut();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
