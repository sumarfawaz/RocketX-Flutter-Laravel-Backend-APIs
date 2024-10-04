import 'package:flutter/material.dart';
import 'package:rocketxv3/src/home_screen/home-screen-navigation-view.dart';
import 'package:rocketxv3/src/login_screen/login-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _connectionStatus = 'Checking connectivity...';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _checkNetworkConnectivity();
  }

  Future<void> _checkLoginStatus() async {
    // Wait for 3 seconds (your existing splash screen delay)
    await Future.delayed(const Duration(seconds: 15));

    // Fetch SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the value for the 'epassportid' key
    String? epassportid = prefs.getString('epassportid');

    // Navigate to the appropriate screen
    if (epassportid != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreenNavigation()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
  }

  Future<void> _checkNetworkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        _connectionStatus = 'Connected to Mobile Network';
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        _connectionStatus = 'Connected to Wi-Fi';
      });
    } else {
      setState(() {
        _connectionStatus = 'No Internet Connection';
      });
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
            const SizedBox(height: 20),
            // Display connectivity status
            // Text(
            //   _connectionStatus,
            //   style: TextStyle(fontSize: 20, color: Colors.black),
            // ),
          ],
        ),
      ),
    );
  }
}
