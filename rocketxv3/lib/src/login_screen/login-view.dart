import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _epassportid = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Create a FocusNode for the E-Passport ID field
  final FocusNode _epassportFocusNode = FocusNode();

  Future<void> loginUser() async {
    // Use string interpolation to insert the _epassportid into the URL
    final String apiUrl =
        'http://192.168.8.182:8000/api/customer_login/${_epassportid.text}/verify';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      await saveEpassportId(_epassportid.text);
      clearFields();
      // Navigate to Splash Screen
      Navigator.pushReplacementNamed(context, '/splash');
    } else {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed, please try again')),
      );
      clearFields();
    }
  }

  Future<void> saveEpassportId(String epassportid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('epassportid', epassportid);
  }

  Future<void> clearFields() async {
    _epassportid.clear();
    _passwordController.clear();
    // Request focus back to E-Passport ID field
    FocusScope.of(context).requestFocus(_epassportFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50),
                Image.asset(
                  'assets/images/registration_banner.png',
                  height: 120,
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // E-Passport ID Field
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _epassportid,
                          focusNode: _epassportFocusNode, // Set the focus node
                          decoration: InputDecoration(
                            labelText: 'E-Passport ID',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your E-Passport ID';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Password Field
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true, // Hide password input
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Login Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          width: double.infinity, // Full width button
                          height: 50, // Taller button
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                loginUser();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                            ),
                            child: const Text('Login'),
                          ),
                        ),
                      ),
                      // Link to Registration Screen
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Don\'t have an account? Register',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _epassportid.dispose();
    _passwordController.dispose();
    _epassportFocusNode.dispose(); // Dispose of the focus node
    super.dispose();
  }
}
