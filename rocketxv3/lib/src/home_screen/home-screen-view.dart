import 'package:flutter/material.dart';
import 'package:rocketxv3/src/settings/settings_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        titleSpacing: 20,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text(
          'RocketX',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              size: 25,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to RocketX!',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
