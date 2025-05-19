import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _waterChangeReminders = true;
  bool _feedingReminders = true;
  String _temperatureUnit = 'Fahrenheit';
  String _volumeUnit = 'Gallons';
  String _lengthUnit = 'Inches';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // App Settings
          _buildSectionHeader('App Settings'),
          _buildSwitchTile(
            'Dark Mode',
            _darkMode,
            Icons.dark_mode_outlined,
            (value) => setState(() => _darkMode = value),
          ),
          _buildSwitchTile(
            'Enable Notifications',
            _notificationsEnabled,
            Icons.notifications_none,
            (value) => setState(() => _notificationsEnabled = value),
          ),
          _buildDivider(),
          
          // Reminders
          _buildSectionHeader('Reminders'),
          _buildSwitchTile(
            'Water Change Reminders',
            _waterChangeReminders,
            Icons.water_drop_outlined,
            (value) => setState(() => _waterChangeReminders = value),
          ),
          _buildSwitchTile(
            'Feeding Reminders',
            _feedingReminders,
            Icons.restaurant_outlined,
            (value) => setState(() => _feedingReminders = value),
          ),
          _buildDivider(),
          
          // Units
          _buildSectionHeader('Units'),
          _buildListTileWithDropdown(
            'Temperature',
            _temperatureUnit,
            Icons.thermostat_outlined,
            ['Celsius', 'Fahrenheit'],
            (value) => setState(() => _temperatureUnit = value!),
          ),
          _buildListTileWithDropdown(
            'Volume',
            _volumeUnit,
            Icons.water_drop_outlined,
            ['Liters', 'Gallons'],
            (value) => setState(() => _volumeUnit = value!),
          ),
          _buildListTileWithDropdown(
            'Length',
            _lengthUnit,
            Icons.straighten_outlined,
            ['Centimeters', 'Inches'],
            (value) => setState(() => _lengthUnit = value!),
          ),
          _buildDivider(),
          
          // Account
          _buildSectionHeader('Account'),
          _buildListTile(
            'Change Password',
            Icons.lock_outline,
            () {},
          ),
          _buildListTile(
            'Email Preferences',
            Icons.email_outlined,
            () {},
          ),
          _buildListTile(
            'Privacy Settings',
            Icons.privacy_tip_outlined,
            () {},
          ),
          _buildDivider(),
          
          // Support
          _buildSectionHeader('Support'),
          _buildListTile(
            'Help Center',
            Icons.help_outline,
            () {},
          ),
          _buildListTile(
            'Contact Us',
            Icons.contact_support_outlined,
            () {},
          ),
          _buildListTile(
            'About AquaHaven',
            Icons.info_outline,
            () {},
          ),
          _buildListTile(
            'Rate App',
            Icons.star_border,
            () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
  
  Widget _buildSwitchTile(
    String title,
    bool value,
    IconData icon,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
  
  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
  
  Widget _buildListTileWithDropdown(
    String title,
    String value,
    IconData icon,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
  
  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16);
  }
}
