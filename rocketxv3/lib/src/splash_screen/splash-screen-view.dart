import 'package:flutter/material.dart';
import 'package:rocketxv3/src/login_screen/login-view.dart';
import 'package:rocketxv3/src/registration_screen/registration-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rocketxv3/src/home_screen/home-screen-view.dart';
// Import your LoginScreen accordingly

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Wait for 15 seconds (your existing splash screen delay)
    await Future.delayed(const Duration(seconds: 3));

    // Fetch SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the value for the 'epassportid' key
    String? epassportid = prefs.getString('epassportid');

    // Navigate to the appropriate screen
    if (epassportid != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/start-animation2.gif', // Adjust the path according to your project structure
              width: 500,
              height: 500,
            ),
            const SizedBox(height: 20),
            Text(
              "RocketX",
              style: TextStyle(
                fontSize: 50,
                color: const Color.fromARGB(249, 0, 0, 0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
