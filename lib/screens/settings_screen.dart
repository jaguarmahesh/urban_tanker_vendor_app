import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/vendor_app_state.dart';
import '../widgets/vendor_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationTrackingEnabled = true;
  bool _analyticsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: AppTheme.surface,
      ),
      body: Consumer<VendorAppState>(
        builder: (context, appState, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Section
                _buildProfileSection(context, appState),
                Divider(
                  height: AppTheme.spacing5,
                  color: AppTheme.border,
                  thickness: 1,
                ),

                // App Settings Section
                _buildSettingsSection(),
                Divider(
                  height: AppTheme.spacing5,
                  color: AppTheme.border,
                  thickness: 1,
                ),

                // Account Section
                _buildAccountSection(),
                Divider(
                  height: AppTheme.spacing5,
                  color: AppTheme.border,
                  thickness: 1,
                ),

                // Support Section
                _buildSupportSection(context),
                Divider(
                  height: AppTheme.spacing5,
                  color: AppTheme.border,
                  thickness: 1,
                ),

                // Logout Section
                _buildLogoutSection(context),

                SizedBox(height: AppTheme.spacing8),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, VendorAppState appState) {
    final vendor = appState.currentUser;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: AppTheme.fontLg,
              fontWeight: AppTheme.fw700,
              color: AppTheme.text,
            ),
          ),
          SizedBox(height: AppTheme.spacing4),
          VendorCard(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: const Icon(
                      Icons.business,
                      size: 40,
                      color: AppTheme.primary,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing3),
                  Text(
                    vendor?.businessName ?? 'Business Name',
                    style: const TextStyle(
                      fontSize: AppTheme.fontBase,
                      fontWeight: AppTheme.fw700,
                      color: AppTheme.text,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing1),
                  Text(
                    vendor?.email ?? 'email@example.com',
                    style: const TextStyle(
                      fontSize: AppTheme.fontXs,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing3),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showEditProfileModal(context),
                          child: const Text('Edit Profile'),
                        ),
                      ),
                      SizedBox(width: AppTheme.spacing2),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showChangePasswordModal(context),
                          child: const Text('Change Password'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App Settings',
            style: TextStyle(
              fontSize: AppTheme.fontLg,
              fontWeight: AppTheme.fw700,
              color: AppTheme.text,
            ),
          ),
          SizedBox(height: AppTheme.spacing3),
          _buildSettingTile(
            'Notifications',
            'Receive order and delivery updates',
            _notificationsEnabled,
            (value) => setState(() => _notificationsEnabled = value),
          ),
          _buildSettingTile(
            'Location Tracking',
            'Allow real-time location sharing',
            _locationTrackingEnabled,
            (value) => setState(() => _locationTrackingEnabled = value),
          ),
          _buildSettingTile(
            'Analytics',
            'Help improve app with usage data',
            _analyticsEnabled,
            (value) => setState(() => _analyticsEnabled = value),
          ),
          SizedBox(height: AppTheme.spacing4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Language',
                style: TextStyle(
                  fontSize: AppTheme.fontSm,
                  fontWeight: AppTheme.fw600,
                  color: AppTheme.text,
                ),
              ),
              SizedBox(height: AppTheme.spacing2),
              DropdownButton<String>(
                value: _selectedLanguage,
                isExpanded: true,
                items: ['English', 'Tamil', 'Hindi']
                    .map((lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedLanguage = value);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account',
            style: TextStyle(
              fontSize: AppTheme.fontLg,
              fontWeight: AppTheme.fw700,
              color: AppTheme.text,
            ),
          ),
          SizedBox(height: AppTheme.spacing3),
          _buildSettingItem(
            Icons.verified_user,
            'Verification Status',
            'Account verified',
            AppTheme.success,
          ),
          SizedBox(height: AppTheme.spacing2),
          _buildSettingItem(
            Icons.payment,
            'Payment Method',
            'Bank Account on file',
            AppTheme.primary,
          ),
          SizedBox(height: AppTheme.spacing2),
          _buildSettingItem(
            Icons.calendar_today,
            'Account Created',
            'August 28, 2025',
            AppTheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Support',
            style: TextStyle(
              fontSize: AppTheme.fontLg,
              fontWeight: AppTheme.fw700,
              color: AppTheme.text,
            ),
          ),
          SizedBox(height: AppTheme.spacing3),
          _buildSettingButton(
            Icons.help_outline,
            'Help & FAQs',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Help Center...')),
              );
            },
          ),
          SizedBox(height: AppTheme.spacing2),
          _buildSettingButton(
            Icons.message_outlined,
            'Contact Support',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening support chat...')),
              );
            },
          ),
          SizedBox(height: AppTheme.spacing2),
          _buildSettingButton(
            Icons.description_outlined,
            'Terms & Conditions',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Terms & Conditions...')),
              );
            },
          ),
          SizedBox(height: AppTheme.spacing2),
          _buildSettingButton(
            Icons.privacy_tip_outlined,
            'Privacy Policy',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Privacy Policy...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showLogoutDialog(context),
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.danger,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing3),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSm,
                    fontWeight: AppTheme.fw600,
                    color: AppTheme.text,
                  ),
                ),
                SizedBox(height: AppTheme.spacing1),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppTheme.fontXs,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        SizedBox(width: AppTheme.spacing3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppTheme.fontSm,
                  fontWeight: AppTheme.fw600,
                  color: AppTheme.text,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: AppTheme.fontXs,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingButton(
    IconData icon,
    String title, {
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 22),
          ),
          SizedBox(width: AppTheme.spacing3),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: AppTheme.fontSm,
                fontWeight: AppTheme.fw600,
                color: AppTheme.text,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppTheme.textMuted,
          ),
        ],
      ),
    );
  }

  void _showEditProfileModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Business Name',
              ),
            ),
            SizedBox(height: AppTheme.spacing3),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(height: AppTheme.spacing3),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            SizedBox(height: AppTheme.spacing3),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: AppTheme.spacing3),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<VendorAppState>().logout();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
