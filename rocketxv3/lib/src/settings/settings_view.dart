import 'package:flutter/material.dart';
import 'package:rocketxv3/src/policy-view/policy_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  Future<void> logoutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('epassportid'); // Remove saved epassportid

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                logoutUser(context); // Perform logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Theme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ThemeMode>(
              value: controller.themeMode,
              onChanged: controller.updateThemeMode,
              decoration: InputDecoration(
                labelText: 'Theme',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                ),
              ],
            ),
            const SizedBox(height: 32), // Space before the about section
            const Text(
              'About Application',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a futuristic rocket reservation system that allows users to book and manage rocket flights easily and efficiently. Our goal is to make space travel accessible to everyone while ensuring safety and comfort.',
            ),
            const SizedBox(height: 32), // Space before the rules section
            const Text(
              'Rules and Regulations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. All passengers must follow safety protocols at all times.\n'
              '2. No outside food or drinks are allowed on board.\n'
              '3. Passengers must arrive at least 2 hours before departure.\n'
              '4. All bookings are subject to cancellation fees if canceled within 48 hours of departure.\n'
              '5. Any form of misconduct will result in immediate removal from the flight.',
            ),
            const SizedBox(height: 32), // Space before the policy button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PolicyView()),
                  ); // Navigate to the policy page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Privacy Policy & Terms and Conditions',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16), // Space before the logout button
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showLogoutConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            const Spacer(), // Pushes the logout button to the bottom
          ],
        ),
      ),
    );
  }
}
