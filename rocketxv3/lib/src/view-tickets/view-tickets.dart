import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ViewTickets extends StatefulWidget {
  @override
  _ViewTicketsState createState() => _ViewTicketsState();
}

class _ViewTicketsState extends State<ViewTickets> {
  List<dynamic> tickets = []; // To hold the tickets data
  bool isLoading = true; // To show loading indicator

  @override
  void initState() {
    super.initState();
    _fetchTickets(); // Fetch tickets when the widget is initialized
  }

  Future<void> _fetchTickets() async {
    // Get epassportid from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String epassportid = prefs.getString('epassportid') ?? '';

    // Prepare the API request
    final String apiUrl = 'http://192.168.8.182:8000/api/tickets';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status']) {
          // Filter tickets by epassportid
          tickets = jsonResponse['data'].where((ticket) {
            return ticket['epassportid'] == epassportid;
          }).toList();
        } else {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jsonResponse['message']),
            ),
          );
        }
      } else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load tickets: ${response.body}'),
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
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching
      });
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
            'Tickets',
            style: TextStyle(
              fontSize: 28.0, // Increase font size
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : tickets.isEmpty
              ? Center(child: Text('No tickets available.')) // No tickets found
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      color: Colors.black, // Card background color
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.all(16.0), // Padding inside ListTile
                        title: Text(
                          'Scheduler: ${ticket['scheduler_name']}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 25, 104, 223),
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0), // Padding for subtitle
                              child: Text(
                                'Total Price: \$${ticket['total_price']}',
                                style: TextStyle(
                                  color: Colors.yellow, // Subtitle text color
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0), // Padding for subtitle
                              child: Text(
                                'Created At: ${ticket['created_at']}',
                                style: TextStyle(
                                  color: Colors.yellow, // Subtitle text color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
