import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String epassportid = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';
  String age = '';
  String occupation = '';
  String nationality = '';
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  Future<void> _fetchCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    epassportid = prefs.getString('epassportid') ?? '';

    final String apiUrl =
        'http://192.168.8.182:8000/api/customers/$epassportid';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          firstName = jsonResponse['first_name'];
          lastName = jsonResponse['last_name'];
          phoneNumber = jsonResponse['phone_number'];
          email = jsonResponse['email'];
          age = jsonResponse['age'].toString();
          occupation = jsonResponse['occcupation'];
          nationality = jsonResponse['nationality'];
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load customer data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _updateCustomerData() async {
    final String apiUrl =
        'http://192.168.8.182:8000/api/customers/$epassportid';

    final updatedData = {
      'first_name': firstName,
      'last_name': lastName,
      'age': age,
      'occcupation': occupation,
      'nationality': nationality,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
            'E-Passport Profile',
            style: TextStyle(
              fontSize: 28.0, // Increase font size
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Displaying user information in disabled text fields
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: epassportid,
                        decoration: InputDecoration(
                          labelText: 'E-Passport ID',
                          border: OutlineInputBorder(),
                        ),
                        enabled: false, // Disable editing
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        initialValue: phoneNumber,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        enabled: false, // Disable editing
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        initialValue: email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        enabled: false, // Disable editing
                      ),
                      SizedBox(height: 16),
                    ],
                  ),

                  // Form for updating other details
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: firstName,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => firstName = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          initialValue: lastName,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => lastName = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          initialValue: age,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => age = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter age';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          initialValue: occupation,
                          decoration: InputDecoration(
                            labelText: 'Occupation',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => occupation = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter occupation';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          initialValue: nationality,
                          decoration: InputDecoration(
                            labelText: 'Nationality',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => nationality = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter nationality';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Save button
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _updateCustomerData();
                            }
                          },
                          child: Text('Save Changes'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
