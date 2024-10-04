import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date comparison
import 'package:rocketxv3/src/scheduler-screen/schedule-detail-screen.dart';
// To navigate to details screen

class ScheduleScreenView extends StatefulWidget {
  @override
  _ScheduleScreenViewState createState() => _ScheduleScreenViewState();
}

class _ScheduleScreenViewState extends State<ScheduleScreenView> {
  List<dynamic> schedules = []; // Store fetched schedules
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchSchedules(); // Fetch data when the screen initializes
  }

  // Fetch data from the API
  Future<void> fetchSchedules() async {
    final response =
        await http.get(Uri.parse('http://192.168.8.182:8000/api/schedules'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        schedules = data['data']; // Extract schedules from response
        isLoading = false; // Data is fetched, turn off loading indicator
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load schedules');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: null, // Set title to null to use FlexibleSpace for custom layout
        flexibleSpace: Container(
          alignment: Alignment.center, // Center align the content
          child: Text(
            'Schedules',
            style: TextStyle(
              fontSize: 28.0, // Increase font size
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Padding(
              padding: const EdgeInsets.all(16.0), // Padding around the list
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  var schedule = schedules[index];
                  DateTime launchDate = DateFormat('yyyy/MM/dd')
                      .parse(schedule['launch_date_time']);
                  DateTime currentDate = DateTime.now();
                  int daysDifference =
                      launchDate.difference(currentDate).inDays;

                  // Check if the gap between current date and launch date is more than 15 days
                  bool isClickable = daysDifference >= 15;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Rounded corners
                      side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1), // Border color
                    ),
                    elevation: 5, // Slight shadow for better visual appeal
                    margin: EdgeInsets.symmetric(
                        vertical: 8.0), // Margin between cards
                    child: ListTile(
                      tileColor: Colors.black, // Set background color to black
                      contentPadding:
                          EdgeInsets.all(16.0), // Padding inside the card
                      title: Text(
                        schedule['scheduler_name'],
                        style: TextStyle(
                          fontSize: 18.0, // Increased font size
                          fontWeight: FontWeight.bold, // Bold font style
                          color: Colors
                              .white, // Text color for contrast with the black background
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the start
                        children: [
                          Text(
                            'Launch Date: ${schedule['launch_date_time']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: const Color.fromARGB(
                                  255, 184, 211, 63), // Green shade
                            ),
                          ),
                          Text(
                            'Rocket: ${schedule['rocketname']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: const Color.fromARGB(
                                  255, 184, 211, 63), // Green shade
                            ),
                          ),
                          Text(
                            'Space Station: ${schedule['spacestation_name']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: const Color.fromARGB(
                                  255, 184, 211, 63), // Green shade
                            ),
                          ),
                          if (daysDifference < 15)
                            Text(
                              'Less than 15 days to launch',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.redAccent,
                              ),
                            ),
                        ],
                      ),
                      trailing: isClickable
                          ? Icon(Icons.arrow_forward, color: Colors.blue)
                          : Icon(Icons.block, color: Colors.redAccent),
                      onTap: isClickable
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ScheduleDetailScreen(schedule: schedule),
                                ),
                              );
                            }
                          : null, // If less than 15 days, disable click
                    ),
                  );
                },
              ),
            ),
    );
  }
}
