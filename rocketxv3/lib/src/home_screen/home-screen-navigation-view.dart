import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rocketxv3/src/home_screen/home-screen-view.dart';
import 'package:rocketxv3/src/profile-view/profile-view.dart';
import 'package:rocketxv3/src/scheduler-screen/schedule-screen-view.dart';
import 'package:rocketxv3/src/settings/settings_view.dart';
import 'package:rocketxv3/src/view-tickets/view-tickets.dart';
// import 'package:rocketxv3/src/search/search_view.dart'; // Ensure this is added
// import 'package:rocketxv3/src/profile/profile_view.dart'; // Ensure this is added

class HomeScreenNavigation extends StatefulWidget {
  const HomeScreenNavigation({Key? key}) : super(key: key);

  @override
  _HomeScreenNavigationState createState() => _HomeScreenNavigationState();
}

class _HomeScreenNavigationState extends State<HomeScreenNavigation> {
  String userFullName = '';
  Map<String, dynamic>? weatherData;
  int _selectedIndex =
      0; // Track the selected index for the BottomNavigationBar

  // List of screens to navigate to
  final List<Widget> _screens = [
    const HomeScreen(),
    ScheduleScreenView(), // Make sure to add these
    ViewTickets(), // Make sure to add these
    ProfileView(), // Use SettingsView instead of SettingsScreen
  ];

  @override
  void initState() {
    super.initState();
    // Initialize any required data here
  }

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
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch, size: 30),
            label: 'Reserve',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt, size: 30),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online, size: 30),
            label: 'E-Passport',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), // Set the background color to black
        selectedItemColor: const Color.fromARGB(
            255, 143, 7, 7), // Set the selected item color to white
        unselectedItemColor: const Color.fromARGB(
            255, 83, 55, 55), // Optional: Set the unselected item color
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
      ),
    );
  }
}
