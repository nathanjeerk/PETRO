import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _sectionTitle("Account"),
          _settingsItem(context, "Edit Profile", Icons.edit),
          _settingsItem(context, "Notifications", Icons.notifications),
          _settingsItem(context, "Privacy", Icons.lock),
          _settingsItem(context, "Time Zone", Icons.access_time),

          _sectionTitle("Other"),
          _settingsItem(context, "About", Icons.info),
          _settingsItem(context, "Help", Icons.help_outline),
          _settingsItem(context, "Delete Account", Icons.delete, danger: true),

          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text("Log Out"),
            ),
          ),

          const SizedBox(height: 32),
          const Center(
            child: Text("BETA", style: TextStyle(color: Colors.white38)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _settingsItem(
    BuildContext context,
    String title,
    IconData icon, {
    bool danger = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: danger ? Colors.redAccent : Colors.tealAccent),
      title: Text(
        title,
        style: TextStyle(
          color: danger ? Colors.redAccent : Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: () {
        // TODO: Implement actual navigation or dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title tapped')));
      },
    );
  }
}
