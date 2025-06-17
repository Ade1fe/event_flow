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
  // ignore: unused_field
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
                'Momentum v1.0.0',
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
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Overdue Alerts'),
              subtitle: const Text('Get notified about overdue tasks'),
              value: true,
              onChanged: (value) {},
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
            Text('Need help with Momentum?'),
            SizedBox(height: 16),
            Text('• Check our FAQ section'),
            Text('• Contact support: support@momentum.com'),
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
      applicationName: 'Momentum',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.check_circle_outline,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: const [
        Text('A powerful task management app built with Flutter and Firebase.'),
        SizedBox(height: 16),
        Text('© 2024 Momentum. All rights reserved.'),
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

              // ignore: use_build_context_synchronously
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
