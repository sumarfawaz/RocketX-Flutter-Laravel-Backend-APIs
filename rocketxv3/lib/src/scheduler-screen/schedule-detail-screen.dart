import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> schedule; // Passed schedule data

  ScheduleDetailScreen({required this.schedule});

  // Get Rocket Image Function
  String getRocketImage(String rocketName) {
    if (rocketName.contains('Falcon')) {
      return 'assets/images/falcon.png';
    } else if (rocketName.contains('SpaceX')) {
      return 'assets/images/spacex.png';
    } else if (rocketName.contains('CHI')) {
      return 'assets/images/china_flag.png';
    }
    return 'assets/images/default.png'; // Default image
  }

  // Get Space Station Image Function
  String spaceStationImage(String spaceStationName) {
    if (spaceStationName.contains('Mars')) {
      return 'assets/images/mars.jpg';
    } else if (spaceStationName.contains('Saturn')) {
      return 'assets/images/saturn.png';
    } else if (spaceStationName.contains('Uranus')) {
      return 'assets/images/uranus.png';
    } else if (spaceStationName.contains('Jupiter')) {
      return 'assets/images/jupiter.jpg';
    }
    return 'assets/images/planet.png'; // Default image
  }

  Future<void> _getTicket(BuildContext context) async {
    // Check if passengers are available
    if (schedule['passengers'] <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No passengers available to book a ticket!'),
        ),
      );
      return;
    }

    // Get epassportid from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String epassportid = prefs.getString('epassportid') ?? '';

    // Prepare the API request
    final String apiUrl = 'http://192.168.8.182:8000/api/tickets';
    final Map<String, dynamic> requestBody = {
      'epassportid': epassportid,
      'scheduler_name': schedule['scheduler_name'],
      'total_price': schedule['price'],
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        // Successfully booked the ticket
        _showSuccessDialog(context); // Show success dialog
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book ticket: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  // Show success dialog
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ticket Booked'),
        content: Text('Your ticket has been booked successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context)
                  .pushReplacementNamed('/splash'); // Navigate to view-tickets
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(schedule['scheduler_name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rocket Name and Image as ListTile
            _buildListTile(
              title: 'Rocket Name: ${schedule['rocketname']}',
              image: getRocketImage(schedule['rocketname']),
            ),
            SizedBox(height: 10),

            // Space Station Name and Image as ListTile
            _buildListTile(
              title: 'Space Station: ${schedule['spacestation_name']}',
              image: spaceStationImage(schedule['spacestation_name']),
            ),
            SizedBox(height: 20),

            // Launch Date as ListTile
            _buildListTile(
              title: 'Launch Date: ${schedule['launch_date_time']}',
            ),
            SizedBox(height: 10),

            // Price as ListTile
            _buildListTile(
              title: 'Price: \$${schedule['price']}',
            ),
            SizedBox(height: 10),

            // // Passengers as ListTile
            // _buildListTile(
            //   title: 'Passengers: ${schedule['passengers']}',
            // ),
            SizedBox(height: 20),

            SizedBox(height: 100), // Add space for the button
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () =>
              _getTicket(context), // Call the function to get a ticket
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(
            'Get Ticket',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  // Function to build a styled ListTile with border and shadow
  Widget _buildListTile(
      {required String title, String? image, bool isSmallText = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: isSmallText ? 14 : 18,
            fontWeight: isSmallText ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        trailing: image != null
            ? CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(image),
              )
            : null,
      ),
    );
  }
}
